
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the main screen to direct to the fruit list
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/CrudControllers/authentication_Controller.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail.dart';
import 'fruit_form.dart';

//creating the class to surf as the main screen for to go the fruit list  and manage the state of the page
class FruitBook extends StatefulWidget {
  @override
  _FruitBookState createState() => _FruitBookState();
}

//creating the class to surf as the main screen for to go the fruit list
class _FruitBookState extends State<FruitBook> {
  
  //maintaining the state of the fruit controller to get fruits list
  @override
  void initState() {
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    getFruits(fruitNotifier);
    super.initState();
  }

//calling the authentication class to get the display name
//calling the fruit controller class to get the list of fruits to display
  @override
  Widget build(BuildContext context) {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context);
    FruitController fruitNotifier = Provider.of<FruitController>(context);
    
    //showing the list of fruits in list  view builder
    Future<void> _refreshList() async {
      getFruits(fruitNotifier);
    }

    print("Opening Fruit Book");
    return Scaffold(
      appBar: AppBar(
        title: Text(
         
          //if authentic user state isn't null then show the display name as email display name in the appbar
          authNotifier.user != null ? authNotifier.user.displayName + "'s Fruit Collection" : "Favourite Fruit Book",
        ),
        actions: <Widget>[
          
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.blue),
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
                  return FruitDetail();
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
            );
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fruitNotifier.currentFruit = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return FruitForm(
                isUpdating: false,
              );
            }),
          );
        },
        
        //invoke to create new fruits
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
