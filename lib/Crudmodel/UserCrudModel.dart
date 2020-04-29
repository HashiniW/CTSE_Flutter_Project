/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya, W.G.M.V.S Wijesundara  IT17035118
Description : Creating the fruit crud model to perform crud operations
Reference-1 : https://github.com/JulianCurrie/CwC_Flutter
Reference-2 : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3 : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4 : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:cloud_firestore/cloud_firestore.dart';

//creating the class to create the attributes for the user crud model to handle the user details
class UserCrudModel {
  
  //declare string name for the each user crud  to display after login in main screen
  String displayName;
  
  //declare unique string email for the each user crud
  String email;
  
  //declare string password for the each user crud
  String password;
  
  //declare string image for the each user crud
  String image;
  
  //declare creating time to record the created time for the each user crud
  Timestamp createdAt;
  
  //declare updating time to record the updated time for the each user crud
  Timestamp updatedAt;

  //default constructor implementation
  UserCrudModel();


  //mapping the string based json data to document using the user crud model
  UserCrudModel.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    email = data['email'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  
  //returning the created data using user crud model
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
