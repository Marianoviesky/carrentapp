import 'package:carrentapp/pages/searchPage.dart';
import 'package:carrentapp/widgets/homePage/brand_logo.dart';
import 'package:carrentapp/widgets/homePage/category.dart';
import 'package:flutter/material.dart';

Column buildTopBrands(Size size, bool isDarkMode) {
  return Column(
    children: [
      buildCategory('Top Marques', size, isDarkMode,SearchPage()),
      Padding(
        padding: EdgeInsets.only(top: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBrandLogo(
              Image.asset(
                'assets/icons/hyundai.png',
                height: size.width * 0.1,
                width: size.width * 0.15,
                fit: BoxFit.fill,
              ),
              size,
              isDarkMode,
              "hyundrai"
            ),
            buildBrandLogo(
              Image.asset(
                'assets/icons/volkswagen.png',
                height: size.width * 0.12,
                width: size.width * 0.12,
                fit: BoxFit.fill,
              ),
              size,
              isDarkMode,
              "volkswagen"
            ),
            buildBrandLogo(
              Image.asset(
                'assets/icons/toyota.png',
                height: size.width * 0.08,
                width: size.width * 0.12,
                fit: BoxFit.fill,
              ),
              size,
              isDarkMode,
              "toyota"
            ),
            buildBrandLogo(
              Image.asset(
                'assets/icons/bmw.png',
                height: size.width * 0.12,
                width: size.width * 0.12,
                fit: BoxFit.fill,
              ),
              size,
              isDarkMode,
              "bmw"
            ),
          ],
        ),
      ),
    ],
  );
}
