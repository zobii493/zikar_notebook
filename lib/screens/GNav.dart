import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:naqashbandi_shazli/screens/journey_screen/journey.dart';
import 'package:provider/provider.dart';
import 'package:naqashbandi_shazli/screens/counter_screen/counter.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/profile_info.dart';
import '../core/app_colors.dart';
import '../viewmodel/bottom_nav_provider.dart';
import 'home_screen/homepage.dart';

class BottomNavBar extends StatelessWidget {
  final List<Widget> _screens = [
    MyFrontPage(),
    CounterPage(),
    Journey(),
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
          height: 80,
          color: AppColors.ivoryColor,
          padding: EdgeInsets.symmetric(horizontal: 28,vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: AppColors.emeraldDeepColor,
              rippleColor: Colors.grey.shade800,
              haptic: true,
              tabBorderRadius: 15,
              tabShadow: [BoxShadow(color: AppColors.emeraldColor.withValues(alpha: 0.8))],
              curve: Curves.fastOutSlowIn,
              gap: 1,
              color: Colors.white,
              activeColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              selectedIndex: bottomNavProvider.selectedIndex,
              onTabChange: (index) {
                bottomNavProvider.changeIndex(index);
              },
              tabs: [
                GButton(
                  leading: SvgPicture.asset(
                    'assets/icons/home.svg',
                    width: 20,
                    height: 20,
                  ),
                  text: 'Home',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                GButton(
                  leading: SvgPicture.asset(
                    'assets/icons/beads.svg',
                    width: 22,
                    height: 22,
                  ),
                  text: 'Counter',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                GButton(
                  leading: SvgPicture.asset(
                    'assets/icons/journey.svg',
                    width: 22,
                    height: 22,
                  ),
                  text: 'Journey',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                GButton(
                  leading: SvgPicture.asset(
                    'assets/icons/user.svg',
                    width: 22,
                    height: 22,
                  ),
                  text: 'Profile',
                  backgroundColor: AppColors.antiqueGoldColor,
                  borderRadius: BorderRadius.circular(35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
