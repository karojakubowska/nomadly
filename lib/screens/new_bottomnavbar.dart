import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/home_view.dart';

class NewBottomNavBar extends StatefulWidget {
  NewBottomNavBar({required this.screens});

  static const Tag = "NewBottomNavBar";
  final List<Widget> screens;
  @override
  State<StatefulWidget> createState() {
    return _NewBottomNavBarState();
  }
}

class _NewBottomNavBarState extends State<NewBottomNavBar> {
  int _currentIndex = 0;
  Widget currentScreen = HomeTest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
              icon: new Icon(Icons.favorite_border_outlined), label: ""),
          // BottomNavigationBarItem(
          //     icon: new Icon(Icons.bed_sharp), label: ""),
          BottomNavigationBarItem(
              icon: new Icon(Icons.card_travel_rounded), label: ""),
          BottomNavigationBarItem(icon: new Icon(Icons.chat_outlined), label: ""),
          BottomNavigationBarItem(icon: new Icon(Icons.person), label: "")
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
