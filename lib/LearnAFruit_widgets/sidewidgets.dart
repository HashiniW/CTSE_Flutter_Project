import 'dart:async';
import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

//Creating the UI Level to Display In About Us
//reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}
//Creating the UI Level to Display In About Us
class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  //declare private animation controller
  AnimationController _animationController;
  //declare checker for whether side bar open or not controller
  StreamController<bool> isSidebarOpenedStreamController;
  //declare handler for sidebar open check
  Stream<bool> isSidebarOpenedStream;
  //declare checker for sidebar close
  StreamSink<bool> isSidebarOpenedSink;
  //declare const variable for duration time for the opening
  final _animationDuration = const Duration(milliseconds: 500);

  ////maintaining the state of the sidebar controllers
  @override
  void initState() {
    super.initState();
    //set the animation duration with assigning to the controller
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    //set the state to open checker to check
    isSidebarOpenedStreamController = PublishSubject<bool>();
    //set the state to open checker to check
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    //set the state to open checker to check
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }
  //method to close the sidebar using cross mark with set the state of all controllers to dispose
  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }
//check the button action and handle the animation with slider of navigation bar
  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
//check if animation complete
    if (isAnimationCompleted) {
      //then display the navigation bar in the whole page
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      //then close the navigation bar from the page
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }
//ui level handler
  @override
  Widget build(BuildContext context) {
    //get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

//display the side bar in the about us screen
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                  ListTile(
                    title: Text(
                      "Vihanga Sankalpa : 4th year 1st Semester Student",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                      leading: CircleAvatar(
                       child   :Image.asset(
                      'assets/v.bmp',
                      width: 670.0,
                      height: 300.0,
                      ),
                        radius: 40,
                      ),
                  ),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),

                      ListTile(
                        title: Text(
                          "Hashini Warnakulasooriya : 4th year 1st Semester Student",
                          style: TextStyle(color: Colors.deepPurple, fontSize: 30, fontWeight: FontWeight.w800),
                        ),
                        leading: CircleAvatar(
                          child   :Image.asset(
                            'assets/hashini.bmp',
                            width: 670.0,
                            height: 300.0,
                          ),
                          radius: 40,
                        ),
                      ),
                    //showing the dark mode white mode changer
                 // reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
                      ListTile(
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      //check whether the  scroller button boolean value true or false and set the app theme into dark value or to light value
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
                          //get the accentColor for the theme
                          activeColor: Theme.of(context).accentColor,
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: MenuWidget(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xFF1BB5FD),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
//creating a clipper class show the attachment icon above in the left side to open the navigation bar
//reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
class MenuWidget extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }
// check whether the clipper is press then open the navigation bar
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
