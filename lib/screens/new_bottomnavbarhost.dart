import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/home_view.dart';

class NewBottomNavBarHost extends StatefulWidget {
  NewBottomNavBarHost({required this.screens});

  static const Tag = "NewBottomNavBar";
  final List<Widget> screens;

  @override
  State<StatefulWidget> createState() {
    return _NewBottomNavBarHostState();
  }
}

class _NewBottomNavBarHostState extends State<NewBottomNavBarHost> {
  int _currentIndex = 0;
  Widget currentScreen = const HomeTest();

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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "")
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
