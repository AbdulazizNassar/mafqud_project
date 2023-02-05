
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI Login and Register',
      theme: ThemeData(
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.blue, elevation: 2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Auth(),
    );
  }
}