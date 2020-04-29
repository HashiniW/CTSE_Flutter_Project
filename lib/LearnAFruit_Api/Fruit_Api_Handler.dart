/*
Authors       : IT17136402 - W.M.H.B. Warnakulasooriya, W.G.M.V.S Wijesundara - IT17035118
Description   : Creating the Crud Functions
Reference-1   : https://github.com/JulianCurrie/CwC_Flutter
Reference-2   : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3   : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4   : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Crudmodel/FruitCrudModel.dart';
import 'package:finalproject/Crudmodel/UserCrudModel.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


login(UserCrudModel user, AuthenticationController authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(UserCrudModel user, AuthenticationController authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthenticationController authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthenticationController authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

//getting the fruits list from the Fruits Collection in cloud store
getFruits(FruitController fruitNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Fruits')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<FruitCrudModel> _fruitList = [];

  snapshot.documents.forEach((document) {
    FruitCrudModel fruit = FruitCrudModel.fromMap(document.data);
    _fruitList.add(fruit);
  });

  fruitNotifier.fruitList = _fruitList;
}

//getting the favorite fruits list from the FFruits Collection in cloud store
getFavouriteFruits(FruitController fruitNotifier) async {
  
  //getting the FFruits collections in decending order of created time
  QuerySnapshot snapshot = await Firestore.instance
      .collection('FFruits')
      .orderBy("createdAt", descending: true)
      .getDocuments();
  
  //store in list the details of the fruits
  List<FruitCrudModel> _fruitList = [];
 
 //adding each fruits into fruit list
  snapshot.documents.forEach((document) {
    FruitCrudModel fruit = FruitCrudModel.fromMap(document.data);
    _fruitList.add(fruit);
  });

  fruitNotifier.fruitList = _fruitList;
}

//upload the image into fruits / images bucket as file format
uploadFruitAndImage(FruitCrudModel fruit, bool isUpdating, File localFile, Function fruitUploaded) async {
  
  //check if local file is null in the image bucket
  if (localFile != null) {
    print("uploading image");
    
    //get the path of the image
    var fileExtension = path.extension(localFile.path);
    print(fileExtension);
    
    //getting the uuid format to store image on buckets
    var uuid = Uuid().v4();
    
    //refer the storage in fruits/images
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('fruits/images/$uuid$fileExtension');
  
  //send to the relevant directory in bucket or catch error
    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });
    
    //get the image url then assign ito url
    String url = await firebaseStorageRef.getDownloadURL();
    
    //print url
    print("download url: $url");
    
    //then invoke the image url method below to add the url in document collection
    _uploadFruit(fruit, isUpdating, fruitUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFruit(fruit, isUpdating, fruitUploaded);
  }
}

//upload fruit image url into the Fruits document collection in the relevant fruit id
_uploadFruit(FruitCrudModel fruit, bool isUpdating, Function fruitUploaded, {String imageUrl}) async {
  CollectionReference fruitRef = Firestore.instance.collection('Fruits');

  if (imageUrl != null) {
    fruit.image = imageUrl;
  }

  if (isUpdating) {
    fruit.updatedAt = Timestamp.now();

    await fruitRef.document(fruit.id).updateData(fruit.toMap());

    fruitUploaded(fruit);
    print('updated fruit with id: ${fruit.id}');
  } else {
    fruit.createdAt = Timestamp.now();

    DocumentReference documentRef = await fruitRef.add(fruit.toMap());

    fruit.id = documentRef.documentID;

    print('uploaded fruit successfully: ${fruit.toString()}');

    await documentRef.setData(fruit.toMap(), merge: true);

    fruitUploaded(fruit);
  }
}

//upload favourite fruit image url into the FFruits document collection in the relevant fruit id
uploadFavouriteFruitAndImage(FruitCrudModel fruit, bool isUpdating, File localFile, Function fruitUploaded) async {
  
  //check if local file is null in the image bucket
  if (localFile != null) {
   print("uploading image");
   
   //get the path of the image
   var fileExtension = path.extension(localFile.path);
    print(fileExtension);
   
   //getting the uuid format to store image on buckets
    var uuid = Uuid().v4();
   
   //refer the storage in ffruits/images
    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('ffruits/images/$uuid$fileExtension');
   
   //send to the relevant directory in bucket or catch error
   await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
   });
   
   //get the image url then assign ito url
    String url = await firebaseStorageRef.getDownloadURL();
   
   //print url
    print("download url: $url");_uploadFavouriteFruit(fruit, isUpdating, fruitUploaded, imageUrl: url);
    print('...skipping image upload');
    
    //invoke upload favourite fruit to add the image url in document collection
    _uploadFavouriteFruit(fruit, isUpdating, fruitUploaded);
  } else {
    
    //then upload image url in collection and update the existing image in bucket
    print('...skipping image upload');
    _uploadFavouriteFruit(fruit, isUpdating, fruitUploaded);
  }
}

_uploadFavouriteFruit(FruitCrudModel fruit, bool isUpdating, Function fruitUploaded, {String imageUrl}) async {
  
  //refer to the FFruits Collection
  CollectionReference fruitRef = Firestore.instance.collection('FFruits');

//check image url is null
  if (imageUrl != null) {
    
    //add fruit image url
    fruit.image = imageUrl;
  }
  
  //if updating the existing
  if (isUpdating) {
    
    //create time for created time
    fruit.createdAt = Timestamp.now();
    
    //refer for fruit add
    DocumentReference documentRef = await fruitRef.add(fruit.toMap());
    
    //catch the id of relevant fruit
    fruit.id = documentRef.documentID;
    
    //print upload success with details
    print('uploaded fruit successfully: ${fruit.toString()}');
   
   //merger all data in collection
    await documentRef.setData(fruit.toMap(), merge: true);
    
    //invoke fruit upload method
    fruitUploaded(fruit);

  } else {
    
    //create time for created time
    fruit.createdAt = Timestamp.now();
    
    //refer for fruit add
    DocumentReference documentRef = await fruitRef.add(fruit.toMap());
    
    //catch the id of relevant fruit
    fruit.id = documentRef.documentID;
    
    //print upload success with details
    print('uploaded fruit successfully: ${fruit.toString()}');
    
    //merger all data in collection
    await documentRef.setData(fruit.toMap(), merge: true);
    
    //invoke fruit upload method
    fruitUploaded(fruit);
  }
}

//method to delete fruit from collection
deleteFruit(FruitCrudModel fruit, Function fruitDeleted) async {
  
  //check whether fruit image null if not
  if (fruit.image != null) {
    
    //refer from image bucket
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(fruit.image);
  
  //print path of the image
    print(storageReference.path);
    
    //delete the image
    await storageReference.delete();
    
    //print as deleted
    print('image deleted');
  }
  
  //delete the fruit details from the Fruits collection using relevant id
  await Firestore.instance.collection('Fruits').document(fruit.id).delete();
  
  //invoke fruit delete method
  fruitDeleted(fruit);
}


//method to delete favorite fruit from collection
deleteFavouriteFruit(FruitCrudModel fruit, Function fruitDeleted) async {
  
  //check whether fruit image null if not
 if (fruit.image != null) {
   
   //refer from image bucket
    StorageReference storageReference =
    await FirebaseStorage.instance.getReferenceFromUrl(fruit.image);
    
    //print path of the image
    print(storageReference.path);
    
    //delete the image
    await storageReference.delete();
    
    //print as deleted
    print('image deleted');
  }
 
 //delete the fruit details from the FFruits collection using relevant id
  await Firestore.instance.collection('FFruits').document(fruit.id).delete();
 
 //invoke fruit delete method
  fruitDeleted(fruit);
}

//upload the image into user / images bucket as file format
uploadUserAndImage(UserCrudModel user, bool isUpdating, File localFile, Function userUploaded) async {
  
  //check if local file is null in the image bucket
  if (localFile != null) {
    print("uploading image");
    
    
    //get the path of the image
    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    //getting the uuid format to store image on buckets
    var uuid = Uuid().v4();

    //refer the storage in users/images
    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users/images/$uuid$fileExtension');

  //send to the relevant directory in bucket or catch error
    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    //get the image url then assign it to url
    String url = await firebaseStorageRef.getDownloadURL();
    
    //print url
    print("download url: $url");
    
    //then invoke the image url method below to add the url in document collection
    _uploadUser(user, isUpdating, userUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadUser(user, isUpdating, userUploaded);
  }
}

//upload user image url into the Users document collection in the relevant user id
_uploadUser(UserCrudModel user, bool isUpdating, Function userUploaded, {String imageUrl}) async {
  CollectionReference userRef = Firestore.instance.collection('Users');

  if (imageUrl != null) {
    user.image = imageUrl;
  }

  if (isUpdating) {
    user.updatedAt = Timestamp.now();

    await userRef.document(user.email).updateData(user.toMap());

    userUploaded(user);
    print('updated fruit with id: ${user.email}');
  } else {
    user.createdAt = Timestamp.now();

    DocumentReference documentRef = await userRef.add(user.toMap());

    user.email = documentRef.documentID;

    print('uploaded user successfully: ${user.toString()}');

    await documentRef.setData(user.toMap(), merge: true);

    userUploaded(user);
  }
}
