import 'package:carrentapp/auth/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:intl/intl.dart';
import 'package:carrentapp/pages/home_page.dart';
import 'package:get/get.dart';
import'package:carrentapp/pages/ProfileAvatar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Méthode pour sélectionner une image et la stocker localement
  Future<void> _pickAndStoreImage() async {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) return;

    File image = File(imageFile.path);

    try {
      // Obtenez le répertoire de stockage local
      final directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File localImage = await image.copy('$path/$fileName');

      // Enregistrer le chemin de l'image dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', localImage.path);

      setState(() {}); // Mettre à jour l'interface utilisateur
    } catch (e) {
      print("Erreur lors de l'enregistrement de l'image localement: $e");
    }
  }

  // Méthode pour récupérer l'image enregistrée localement
  Future<String?> _getProfileImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImagePath');
  }


Future<List<Map<String, dynamic>>> getRentedCars(String userId) async {
  try {
    QuerySnapshot rentedCarsSnapshot = await _firestore
        .collection('carrented')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> rentedCars = [];

    for (var doc in rentedCarsSnapshot.docs) {
      try {
        String carId = doc['carId'];
        DocumentSnapshot carDocSnapshot = await _firestore
            .collection('cars')
            .doc(carId)
            .get();

        if (carDocSnapshot.exists) {
          var carDoc = carDocSnapshot.data() as Map<String, dynamic>;
          var rentedAt = doc['rentedAt'].toDate();
          String formattedDate = DateFormat('dd/MM/yy à HH:mm').format(rentedAt);

          // ✅ Conversion sécurisée de int en double
          double totalPrice = (doc['totalPrice'] as num).toDouble();
          double carPrice = (carDoc['carPrice'] as num).toDouble();
          int rentalDays = doc['rentalDays'];

          rentedCars.add({
            'carName': carDoc['carName'],
            'carImage': carDoc['carImage'],
            'carPrice': carPrice,
            'rentedAt': formattedDate,
            'rentalDays': rentalDays,
            'totalPrice': totalPrice,
          });
        }
      } catch (e) {
        print("Erreur lors de la récupération d'une voiture : $e");
      }
    }

    return rentedCars;
  } catch (e) {
    print("Erreur lors de la récupération des locations : $e");
    return [];
  }
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
              FutureBuilder<String?>(
              future: _getProfileImagePath(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null) {
                  return CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundImage: FileImage(File(snapshot.data!)),
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  );
                } else {
                  return CircleAvatar(
                    radius: size.width * 0.15,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      UniconsLine.user,
                      color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                      size: size.width * 0.2,
                    ),
                  );
                }
              },
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
               SizedBox(height: size.height * 0.05),
            ElevatedButton(
              onPressed: _pickAndStoreImage,
              child: Text("Changer la photo de profil"),
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
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Erreur : ${snapshot.error}'));

    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('Aucun emprunt trouvé'));
    } else {
      List<Map<String, dynamic>> rentedCars = snapshot.data!;

      // Calcul du montant total dépensé
      double totalAmount = rentedCars.fold(0, (sum, car) => sum + car['totalPrice']);

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

          SizedBox(height: size.height * 0.01),

          // ✅ Ajout du montant total dépensé
          Text(
            "Montant total dépensé : ${totalAmount.toStringAsFixed(2)} FCFA",
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.redAccent,
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
                shadowColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car['carName'],
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Prix unitaire: ${car['carPrice']} FCFA',
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.035,
                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Loué le: ${car['rentedAt']}',
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.035,
                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 5),
                            // ✅ Ajout de la durée de location et du total payé
                            Text(
                              'Durée: ${car['rentalDays']} jours',
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.035,
                                color: isDarkMode ? Colors.white70 : Colors.blueAccent,
                              ),
                            ),
                            Text(
                              'Total payé: ${car['totalPrice']}FCFA',
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.green,
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
                  Get.offAll(const Wrapper());
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