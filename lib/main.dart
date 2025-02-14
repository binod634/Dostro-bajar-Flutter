import 'package:dostrobajar/constants/pages.dart';
import 'package:dostrobajar/screens/homepage.dart';
import 'package:dostrobajar/screens/productprofile.dart';
import 'package:dostrobajar/screens/intro_screen.dart';
import 'package:dostrobajar/screens/splash_screen.dart';
import 'package:dostrobajar/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.splashScreen: (context) => SplashScreen(),
        Routes.introScreen: (context) => IntroScreen(),
        Routes.home: (context) => HomePage(),
        Routes.productProfile: (context) => ProductProfilePage(),
      },
      initialRoute: Routes.splashScreen,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
    );
  }
}
