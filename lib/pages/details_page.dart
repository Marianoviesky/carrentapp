import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carrentapp/pages/PaymentPage.dart';
import 'package:carrentapp/pages/FullScreenMap.dart';


class DetailsPage extends StatefulWidget {
  final String companyName;
  final String carImage;
  final String carClass;
  final String carName;
  final int carPower;
  final String people;
  final String bags;
  final int carPrice;
  final String carRating;
  final bool isRotated;
  final String documentId;

  const DetailsPage({
    Key? key,
    required this.companyName,
    required this.documentId,
    required this.carImage,
    required this.carClass,
    required this.carName,
    required this.carPower,
    required this.people,
    required this.bags,
    required this.carPrice,
    required this.carRating,
    required this.isRotated,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _center = LatLng(50.470685, 19.070234);
  // void _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }


//essaie
   GoogleMapController? mapController;
  LatLng _carLocation = const LatLng(0, 0); // Valeur par défaut
  bool _isLoading = true;


  Future<void> rentCar({
  required String carId,
  required String carName,
  required String carLocation,
  required int carPrice,
}) async {
  try {
    // Obtenir l'utilisateur actif
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Aucun utilisateur actif.");
    }

    // Ajouter les données dans Firebase
    await FirebaseFirestore.instance.collection('carrented').add({
      'userId': user.uid,
      'carId': carId,
      'carName': carName,
      'carLocation': carLocation,
      'carPrice': carPrice,
      'rentedAt': FieldValue.serverTimestamp(), // Enregistre l'heure de l'emprunt
    });
  } catch (e) {
    throw Exception("Erreur lors de l'emprunt : $e");
  }
}
//essaie

 Future<void> _fetchCarLocation() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.documentId)
          .get();

      if (doc.exists) {
        double lat = doc['latitude'];
        double lng = doc['longitude'];

        setState(() {
          _carLocation = LatLng(lat, lng);
          _isLoading = false;
        });

        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLng(_carLocation));
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des coordonnées: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
//essaie
@override
  void initState() {
    super.initState();
    _fetchCarLocation();
  }

//
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
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
              child: InkWell(
                onTap: () {
                  Get.back(); //go back to home page
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff070606)
                        : Colors.white, //icon bg color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                    size: size.height * 0.025,
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
                : 'assets/icons/second.png',
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body:  _isLoading
          ? const Center(child: CircularProgressIndicator())
       : Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xff06090d)
                : const Color(0xfff8f8f8), //background color
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
              ),
              child: Stack(
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      widget.isRotated
                          ? Image.network(
                              widget.carImage,
                              height: size.width * 0.5,
                              width: size.width * 0.8,
                              fit: BoxFit.contain,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.network(
                                widget.carImage,
                                height: size.width * 0.5,
                                width: size.width * 0.8,
                                fit: BoxFit.contain,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.carClass,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                            size: size.width * 0.06,
                          ),
                          Text(
                            widget.carRating,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.yellow[800],
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.carName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.carPrice}\FCFA',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/par jour',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.8),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildStat(
                              UniconsLine.dashboard,
                              '${widget.carPower} KM',
                              'Puissance',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.users_alt,
                              'Passagers',
                              '( ${widget.people} )',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.briefcase,
                              'Bagages',
                              '( ${widget.bags} )',
                              size,
                              isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                        ),
                        child: Text(
                          'Emplacement de la voiture',
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff3b22a1),
                            fontSize: size.width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                         child: GestureDetector(
                            onTap: () {
                              Get.to(() => Fullscreenmap(carLocation: _carLocation));
                            },
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: size.width * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                    vertical: size.height * 0.015,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        UniconsLine.map_marker,
                                        color: const Color(0xff3b22a1),
                                        size: size.height * 0.05,
                                      ),
                                      Text(
                                        widget.companyName,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xff3b22a1),
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Wolności 90, 42-625 Pyrzowice',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.black.withOpacity(0.7),
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                      borderRadius: BorderRadius.circular(10), // Ajout d'un arrondi pour un meilleur style
                                      child: SizedBox(
                                        height: size.height * 0.18, // Ajustement pour éviter l'overflow
                                        width: size.width * 0.4,
                                        child: GoogleMap(
                                          onMapCreated: (GoogleMapController controller) {
                                            mapController = controller;
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: _carLocation,
                                            zoom: 15.0,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId: MarkerId('carLocation'),
                                              position: _carLocation,
                                              infoWindow: InfoWindow(title: "Localisation actuelle"),
                                            ),
                                          },
                                          
                                          zoomControlsEnabled: false,
                                          scrollGesturesEnabled: false, // Désactiver les interactions sur la mini-map
                                          ),
                                        ),
                                      ),

                              ],
                            ),
                            
                          ),
                        ),
                         ),
                      ),



                    ],
                  ),
                  buildSelectButton(context, size, isDarkMode, this),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildStat(
      IconData icon, String title, String desc, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
      ),
      child: SizedBox(
        height: size.width * 0.32,
        width: size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.width * 0.03,
              left: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff3b22a1),
                  size: size.width * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



Future<void> showConfirmationDialog(
    BuildContext context, _DetailsPageState state) async {
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // L'utilisateur doit choisir une option
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text("Voulez-vous vraiment procéder à l'emprunt de cette voiture ?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue

              // Rediriger vers la page de paiement avec les informations de voiture
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    carName: state.widget.carName,
                    carPrice: state.widget.carPrice,
                    carLocation: "Katowice Airport",
                  ),
                ),
              );
            },
            child: const Text('Oui'),
          ),
        ],
      );
    },
  );
}

Align buildSelectButton(
    BuildContext context, Size size, bool isDarkMode, _DetailsPageState state) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.01,
      ),
      child: SizedBox(
        height: size.height * 0.07,
        width: size.width,
        child: InkWell(
          onTap: () {
            showConfirmationDialog(context,state);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff3b22a1),
            ),
            child: Align(
              child: Text(
                'Louer',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
