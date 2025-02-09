import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentapp/pages/profile_page.dart';
import 'package:get/get.dart';


class ConfirmationPage extends StatelessWidget {
  final String carName;
  final int carPrice;
  final String carLocation;
  final int rentalDays;
  final String paymentMethod;

  ConfirmationPage({
    required this.carName,
    required this.carPrice,
    required this.carLocation,
    required this.rentalDays,
    required this.paymentMethod,
  });

  // Méthode de location (ajout dans la base de données)
  Future<void> rentCar({
    required String carId,
    required String carName,
    required String carLocation,
    required int carPrice,
    required int rentalDays,
  }) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Aucun utilisateur actif.");
      }

      // Calculer le montant total de la location
      int totalPrice = carPrice * rentalDays;

      // Ajouter l'emprunt dans Firestore
      await FirebaseFirestore.instance.collection('carrented').add({
        'userId': user.uid,
        'carId': carId,
        'carName': carName,
        'carLocation': carLocation,
        'carPrice': carPrice,
        'totalPrice': totalPrice,
        'rentalDays': rentalDays,
        'paymentMethod': paymentMethod,
        'rentedAt': FieldValue.serverTimestamp(),
      });

      print("Emprunt réussi et enregistré dans la base de données.");
    } catch (e) {
      throw Exception("Erreur lors de l'emprunt : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = carPrice * rentalDays;

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation de Location"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Résumé de la location",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.directions_car, color: Colors.blueAccent),
                      title: Text("Voiture"),
                      subtitle: Text(carName, style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      leading: Icon(Icons.attach_money, color: Colors.green),
                      title: Text("Prix par jour"),
                      subtitle: Text("\$$carPrice", style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.red),
                      title: Text("Emplacement"),
                      subtitle: Text(carLocation, style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.orange),
                      title: Text("Durée de location"),
                      subtitle: Text("$rentalDays jours", style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      leading: Icon(Icons.payment, color: Colors.purple),
                      title: Text("Méthode de paiement"),
                      subtitle: Text(paymentMethod, style: TextStyle(fontSize: 16)),
                    ),
                    Divider(color: Colors.grey[300]),
                    ListTile(
                      title: Text(
                        "Total à payer",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        "\$$totalPrice",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _rentCar(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  child: Text(
                    "Confirmer la location",
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rentCar(BuildContext context) async {
    try {
      // Appel à rentCar avec les informations passées dans le constructeur
      await rentCar(
        carId: carName, // Utiliser carName comme carId (ou un autre identifiant unique si disponible)
        carName: carName,
        carLocation: carLocation,
        carPrice: carPrice,
        rentalDays: rentalDays,
      );

      // Simulation de l'exécution de rentCar
      await Future.delayed(Duration(seconds: 2));

      // Affichage de la notification de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Emprunt réalisé avec succès!"),
          backgroundColor: Colors.green,
        ),
      );
    //    Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => ProfilePage()),
    // );
    Get.off(()=>ProfilePage());
    } catch (e) {
      // Affichage de l'échec de l'emprunt
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Échec de l'emprunt: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}