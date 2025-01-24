import 'package:dostrobajar/components/appbar.dart';
import 'package:dostrobajar/components/leftdrawer.dart';
import 'package:dostrobajar/screens/ecommercepage.dart';
import 'package:dostrobajar/screens/profilepage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  List<Widget> pages = <Widget>[
    EcommercePage(),
    EcommercePage(),
    ProfilePage(),
    // ProfilePage(),
    // SettingsPage(),
  ];

  // scaffold keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
          // NavigationDestination(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Cart',
          // ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // things to add...
          // settings....
          // cart....
          //
        ],
      ),
    );
  }
}
