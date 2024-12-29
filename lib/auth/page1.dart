import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Formulaire",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Information sur l'utilisateur",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nom et prénom *",
                      icon: Icon(Icons.person),
                    ),
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Ce champ est obligatoire"
                          : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Numéro de téléphone *",
                      icon: Icon(Icons.phone),
                    ),
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Ce champ est obligatoire"
                          : null;
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  ),
                  child: const Text(
                    "Valider",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: const ButtonStyle(
                    backgroundColor:  WidgetStatePropertyAll(Colors.blue),
                  ),
                  child: const Text(
                    "Page suivante",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
