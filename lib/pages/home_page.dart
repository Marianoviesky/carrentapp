import 'package:carrentapp/widgets/bottom_nav_bar.dart';
import 'package:get/get.dart';
import 'package:carrentapp/widgets/homePage/most_rented.dart';
import 'package:carrentapp/widgets/homePage/top_brands.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carrentapp/pages/searchPage.dart';
import 'package:unicons/unicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    TextEditingController searchController = TextEditingController();

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark; //check if device is in dark or light mode

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: isDarkMode
              ? const Color(0xff06090d)
              : const Color(0xfff8f8f8), //appbar bg color
          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xff070606)
                      : Colors.white, //icon bg color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.asset(
            isDarkMode
                ? 'assets/icons/first.png'
                : 'assets/icons/second.png', //logo
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.05,
              ),
              child: SizedBox(
                height: size.width * 0.1,
                width: size.width * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff070606)
                        : Colors.white, //icon bg color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                 
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: buildBottomNavBar(0, size, isDarkMode),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xff06090d)
                : const Color(0xfff8f8f8), //background color
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.04,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: isDarkMode
                          ? const Color(0xff070606)
                          : Colors.white, //section bg color
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.04,
                          ),
                          child: Align(
                            child: Text(
                              'Louer votre voiture en un temps record',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff3b22a1),
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                          ),
                          child: Align(
                            child: Text(
                              'Profitez du plaisir à conduire ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff3b22a1),
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                            left: size.width * 0.04,
                            bottom: size.height * 0.025,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                height: size.height * 0.06,
                                child: TextField(
                                  //searchbar
                                  controller: searchController,
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                      left: size.width * 0.04,
                                      right: size.width * 0.04,
                                    ),
                                    enabledBorder: textFieldBorder(),
                                    focusedBorder: textFieldBorder(),
                                    border: textFieldBorder(),
                                    hintStyle: GoogleFonts.poppins(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    hintText: 'Rechercher une voiture ',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.025,
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                      String searchText = searchController.text.trim();
                                      if (searchText.isNotEmpty) {
                                        Get.to(() => SearchPage(), arguments: {'query': searchText});
                                      }
                                    },
                                child: Container(
                                  height: size.height * 0.06,
                                  width: size.width * 0.14,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Color(0xff3b22a1), //filters bg color
                                  ),
                                  child: Icon(
                                    UniconsLine.search,
                                    color: Colors.white,
                                    size: size.height * 0.032,
                                  ),
                                ),
                              ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                buildTopBrands(size, isDarkMode),
                buildMostRented(size, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}
