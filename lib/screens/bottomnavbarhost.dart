
import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/add_accommodation_view.dart';
import 'package:nomadly_app/screens/all_bookings_view.dart';
import 'package:nomadly_app/screens/chat_view.dart';
import 'package:nomadly_app/screens/home_host_view.dart';
import 'package:nomadly_app/screens/travel_view.dart';
//import 'package:nomadly_app/screens/reservation_view.dart';
import 'package:nomadly_app/screens/userprofile_view.dart';

import '../utils/app_styles.dart';
import 'home_view.dart';
import 'wishlist_view.dart';


class BottomNavBarHost extends StatefulWidget {
  const BottomNavBarHost({Key? key}) : super(key: key);

  @override
  State<BottomNavBarHost> createState() => _BottomNavBarHostState();
}

class _BottomNavBarHostState extends State<BottomNavBarHost>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _bodyView = <Widget>[
    HomeHostScreen(),
    AllBookingsScreen(),
    AddAccommodationScreen(),
    Chat(),
    UserProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length:5);
  }

  Widget _tabItem(Widget child, {bool isSelected = false}) {
    return AnimatedContainer(
        margin: EdgeInsets.only(top:4,bottom:15),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Styles.pinColor,
              ),
        padding: const EdgeInsets.only(top:12,bottom: 8),
        child: Column(
          children: [
            child,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _icons = const [
      ImageIcon(
        AssetImage("assets/images/home 2.png"),
      ),
      Icon(Icons.calendar_month_outlined),
      Icon(Icons.add_rounded),
      ImageIcon(
        AssetImage("assets/images/mail 1.png"),
      ),
      Icon(Icons.person_outline)
    ];

    return Scaffold(
      extendBody: true,
      body: Center(
        child: _bodyView.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.only(top: 7, left: 12, right: 12, bottom: 19),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
                onTap: (x) {
                  setState(() {
                    _selectedIndex = x;
                  });
                },
                //labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide.none,
                ),
                tabs: [
                  for (int i = 0; i < _icons.length; i++)
                    _tabItem(
                      _icons[i],
                      //_labels[i],
                      isSelected: i == _selectedIndex,
                    ),
                ],
                controller: _tabController),
          ),
        ),
      ),
    );
  }
}
