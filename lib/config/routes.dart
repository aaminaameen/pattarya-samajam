import 'package:flutter/material.dart';
import 'package:pattarya_samajam/auth/screens/login_screen.dart';
import 'package:pattarya_samajam/config/routes_name.dart';

import '../auth/screens/splash_screen.dart';
import '../home/account/account_details.dart';
import '../home/screen/home_screen.dart';




class PageRoutes {
  static Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SplashScreen(),
        );

      case loginScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const LoginScreen(),
        );

      case homeScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) =>  HomeScreen(phoneNumber: '', uid: '',),
        );
      case accountScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AccountDetails(phoneNumber: ''),
        );
      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'error! no routes',
              ),
            ),
          ),
        );
    }
  }
}
