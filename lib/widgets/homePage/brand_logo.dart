import 'package:flutter/material.dart';
import 'package:carrentapp/pages/searchPage.dart';
import 'package:get/get.dart';

Padding buildBrandLogo(Widget image, Size size, bool isDarkMode,String name) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: size.width * 0.03,
    ),
     child: GestureDetector(
    onTap: () {
      String searchText = name;
      if (searchText.isNotEmpty) {
        Get.to(() => SearchPage(), arguments: {'query': searchText});
      }
    },
    child: SizedBox(
      height: size.width * 0.18,
      width: size.width * 0.18,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Center(
          child: image,
        ),
      ),
    ),
     ),
  );
}
