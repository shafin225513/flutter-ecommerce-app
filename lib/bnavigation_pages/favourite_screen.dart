import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  Future<void> removeFromFavorite(String productId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .doc(productId)
      .delete();
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('favorites')
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }

    final favItems = snapshot.data!.docs;

    if (favItems.isEmpty) {
      return Center(child: Text("Cart is empty"));
    }

    return ListView.builder(
      itemCount: favItems.length,
      itemBuilder: (context, index) {
        final item = favItems[index];
        return ListTile(
          leading: Image.network(
            item['image'],
            width: 25.w,
            height: 25.h,
            fit: BoxFit.cover,
          ),
          title: Text(item['name']),
          subtitle: Text("৳ ${item['price']}"),
          trailing: IconButton(
            onPressed: () {
              removeFromFavorite(item.id);
            }, 
            icon: Icon(Icons.remove_done)
            ) 
        );
      },
    );
  },
)
,
    );
  }
}