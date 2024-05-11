// ignore_for_file: prefer_const_constructors

import 'package:eqlert/auth/auth_screen.dart';
import 'package:eqlert/screens/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NavigationScreen();
        } else {
          return AuthScreen();
        }
      },
    ));
  }
}
