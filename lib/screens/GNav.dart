import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:naqashbandi_shazli/screens/counter_screen/counter.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/profile_info.dart';
import '../provider/bottom_nav_provider.dart';
import 'home_screen/homepage.dart';

class BottomNavBar extends StatelessWidget {
  final List<Widget> _screens = [
    MyFrontPage(),
    CounterPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return bottomNavProvider.handleWillPop(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
        });
      },
      child: Scaffold(
        body: _screens[bottomNavProvider.selectedIndex],
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
              selectedIndex: bottomNavProvider.selectedIndex,
              onTabChange: (index) {
                bottomNavProvider.changeIndex(index);
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
