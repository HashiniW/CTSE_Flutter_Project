import 'package:flutter/material.dart';
import 'SideBarMain.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */
//reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
//Creating the About Us Page
class AboutUs extends StatelessWidget with PageState {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "About Us",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
