import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.red,

      ),
      body: Center(
        child: Text('This feature has not been implemented yet!',
        style: TextStyle(
          fontSize: 47,
          fontWeight: FontWeight.bold,
          color: Colors.red,

         ),
        
        ),
        
      ),
    );
  }
}