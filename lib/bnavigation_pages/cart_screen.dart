import 'package:e_commerce/bnavigation_pages/cart_checkout_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double getTotalPrice(List<QueryDocumentSnapshot> cartItems) {
  double total = 0;

  for (var item in cartItems) {
    total += item['price'];
  }

  return total;
}


  Future<void> removeFromCart(String productId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .doc(productId)
      .delete();
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Cart'),
      backgroundColor: Colors.green,
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Cart is empty"));
        }

        final cartItems = snapshot.data!.docs;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final name = item['name'] ?? 'Unknown Item';
                  final price = item['price'] ?? 0.0;

                  return ListTile(
                    leading: Image.network(
                      item['image'],
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.cover,
                    ),
                    title: Text(name),
                    subtitle: Text("৳ $price"),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        removeFromCart(item.id);
                      },
                    ),
                  );
                },
              ),
            ),
            CartCheckoutBar(context, cartItems), // now cartItems is defined here
          ],
        );
      },
    ),
  );
}

}
