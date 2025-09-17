import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:naqashbandi_shazli/screens/counter_screen/counter.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/profile_info.dart';

import 'home_screen/homepage.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  BottomNavBar({required this.selectedIndex, required this.onTabChange});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  DateTime? lastPressedTime; // back button double press ke liye

  final List<Widget> _screens = [
    MyFrontPage(),
    CounterPage(),
    ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      // agar HomePage par nahi ho to HomePage par le jao
      setState(() {
        _selectedIndex = 0;
      });
      return false; // exit mat karo
    } else {
      // agar already HomePage par ho
      final now = DateTime.now();
      if (lastPressedTime == null ||
          now.difference(lastPressedTime!) > Duration(seconds: 2)) {
        // pehli dafa back press → warning dikhani hai
        lastPressedTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Press back again to exit"),
            duration: Duration(seconds: 2),
          ),
        );
        return false; // abhi exit mat karo
      }
      return true; // 2 second ke andar dobara press → exit app
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          height: 90,
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: Colors.black,
              rippleColor: Colors.grey.shade800,
              haptic: true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.black, width: 1),
              tabBorder: Border.all(color: Colors.black, width: 1),
              tabShadow: [BoxShadow(color: Colors.white24)],
              curve: Curves.fastOutSlowIn,
              gap: 1,
              color: Colors.white,
              activeColor: Colors.black,
              iconSize: 30,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: HugeIcons.strokeRoundedHome05,
                  text: 'Home',
                  backgroundColor: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                GButton(
                  icon: HugeIcons.strokeRoundedCalculate,
                  text: 'Counter',
                  backgroundColor: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                GButton(
                  icon: HugeIcons.strokeRoundedUser,
                  text: 'Profile',
                  backgroundColor: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
