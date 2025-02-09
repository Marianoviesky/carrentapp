import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:carrentapp/widgets/bottom_nav_bar.dart';
class Page1 extends StatelessWidget {
  const Page1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Page(title: 'Flutter Demo Home Page'),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  
  int _counter = 0;

void _incrementCounter() {
  int generateRandomSixDigitNumber() {
    Random random = Random();
    return 100000 + random.nextInt(900000); // Génère un nombre entre 100000 et 999999
  }

  // Liste des entreprises avec leurs coordonnées
  List<Map<String, dynamic>> companies = [
    {
      "name": "SANKO BENIN",
      "latitude": 6.365,
      "longitude": 2.421,
    },
    {
      "name": "AFRIQUE SERVICES TRANSPORT & TOURISME",
      "latitude": 6.370,
      "longitude": 2.435,
    },
    {
      "name": "GROUPE AGRI EX",
      "latitude": 6.415,
      "longitude": 2.440,
    },
    {
      "name": "HCF LOGISTICS SARL",
      "latitude": 6.355,
      "longitude": 2.428,
    },
    {
      "name": "3Click Car Hire",
      "latitude": 6.362,
      "longitude": 2.422,
    },
  ];

  // Sélection aléatoire d'une entreprise
  Map<String, dynamic> selectedCompany =
      companies[Random().nextInt(companies.length)];

  final car = {
    "idtf": generateRandomSixDigitNumber(),
    "bags": "1-2",
    "carClass": "Luxe",
    "carImage":
        "https://i.postimg.cc/dtc8Yv6y/pngwing-com-7.png",
    "carName": "BMW M2",
    "carPower": 2300,
    "carPrice": 22000,
    "carRating": "4.6",
    "isRotated": true,
    "people": "1-2",
    "companyName": selectedCompany["name"], // Nom de l'entreprise
    "latitude": selectedCompany["latitude"], // Latitude
    "longitude": selectedCompany["longitude"], // Longitude
    "position": GeoPoint(selectedCompany["latitude"], selectedCompany["longitude"]),
  };

  FirebaseFirestore.instance
      .collection("cars")
      .add(car)
      .then((DocumentReference doc) => print("Car id : ${doc.id}"));
}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    
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

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
