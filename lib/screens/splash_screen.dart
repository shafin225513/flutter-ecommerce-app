//import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:e_commerce/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
  @override
void initState() {
  super.initState(); 

  
  Future.delayed(Duration(seconds: 3), () {
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => LoginScreen()),
      );
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('E-Commerce',
            style: TextStyle(
              color: Colors.white,
              fontSize: 44.sp,
              fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 22.h,),
            CircularProgressIndicator(color: Colors.white,)
          ],
        ),

      ),

      
      backgroundColor: Colors.lightBlueAccent,
    );
    
  }
}