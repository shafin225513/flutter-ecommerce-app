import 'package:e_commerce/bnavigation_pages/bnavigation.dart';
//import 'package:e_commerce/bnavigation_pages/home_screen.dart';
import 'package:e_commerce/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool _obsecureText = true;


  login() async {
  if (_emailController.text.isEmpty || _passController.text.isEmpty) {
    Fluttertoast.showToast(msg: 'Email and password required');
    return;
  }

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    );

    if (userCredential.user != null) {
      Fluttertoast.showToast(msg: 'Login successful');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bnavigation()),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: 'No user found for this email');
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Wrong password');
    } else {
      Fluttertoast.showToast(msg: e.message ?? 'Login failed');
    }
  }
}


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        children: [
          Text('Log-IN',style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 12.h,),
          Text('Welcome Back!',style: TextStyle(fontSize: 32,color: Colors.white),),
          Container(
            
            decoration: BoxDecoration(
              color: Colors.white,
              
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                Text('Glad to see you back'),
                SizedBox(height: 10.h,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your E-mail',
                    icon: Icon(Icons.email_outlined),
                    fillColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h,),
                TextFormField(
                 controller: _passController,
                 obscureText: _obsecureText,
                 decoration: InputDecoration(
                 labelText: 'Password',
                 hintText: 'Enter password',
                 icon: Icon(Icons.password),
                 suffixIcon: IconButton(
                 icon: Icon(
                    _obsecureText ? Icons.visibility_off : Icons.visibility,
                ),
                 onPressed: () {
                  setState(() {
                  _obsecureText = !_obsecureText;
                });
             },
          ),
        ),
     ),

                SizedBox(height: 20.h,),
                ElevatedButton(
                  onPressed: (){
                    login();
                  }, 
                  child: Center(
                    child: Text('Login',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                    ),

                  )
                ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Dont have an account yet?!'),
                    SizedBox(width: 8.w,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (_)=>SignupScreen() ));
            
                      },
                       child: Text('Sign-UP',style: TextStyle(fontSize: 22,color: Colors.black),))
                  ],
                )

              ],
            ),
          )
        ],
      ),
    );
  }
  @override
void dispose() {
  _emailController.dispose();
  _passController.dispose();
  super.dispose();
}

}