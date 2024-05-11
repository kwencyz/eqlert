import 'package:eqlert/screens/login_screen.dart';
import 'package:eqlert/screens/register_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  // initially show login screen
  bool showLoginScreen = true;

  void toggleScreens(){
    setState(() {
      showLoginScreen =!showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen){
      return LoginScreen(showRegisterScreen: toggleScreens);
    }else{
      return RegisterScreen(showLoginScreen: toggleScreens);
    }
  }
}