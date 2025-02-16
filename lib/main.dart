import 'package:dostrobajar/constants/pages.dart';
import 'package:dostrobajar/screens/add_product.dart';
import 'package:dostrobajar/screens/homepage.dart';
import 'package:dostrobajar/screens/productprofile.dart';
import 'package:dostrobajar/screens/intro_screen.dart';
import 'package:dostrobajar/screens/splash_screen.dart';
import 'package:dostrobajar/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'provider/product_provider.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/warehouse.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wfllxhxnsjnsughmkhjd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmbGx4aHhuc2puc3VnaG1raGpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2MTcxMTgsImV4cCI6MjA1NTE5MzExOH0.DfOL9FBC_5W4VdOMm1bOvOduPdIHRQO9WB_LoXWsYsU',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        routes: {
          Routes.splashScreen: (context) => SplashScreen(), // First Screen
          Routes.introScreen: (context) => IntroScreen(),
          Routes.home: (context) => HomePage(),
          Routes.productProfile: (context) => ProductProfilePage(),
          Routes.warehouse: (context) => WarehousePage(),
          Routes.addProductPAge: (context) => AddProductPage(),
          Routes.login: (context) => LoginScreen(),
          Routes.register: (context) => RegisterScreen(),
        },
        initialRoute: Routes.splashScreen,
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
      ),
    );
  }
}
