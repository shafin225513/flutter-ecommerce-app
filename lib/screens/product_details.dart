import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  Future<void> addToCart(Map<String, dynamic> product) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('cart')
      .doc(product['id']); // use product doc id

  await cartRef.set({
    'name': product['name'],
    'price': product['price'],
    'image': product['image'],
    'quantity': 1,
  });

  Fluttertoast.showToast(msg: "Added to cart");
}


Future<void> addToFavorite(Map<String, dynamic> product) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(product['id'])
      .set({
    'name': product['name'],
    'price': product['price'],
    'image': product['image'],
  });

  Fluttertoast.showToast(msg: "Added to favorites ❤️");
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Image.network(
              product['image'],
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "৳ ${product['price']}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    product['description'], // 🔥 FROM FIRESTORE
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                   children: [
                   Expanded(
                       child: ElevatedButton.icon(
                        icon: Icon(Icons.shopping_cart),
                       label: Text("Add to Cart"),
                       onPressed: () {
                         addToCart(product);
                                },
                         ),
                       ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                      addToFavorite(product);
                          },
                        ),
                       ],
                    )

                  
                ],
                
              ),
            )
          ],
        ),
        
      ),
      
    );
  }
}
