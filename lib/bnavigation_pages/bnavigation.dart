import 'package:e_commerce/bnavigation_pages/cart_screen.dart';
import 'package:e_commerce/bnavigation_pages/favourite_screen.dart';
import 'package:e_commerce/bnavigation_pages/home_screen.dart';
import 'package:e_commerce/bnavigation_pages/profile_screen.dart';
import 'package:flutter/material.dart';

class Bnavigation extends StatefulWidget {
  const Bnavigation({super.key});

  @override
  State<Bnavigation> createState() => _BnavigationState();
}

class _BnavigationState extends State<Bnavigation> {
  final pages=[HomeScreen(),CartScreen(),FavouriteScreen(),ProfileScreen()];
  int curridx=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: curridx,
        selectedLabelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),

        
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_max),label:'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart),label:'Cart',),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border),label:'Favourite',),
          BottomNavigationBarItem(icon: Icon(Icons.person_off_outlined),label:'Profile',),
        ],
        onTap: (index) {
          setState(() {
            curridx=index;
            
          });

        },
        ),
        body: pages[curridx],
    );
    
  }
  
}