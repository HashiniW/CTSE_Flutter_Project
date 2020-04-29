/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
Description : Creating the main screen to direct to the favorite fruit list
Reference-1 : https://github.com/whatsupcoders/Flutter-ImageUpload
Reference-2 : https://apkpure.com/flutter-mobile-restaurant-
ui-kit/com.jideguru.restaurant_ui_kit 
*/

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavouriteDetails.dart';
import 'details.dart';
import 'LoginPageDisplay.dart';
import 'UICollectionHandler.dart';

//creating the class to surf as the main screen for to go the favorite fruit list  and manage the state of the page
class FavoriteScreen extends StatefulWidget {
  @override
  _FavouriteFruitBookState createState() => _FavouriteFruitBookState();
}

//creating the class to surf as the main screen for to go the favorite fruit list
class _FavouriteFruitBookState extends State<FavoriteScreen> {
  
  //maintaining the state of the fruit controller to get favorite fruits list
  @override
  void initState() {
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    getFavouriteFruits(fruitNotifier);
    super.initState();
  }

//calling the authentication class to get the display name
//calling the favorite fruit controller class to get the list of favorite fruits to display
  @override
  Widget build(BuildContext context) {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    FruitController fruitNotifier = Provider.of<FruitController>(context);
    
    //showing the list of favorite fruits in list  view builder
    Future<void> _refreshList() async {
      getFavouriteFruits(fruitNotifier);
    }

    print("Opening Favourite Fruit Book");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return UICollectionHandler();
          })),
        ),
        title: Text(
          
          //if authentic user state isn't null then show the display name as email display name in the appbar
          authNotifier.user != null ? authNotifier.user.displayName + "'s Favourite Fruit Collection": "Your Favourite Collection",
        ),
        actions: <Widget>[
          
          // action button
          FlatButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    authNotifier.setUser(null);
                    return LoginPageDisplayUI();
                  },
                ),
              );
            },
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 22, color: Colors.lightBlue),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                child: Image.network(
                  fruitNotifier.fruitList[index].image != null
                      ? fruitNotifier.fruitList[index].image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: 150,height: 1000,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(fruitNotifier.fruitList[index].name),
              subtitle: Text(fruitNotifier.fruitList[index].category),
              onTap: () {
                fruitNotifier.currentFruit = fruitNotifier.fruitList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return FavouriteDetails();
                }));
              },
            );
          },
          itemCount: fruitNotifier.fruitList.length,
          separatorBuilder: (BuildContext context, int index) {
            InkWell(
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        right: -10.0,
                        bottom: 3.0,
                        child: RawMaterialButton(
                          onPressed: (){},
                          fillColor: Colors.blue,
                          shape: CircleBorder(),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return ProductDetails();
                    },
                  ),
                );
              },
            );

            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}
