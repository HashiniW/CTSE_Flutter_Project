
import 'package:bloc/bloc.dart';
import 'sidebarinvoker.dart';
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

//Creating the Abstract class to load About Us


//reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
abstract class PageState {}

class Paginization extends Bloc<NavigationEvents, PageState> {
//get the navigation for about us page first
  @override
  PageState get initialState => AboutUs();

  @override
  Stream<PageState> mapEventToState(event) {
    // TODO: implement mapEventToState
  }
}

class NavigationEvents {
}
