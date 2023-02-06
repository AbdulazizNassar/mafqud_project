import 'package:mafqud_project/models/currentUser.dart';
import 'package:mafqud_project/Screens/Authentication/auth.dart';
import 'package:mafqud_project/Screens/homepage/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<currentUser>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return Auth();
    } else {
      return const Home();
    }

  }
}