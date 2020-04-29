/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya, W.G.M.V.S Wijesundara  IT17035118
description : Creating the page navigation handler
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:finalproject/DisplayUI/ProfilePageDisplay.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:finalproject/LearnAFruit_widgets/SideBarMain.dart';
import 'package:finalproject/LearnAFruit_widgets/sidecomponents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'MainPageDisplay.dart';


//creating the ui screen to load all footer bar and page navigation handler in main screen view and handle the state
class UICollectionHandler extends StatefulWidget {
  @override
  _UICollectionHandlerState createState() => _UICollectionHandlerState();
}

//creating the ui screen to load all footer bar and page navigation handler in main screen view
class _UICollectionHandlerState extends State<UICollectionHandler> with PageState {
  //creating private page controller to route for relevant page
  PageController _pageController;
  
  //creating private pages count
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Constants.appName,
          ),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),

        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            HomeScreenUI(),
            FavoriteScreen(),
            ProfileUI(isUpdating: false),
            SideBarLayout(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width:7),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 24.0,
                ),
                color: _page == 0
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(0),
              ),

              IconButton(
                icon:Icon(
                  Icons.favorite,
                  size: 24.0,
                ),
                color: _page == 1
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                color: _page == 2
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(2),
              ),
              IconButton(
                icon:Icon(
                  Icons.apps,
                  size: 24.0,
                ),
                color: _page == 3
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(3),
              ),

              SizedBox(width:7),
            ],
          ),
        ),
      ),
    );
  }
  
  //handle the relevant page routing when tap on the relevant icon with int page number
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
 
 //set the initial state as the page controller state to show relevant page at once
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
 
 //close the page after disposing
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  
  //set the page value to the state when tap on the icon in below footer
  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
