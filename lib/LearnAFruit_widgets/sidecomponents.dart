/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SideBarMain.dart';
import 'sidewidgets.dart';

//reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
//Creating the building block of About Us Side Navigation
class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<Paginization>(
        create: (context) => Paginization(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<Paginization, PageState>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
