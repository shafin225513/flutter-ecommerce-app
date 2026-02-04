import 'package:e_commerce/bnavigation_pages/bnavigation.dart';
//import 'package:e_commerce/bnavigation_pages/home_screen.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passController=TextEditingController();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  bool _obsecureText=true;

  signUp() async{
    try {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passController.text.trim(),
  );
  //var authCredential=userCredential.user;
  if (_passController.text != _confirmPassController.text) {
  Fluttertoast.showToast(msg: 'Passwords do not match');
  return;
}

  if (userCredential.user != null) {
      Fluttertoast.showToast(msg: 'Signup successful');

      // 🔥 Navigate & remove signup screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bnavigation()),
      );
    }
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    Fluttertoast.showToast(msg:'The password provided is too weak.');
    
  } else if (e.code == 'email-already-in-use') {
    Fluttertoast.showToast(msg:'Account already exists' );
  }
} catch (e) {
  print(e);
}

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          Text('Create an Account',style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 12.h,),
          Text('Welcome!',style: TextStyle(fontSize: 32,color: Colors.white),),
          Container(
            
            decoration: BoxDecoration(
              color: Colors.white,
              
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                //Text('Glad to see you back'),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your Name',
                    icon: Icon(Icons.person_4),
                    fillColor: Colors.grey,
                  ),
                ),
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
                    hintText: 'Give a password',
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
                TextFormField(
                  controller: _confirmPassController,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    hintText: 'Confirm your password',
                    //icon: Icon(Icons.password_outlined),
                    fillColor: Colors.grey,
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
                  )
                ),
                SizedBox(height: 20.h,),
                ElevatedButton(
                  onPressed: (){
                  signUp();
                  }, 
                  child: Center(
                    child: Text('SignUP',
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
                    Text('Already have an account?!'),
                    SizedBox(width: 8.w,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (_)=>LoginScreen() ));
            
                      },
                       child: Text('Login',style: TextStyle(fontSize: 22,color: Colors.black),))
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
  _nameController.dispose();
  super.dispose();
}

}