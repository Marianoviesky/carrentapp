import 'package:flutter/material.dart';
import 'ConfirmationPage.dart';

class PaymentPage extends StatelessWidget {
  final String carName;
  final int carPrice;
  final String carLocation;

  PaymentPage({
    required this.carName,
    required this.carPrice,
    required this.carLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page de paiement"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: PaymentForm(
          carName: carName,
          carPrice: carPrice,
          carLocation: carLocation,
        ),
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  final String carName;
  final int carPrice;
  final String carLocation;

  PaymentForm({
    required this.carName,
    required this.carPrice,
    required this.carLocation,
  });

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _daysController = TextEditingController();
  String _paymentMethod = "Carte de Crédit";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Détails de la location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.directions_car, color: Colors.blueAccent),
                    title: Text("Voiture: ${widget.carName}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green),
                    title: Text("Prix: \$${widget.carPrice}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text("Location: ${widget.carLocation}"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _daysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nombre de jours de location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nombre de jours';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Méthode de paiement",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _paymentMethod = newValue!;
                      });
                    },
                    items: <String>['Carte de Crédit', 'PayPal', 'MTN Mobile Money']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
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
                if (_formKey.currentState?.validate() ?? false) {
                  int days = int.parse(_daysController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmationPage(
                        carName: widget.carName,
                        carPrice: widget.carPrice,
                        carLocation: widget.carLocation,
                        rentalDays: days,
                        paymentMethod: _paymentMethod,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                child: Text('Confirmer le paiement', style: TextStyle(fontSize: 16,color: Colors.white)),
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
    );
  }
}