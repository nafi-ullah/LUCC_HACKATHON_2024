
import 'package:flutter/material.dart';
import 'package:lucchack/screens/homescreen/homescreen.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );
    // case LoginScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const LoginScreen(),
    //   );
    // case StsManagerHome.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const StsManagerHome(),
    //   );
    // case LandfillMangerHome.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const LandfillMangerHome(),
    //   );


    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
              body: Center(
                child: Text("Screen doesn't exist"),)
          )

      );


  }

}