import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:intl/intl.dart'; // Assure-toi d'importer intl

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



Future<List<Map<String, dynamic>>> getRentedCars(String userId) async {
  // Récupérer les emprunts de l'utilisateur
  QuerySnapshot rentedCarsSnapshot = await _firestore
      .collection('carrented')
      .where('userId', isEqualTo: userId)
      .get();

  List<Map<String, dynamic>> rentedCars = [];
  for (var doc in rentedCarsSnapshot.docs) {
    // Pour chaque emprunt, récupère les informations de la voiture depuis la collection 'cars' en utilisant le carName
    String carName = doc['carId'];  // Ici, carId est le carName
    QuerySnapshot carDocSnapshot = await _firestore
        .collection('cars')
        .where('carName', isEqualTo: carName)  // Recherche dans 'cars' par carName
        .get();

    if (carDocSnapshot.docs.isNotEmpty) {
      var carDoc = carDocSnapshot.docs.first;  // Prend le premier document trouvé
      var rentedAt = doc['rentedAt'].toDate();  // Convertir la timestamp en DateTime

      // Formater la date selon le format souhaité
      String formattedDate = DateFormat('dd/MM/yy à HH:mm').format(rentedAt);

      rentedCars.add({
        'carName': carDoc['carName'],
        'carImage': carDoc['carImage'],
        'carPrice': doc['carPrice'],
        'rentedAt': formattedDate,  // Utilise la date formatée
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.03),
              // Icone de profil
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
              // Nom de l'utilisateur
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              // Email de l'utilisateur
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
              // Historique des emprunts
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
                          itemCount: rentedCars.length,
                          itemBuilder: (context, index) {
                            var car = rentedCars[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                              child: ListTile(
                                leading: Image.network(car['carImage'], width: 50, height: 50),
                                title: Text(car['carName']),
                                subtitle: Text('Prix: ${car['carPrice']}'),
                                trailing: Text('Loué le: ${car['rentedAt']}'),
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
              // Bouton de déconnexion
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pop(); // Retour à la page précédente
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3b22a1),
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
