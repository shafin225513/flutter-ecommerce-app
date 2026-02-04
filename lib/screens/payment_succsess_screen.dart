import 'package:e_commerce/bnavigation_pages/bnavigation.dart';
import 'package:flutter/material.dart';

class PaymentsuccsessScreen extends StatelessWidget {
  const PaymentsuccsessScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Go to Home"),
              onPressed: () {
                Navigator.pushReplacement(
                  context, MaterialPageRoute(
                    builder: (_) => Bnavigation()));
                    
              },
            )
          ],
        ),
      ),
    );
  }
}