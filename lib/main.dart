import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/auth/screens/splash_screen.dart';
import 'package:pattarya_samajam/config/routes_name.dart';
import 'package:pattarya_samajam/utils/theme.dart';

import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeDataPrimary.primaryTheme,
      onGenerateRoute: PageRoutes.generateRoute,
      initialRoute: splashScreen,

    );
  }
}
