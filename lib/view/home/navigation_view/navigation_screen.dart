import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';
import 'package:unisport_player_app/view/home/home_view/home_screen.dart';

import '../applied_games_view/applied_games_screen.dart';
import '../favorite_view/favorite_screen.dart';
import '../setting_view/setting_screen.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final List _screenList = [
    HomeScreen(),
    FavouriteScreen(),
    AppliedGamesScreen(),
    SettingScreen(),
  ];
  int currentIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;
  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);
    return Scaffold(
      body: _screenList[currentIndex],
      bottomNavigationBar: NavigationBar(
        // height: 70,
        backgroundColor: dark ? AppColors.kSecondary : AppColors.kGrey,
        indicatorShape: BeveledRectangleBorder(side: BorderSide(color: AppColors.kwhite, width: 0.5)),
        elevation: 5,
        labelBehavior: labelBehavior,
        animationDuration: Duration(milliseconds: 700),
        selectedIndex: currentIndex,
        indicatorColor: dark ? AppColors.kPrimary : AppColors.kSecondary,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Home',
            selectedIcon: Icon(
              Iconsax.home5,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.heart),
            label: 'Favourite',
            selectedIcon: Icon(
              Iconsax.heart5,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.menu),
            label: 'Applied\n\tGames',
            selectedIcon: Icon(
              Iconsax.menu5,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.settings),
            label: 'Setting',
            selectedIcon: Icon(
              CupertinoIcons.settings_solid,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
        ],
      ),
    );
  }
}
