import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:naqashbandi_shazli/screens/counter_screen/counter.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/profile_info.dart';
import '../core/app_colors.dart';
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
          color: AppColors.ivoryColor,
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: Colors.black,
              rippleColor: Colors.grey.shade800,
              haptic: true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.black, width: 1,),
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
                  icon: Icons.home,
                  text: 'Home',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                GButton(
                  icon: Icons.calculate,
                  text: 'Counter',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  backgroundColor: AppColors.antiqueGoldColor,
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
