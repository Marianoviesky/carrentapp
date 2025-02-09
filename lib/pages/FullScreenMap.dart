import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicons/unicons.dart';

class Fullscreenmap extends StatefulWidget {
  final LatLng carLocation;

  const Fullscreenmap({Key? key, required this.carLocation}) : super(key: key);

  @override
  _FullscreenmapState createState() => _FullscreenmapState();
}

class _FullscreenmapState extends State<Fullscreenmap> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.carLocation, // Utilisation de la position de la voiture
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('carLocation'),
                position: widget.carLocation,
                infoWindow: InfoWindow(title: "Localisation actuelle"),
              ),
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.045,
              left: size.width * 0.03,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Get.back(); // Retourner à la page précédente
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: Colors.black,
                    size: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}