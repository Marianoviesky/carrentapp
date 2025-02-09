 SizedBox(
                                  height: size.height * 0.17,
                                  width: size.width * 0.29,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: const CameraPosition(
                                      target: _center,
                                      zoom: 13.0,
                                    ),
                                    onTap: (latLng) => Get.to(const Maps()),
                                    zoomControlsEnabled: false,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                  ),
                                ),








Center(
  child: GestureDetector(
    onTap: () {
      Get.to(() => FullScreenMap(carLocation: _carLocation));
    },
    child: Container(
      height: size.height * 0.2, // Augmentation de la hauteur pour éviter l'overflow
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  UniconsLine.map_marker,
                  color: Color(0xff3b22a1),
                  size: size.height * 0.05,
                ),
                Text(
                  carCity, // Nom de la ville depuis la base de données
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : Color(0xff3b22a1),
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  carAddress, // Adresse de la voiture depuis la base de données
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
