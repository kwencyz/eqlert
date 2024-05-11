// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const RegisterScreen({Key? key, required this.showLoginScreen})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ralat'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signUp() async {
    try {
      // Validate text fields
      if (_fnameController.text.trim().isEmpty ||
          _lnameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showErrorDialog('Sila isikan semua ruangan');
        return;
      }

      // Create user in FirebaseAuth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the user's uid
      String uid = userCredential.user!.uid;

      // Initialize Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new user document
      final user = <String, dynamic>{
        "uid": uid,
        "first name": _fnameController.text.trim(),
        "last name": _lnameController.text.trim(),
        "email": _emailController.text.trim(),
      };

      // Add the user document to Firestore
      await firestore
          .collection("user")
          .doc(uid)
          .set(user)
          .then(() {
            print('DocumentSnapshot added with ID: $uid');
          } as FutureOr Function(void value))
          .catchError((error) {
        print('Error adding document: $error');
      });
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        _showErrorDialog('Email sudah digunakan. Sila gunakan email lain.');
      } else {
        print('Error signing up: $e');
        // Handle other errors: display error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registration",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                SizedBox(width: 60),
                Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "assets/images/logo2.png",
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),

            //first name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'First Name',
                      contentPadding: EdgeInsets.all(10.0)),
                ),
              ),
            ),

            SizedBox(height: 10),

            //last name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _lnameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Last Name',
                      contentPadding: EdgeInsets.all(10.0)),
                ),
              ),
            ),

            SizedBox(height: 10),

            //email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      contentPadding: EdgeInsets.all(10.0)),
                ),
              ),
            ),

            SizedBox(height: 10),

            //password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      contentPadding: EdgeInsets.all(10.0)),
                ),
              ),
            ),

            SizedBox(height: 30),

            //sign in button
            SizedBox(
              height: 45,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(254, 156, 0, 1),
                  side: BorderSide(width: 1, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                onPressed: signUp,
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already register?'),
                GestureDetector(
                  onTap: widget.showLoginScreen,
                  child: Text(
                    ' Log In',
                    style: TextStyle(
                      color: Color.fromRGBO(254, 156, 0, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(' now!'),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
