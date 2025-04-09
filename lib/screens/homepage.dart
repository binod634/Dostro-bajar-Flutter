import 'package:dostrobajar/components/appbar.dart';
import 'package:dostrobajar/components/leftdrawer.dart';
import 'package:dostrobajar/screens/ecommercepage.dart';
import 'package:dostrobajar/screens/profilepage.dart';
import 'package:dostrobajar/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
  }

  int _currentPage = 0;
  List<Widget> pages = <Widget>[
    EcommercePage(),
    EcommercePage(),
    ProfilePage(),
  ];

  // scaffold keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          print('Auth state changed: ${snapshot.data?.session}');
          print('Auth event changed: ${snapshot.data?.event}');

          if (snapshot.data?.session == null) {
            return LoginScreen(enableGoogleSignIn: false);
          }

          return Scaffold(
            key: _scaffoldKey,
            appBar: myAppBar(
              context,
              onLeadingPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            drawer: returnLeftDrawer(context),
            body: pages[_currentPage],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentPage,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: 'Wishlist',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        });
  }
}
