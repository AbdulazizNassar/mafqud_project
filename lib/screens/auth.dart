import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/sign_in.dart';
import 'package:mafqud_project/screens/register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(
        toggleView: toggleView,
      );
    } else {
      return Register(toggleView: toggleView);
    }
  }
}