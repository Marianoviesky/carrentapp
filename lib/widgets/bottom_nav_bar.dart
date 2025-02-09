import 'package:carrentapp/pages/home_page.dart';
import 'package:carrentapp/pages/profile_page.dart';
import 'package:carrentapp/pages/explorer_Page.dart';
import 'package:carrentapp/pages/searchPage.dart';
import 'package:carrentapp/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';


Widget buildBottomNavBar(int currIndex, Size size, bool isDarkMode) {
  return BottomNavigationBar(
    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 12), // Ajustez la taille du texte
    unselectedLabelStyle: const TextStyle(fontSize: 12), // Ajustez la taille du texte
    currentIndex: currIndex,
    backgroundColor: const Color(0x00ffffff),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: isDarkMode ? Colors.indigoAccent : Colors.blue,
    unselectedItemColor: const Color.fromARGB(255, 9, 9, 10),
    onTap: (value) {
      if (value != currIndex) {
        if (value == 0) {
          Get.off(const HomePage());
        }
         if (value == 1) {
          Get.off(ExplorerPage());
        }
         if (value == 2) {
          Get.to(SearchPage());
        }
        if (value == 3) {
          Get.to(const ProfilePage());
        }
      }
    },
    items: [
      buildBottomNavItem(
        UniconsLine.home_alt,
        'Accueil', // Label pour la première page
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.car,
        'Explorer', // Label pour la deuxième page
        isDarkMode,
        size,
      ),
       buildBottomNavItem(
        UniconsLine.search,
        'Rechercher', // Label pour la deuxième page
        isDarkMode,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        'Profile', // Label pour la troisième page
        isDarkMode,
        size,
      )
    ],
  );
}
