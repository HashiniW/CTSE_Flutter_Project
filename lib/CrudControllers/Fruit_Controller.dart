/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya, W.G.M.V.S Wijesundara - IT17035118
Description : Creating the firebase fruit object to set all the data to the notify classes
Reference-1 :  https://github.com/JulianCurrie/CwC_Flutter
Reference-2 : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3 : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4 : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
*/

import 'dart:collection';
import 'package:finalproject/Crudmodel/FruitCrudModel.dart';
import 'package:finalproject/Crudmodel/UserCrudModel.dart';
import 'package:flutter/cupertino.dart';

//creating the Fruit details list  controller class for fruit object handling
class FruitController with ChangeNotifier {
  
  //creating a list object to store private fruit details
  List<FruitCrudModel> _fruitList = [];
  
  //creating a list object to store private user details
  List<UserCrudModel> _userList= [];
  
  //creating a object to store private current loading fruit details
  FruitCrudModel _currentFruit;
  
  //creating a  object to store private after login user details in current session
  UserCrudModel _currentUser;
  
  //creating a list view to get fruit details
  UnmodifiableListView<FruitCrudModel> get fruitList => UnmodifiableListView(_fruitList);
  
  //creating a list view to get user details
  UnmodifiableListView<UserCrudModel> get userList => UnmodifiableListView(_userList);
  
  //getting the current fruit details
  FruitCrudModel get currentFruit => _currentFruit;
  
  //getting the current user details
  UserCrudModel get currentUser => _currentUser;

  //creating the fruit details setter object to set the fruit data
  set fruitList(List<FruitCrudModel> fruitList) {
    _fruitList = fruitList;
    notifyListeners();
  }
  
  //creating the user details setter object to set the user data
  set userList(List<UserCrudModel> userList) {
    _userList = userList;
    notifyListeners();
  }
  
  //creating the current loading fruit details setter object to set its relevant fruit data
  set currentFruit(FruitCrudModel fruit) {
    _currentFruit = fruit;
    notifyListeners();
  }

 //creating the current loading user details setter object to set its relevant user data after authentication
  set currentUser(UserCrudModel user) {
    _currentUser = user;
    notifyListeners();
  }
  
  //creating the adding fruit method to add fruit details to store
  addFruit(FruitCrudModel fruit) {
    _fruitList.insert(0, fruit);
    notifyListeners();
  }
  
  //creating the adding user method to add user details to store
  addUser(UserCrudModel user) {
    _userList.insert(0, user);
    notifyListeners();
  }
  
  //creating the deleting fruit method to delete fruit details from fire cloud store
  deleteFruit(FruitCrudModel fruit) {
    _fruitList.removeWhere((_fruit) => _fruit.id == fruit.id);
    notifyListeners();
  }
  
  //creating the deleting fruit method to delete favorite fruit details from fire cloud store
  deleteFavouriteFruit(FruitCrudModel fruit) {
    _fruitList.removeWhere((_fruit) => _fruit.id == fruit.id);
    notifyListeners();
  }
}
