import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/Authentication/sign_in.dart';
import 'package:mafqud_project/screens/Authentication/register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showSignIn = false;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (!showSignIn) {
      return SignIn();
    } else {
      return Register();
    }
  }
}