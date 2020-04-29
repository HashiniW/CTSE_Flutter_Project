/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
Description : Creating the main screen to direct to the favorite fruit list
Reference-1 : https://github.com/JulianCurrie/CwC_Flutter
Reference-2 : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3 : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4 : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
*/

import 'dart:io';

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/Crudmodel/UserCrudModel.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'UICollectionHandler.dart';

//creating the class to input user details for adding the details of the user
class ProfileUI extends StatefulWidget {
  
  //checking whether needs to update or not
  final bool isUpdating;

  //loading the details to the constructor
  ProfileUI({@required this.isUpdating});

  //handle the user form state
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

//creating the class to input user details for adding the details of the user
class _ProfileUIState extends State<ProfileUI> {
  
  //declaring the global form key to maintain form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //declaring the global scaffold key to maintain scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //creating the current user details object
  UserCrudModel _currentUser;
  String displayName;

  //creating the image url for the user
  String _imageUrl;

  //creating the image file to store in cloud store bucket
  File _imageFile;

  //maintaining the state of the user controller
  @override
  void initState() {
    super.initState();
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);

    //checking if current user object is null then load the current details
    if (fruitNotifier.currentUser != null) {
      _currentUser = fruitNotifier.currentUser;
    } else {
      _currentUser = UserCrudModel();
    }
    _imageUrl = _currentUser.image;
  }

  //check if the the file and image url is null then show in the placeholder as image placeholder otherwise print in console as showing image from local file
  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text(" ");
    } else if (_imageFile != null) {
      print('showing image from local file');

      //designing the ui level
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  //getting the image file from image gallery to load image in the placeholder
  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  //getting the image file from mobile camera to load image in the placeholder
  _openCamera() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  //handle the name field with validation using text form controller
  Widget _buildNameField() {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    return TextFormField(
      decoration: InputDecoration(labelText: 'User Name'),
      initialValue:  authNotifier.user != null ?  authNotifier.user.displayName : "Feed",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentUser.displayName = value;
      },
    );
  }

  //handle the email field with validation using text form controller
  Widget _buildEmailField() {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      initialValue: authNotifier.user != null ?  authNotifier.user.email : "Null",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _currentUser.email = value;
      },
    );
  }

  //sending the uploaded user details to add to the cloud store
  _onUserUploaded(UserCrudModel user) {
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    fruitNotifier.addUser(user);
    Navigator.pop(context);
  }

   //save the current state of the form text forms
  _saveUser() {
    print('saveUser Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadUserAndImage(_currentUser, widget.isUpdating, _imageFile, _onUserUploaded);

    print("displayName: ${_currentUser.displayName}");
    print("email: ${_currentUser.email}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return UICollectionHandler();
            })),
          ),
          title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit User" : "Create User Photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(children: <Widget>[
                      Align(alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _openCamera();
                          },),
                      ),
                    ],),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _getLocalImage();
                      },),
                  ),
                )
              ],
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildEmailField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

              ],
            ),
            SizedBox(height: 16),

            //reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
            //this method switches the theme type to dark mode to white mode vise versa using app 
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              trailing: Switch(
                value: Provider.of<LearnAFruitProvider>(context).theme == Constants.lightTheme
                    ? false
                    : true,
                onChanged: (v) async{
                  if (v) {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.darkTheme, "dark");
                  } else {
                    Provider.of<LearnAFruitProvider>(context, listen: false)
                        .setTheme(Constants.lightTheme, "light");
                  }
                },
                activeColor: Theme.of(context).accentColor,
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveUser();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );

  }
}



