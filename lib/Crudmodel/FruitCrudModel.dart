/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the fruit crud model to perform crud operations
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:cloud_firestore/cloud_firestore.dart';

//creating the class to create the attributes for the fruit crud model to handle the fruit details
class FruitCrudModel {
  
  //declare string unique id for the each fruit crud
  String id;
  
  //declare string name for the each fruit crud
  String name;
  
  //declare string fruit category for the each fruit family crud
  String category;
  
  //declare string image url for the each fruit crud
  String image;
  
  //declare list for available countries to store multiple countries at once for each fruit
  List countries = [];
  
  //declare creating time to record the created time for the each fruit crud
  Timestamp createdAt;
  
  //declare updating time to record the updated time for the each fruit crud
  Timestamp updatedAt;

  //default constructor implementation
  FruitCrudModel();

  //mapping the string based json data to document using the fruit crud model
  FruitCrudModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    countries = data['countries'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
 
 //returning the created data using fruit crud model
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'countries': countries,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


}
