/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
Description : Creating the favorite fruit detail class show details of the each favorite fruits
Reference-1 : https://github.com/JulianCurrie/CwC_Flutter
Reference-2 : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3 : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4 : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/Crudmodel/FruitCrudModel.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

//creating the class to display the favorite fruit details from each favorite fruits with update delete adding favorite list actions in fruit main screen
class FavouriteDetails extends StatelessWidget {
  
  //checking whether needs to update or not
  final bool isUpdating;
  
  //loading the updateble details to the constructor
  FavouriteDetails({@required this.isUpdating});
  
  //declaring the global scaffold key to maintain scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //creating the text controller in form section to add new countries to the list of the each favorite fruit
  TextEditingController countriesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    //calling the favorite fruit controller class
    FruitController fruitNotifier = Provider.of<FruitController>(context);

    //calling the delete favorite fruit method when invoke the onfruitdeleted method
    _onFruitDeleted(FruitCrudModel fruit) {
      Navigator.pop(context);
      fruitNotifier.deleteFavouriteFruit(fruit);
    }
    
    //design the ui level
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(fruitNotifier.currentFruit.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[

                //showing the relevant favorite fruit image for each favorite fruit detail page or providing to enter new
                Image.network(
                  fruitNotifier.currentFruit.image != null
                      ? fruitNotifier.currentFruit.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),

                //showing the relevant favorite fruit name for each favorite fruit detail page or providing to enter new
                Text(
                  fruitNotifier.currentFruit.name,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),

                //showing the relevant favorite fruit family name for each favorite fruit detail page or providing to enter new
                Text(
                  'Fruit Family: ${fruitNotifier.currentFruit.category}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),

                //showing the relevant favorite fruit multiple countries for each favorite fruit detail page  to enter new
                Text(
                  "Available Countries",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(height: 16),

                //showing the added countries in the list before update
                GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: fruitNotifier.currentFruit.countries
                      .map(
                        (ingredient) => Card(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          ingredient,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 20),

          //page button action  to the delete details of the relevant favorite fruit
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteFruit(fruitNotifier.currentFruit, _onFruitDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
