import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:carrentapp/pages/details_page.dart';
import 'package:carrentapp/widgets/bottom_nav_bar.dart';



class ExplorerPage extends StatefulWidget {
  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  TextEditingController _searchController = TextEditingController();
  CollectionReference cars = FirebaseFirestore.instance.collection('cars');
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
       appBar: AppBar(
        title: Text(
          "Explorer",
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color(0xff06090d)
            : const Color(0xfff8f8f8),
        elevation: 0,
        centerTitle: true,
      
      ),
      bottomNavigationBar: buildBottomNavBar(1, size, isDarkMode),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.75,
                    height: size.height * 0.06,
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.04,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        hintText: 'Rechercher une voiture ',
                      ),
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.14,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xff3b22a1),
                    ),
                    child: Icon(
                      UniconsLine.search,
                      color: Colors.white,
                      size: size.height * 0.032,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: cars.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erreur de chargement"));
                }
                var data = snapshot.data;
                var filteredCars = data!.docs.where((car) {
                  return car['carName']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredCars.length,
                  itemBuilder: (context, i) {
                    return Container(
                      width: double.infinity,
                      child: buildCars(i, size, isDarkMode, data),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





Padding buildCars(int i, Size size, bool isDarkMode, data) {
  return Padding(
    padding: EdgeInsets.only(
      right: size.width * 0.03,
    ),
    child: Center(
      child: SizedBox(
        height: size.width * 0.7,//0.55
        width: size.width * 0.92,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.02,
            ),
            child: InkWell(
              onTap: () {
                Get.to(DetailsPage(
                  documentId: data.docs[i].id,
                  companyName:data.docs[i]['companyName'],
                  carImage: data.docs[i]['carImage'],
                  carClass: data.docs[i]['carClass'],
                  carName: data.docs[i]['carName'],
                  carPower: data.docs[i]['carPower'],
                  people: data.docs[i]['people'],
                  bags: data.docs[i]['bags'],
                  carPrice: data.docs[i]['carPrice'],
                  carRating: data.docs[i]['carRating'],
                  isRotated: data.docs[i]['isRotated'],
                ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: data.docs[i]['isRotated']
                          ? Image.network(
                              data.docs[i]['carImage'],
                              height: size.width * 0.35,//0.25
                              width: size.width * 0.65,//0.5
                              fit: BoxFit.contain,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.network(
                                data.docs[i]['carImage'],
                                height: size.width * 0.25,
                                width: size.width * 0.5,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Text(
                      data.docs[i]['carClass'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color:
                            isDarkMode ? Colors.white : const Color(0xff3b22a1),
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    data.docs[i]['carName'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color:
                          isDarkMode ? Colors.white : const Color(0xff3b22a1),
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${data.docs[i]['carPrice']}\FCFA',
                        style: GoogleFonts.poppins(
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xff3b22a1),
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/par jour',
                        style: GoogleFonts.poppins(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.8),
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: size.width * 0.025,
                        ),
                        child: SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff3b22a1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: const Icon(
                              UniconsLine.credit_card,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
