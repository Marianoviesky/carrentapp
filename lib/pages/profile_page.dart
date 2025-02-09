import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:intl/intl.dart';
import 'package:carrentapp/pages/home_page.dart';
import 'package:get/get.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRentedCars(String userId) async {
    QuerySnapshot rentedCarsSnapshot = await _firestore
        .collection('carrented')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> rentedCars = [];
    for (var doc in rentedCarsSnapshot.docs) {
      String carName = doc['carId'];
      QuerySnapshot carDocSnapshot = await _firestore
          .collection('cars')
          .where('carName', isEqualTo: carName)
          .get();

      if (carDocSnapshot.docs.isNotEmpty) {
        var carDoc = carDocSnapshot.docs.first;
        var rentedAt = doc['rentedAt'].toDate();
        String formattedDate = DateFormat('dd/MM/yy à HH:mm').format(rentedAt);

        rentedCars.add({
          'carName': carDoc['carName'],
          'carImage': carDoc['carImage'],
          'carPrice': doc['carPrice'],
          'rentedAt': formattedDate,
        });
      }
    }
    return rentedCars;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final String email = user?.email ?? "Email non disponible";
    final String displayName = user?.displayName ?? "Utilisateur";
    final String userId = user?.uid ?? "";

    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mon Profil",
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color(0xff06090d)
            : const Color(0xfff8f8f8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
    icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : const Color(0xff3b22a1)),
    onPressed: () { 
      Get.off(HomePage());
       },
  ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              CircleAvatar(
                radius: size.width * 0.15,
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                child: Icon(
                  UniconsLine.user,
                  color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                  size: size.width * 0.2,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.04,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.7),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getRentedCars(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur lors du chargement des données');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Aucun emprunt trouvé');
                  } else {
                    List<Map<String, dynamic>> rentedCars = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Historique des Locations",
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rentedCars.length,
                          itemBuilder: (context, index) {
                            var car = rentedCars[index];
                            return Card(
                              elevation: 4,
                              shadowColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.3,
                                    height: size.width * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(car['carImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            car['carName'],
                                            style: GoogleFonts.poppins(
                                              fontSize: size.width * 0.045,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Prix: ${car['carPrice']}€',
                                            style: GoogleFonts.poppins(
                                              fontSize: size.width * 0.035,
                                              color: isDarkMode
                                                  ? Colors.white70
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Loué le: ${car['rentedAt']}',
                                            style: GoogleFonts.poppins(
                                              fontSize: size.width * 0.035,
                                              color: isDarkMode
                                                  ? Colors.white70
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: size.height * 0.05),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B22A1),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3,
                    vertical: size.height * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Se déconnecter",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}