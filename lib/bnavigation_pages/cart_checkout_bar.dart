import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/screens/payment_succsess_screen.dart'; // Ensure correct file name
// import 'package:e_commerce/bnavigation_pages/cart_screen.dart'; // Unused if getTotalPrice is defined elsewhere

// 1. Pass BuildContext to use Navigator
Widget CartCheckoutBar(BuildContext context, List<QueryDocumentSnapshot> cartItems) {
  
  // Calculate total safely
  double total = 0;
  for (var item in cartItems) {
    // Assuming price is int or double in Firestore
    total += (item['price'] ?? 0).toDouble();
  }

  Future<void> placeOrder(List<QueryDocumentSnapshot> cartItems) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    
    // Create a new document reference to get the ID beforehand if needed
    final orderDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .doc();

    List<Map<String, dynamic>> items = [];
    for (var item in cartItems) {
      items.add({
        'productId': item.id,
        'name': item['name'],
        'price': item['price'],
        'image': item['image'],
      });
    }

    // 1️⃣ Save order using orderDoc
    await orderDoc.set({
      'items': items,
      'totalPrice': total, // Consistent naming
      'paymentMethod': 'Fake Payment',
      'status': 'Paid',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2️⃣ Clear cart
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var item in cartItems) {
      DocumentReference cartItemRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(item.id);
      batch.delete(cartItemRef);
    }
    await batch.commit(); // Efficient deletion
  }

  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Added for compact view
          children: [
            Text("Total"),
            Text(
              "৳ ${total.toStringAsFixed(2)}", // Formatted total
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: cartItems.isEmpty
              ? null
              : () async {
                  await placeOrder(cartItems);
                  if (context.mounted) {
                    Navigator.pushReplacement( // Changed to pushReplacement
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentsuccsessScreen(),
                      ),
                    );
                  }
                },
          child: Text("Pay Now"),
        ),
      ],
    ),
  );
}
