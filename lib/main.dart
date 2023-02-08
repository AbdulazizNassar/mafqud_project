import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/Screens/homepage/Home.dart';
import 'package:mafqud_project/screens/Authentication/register.dart';
import 'package:mafqud_project/screens/Authentication/sign_in.dart';
import 'Screens/Authentication/auth.dart';
import 'MainScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mafqud',
      theme: ThemeData(
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.blue, elevation: 2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "MainScreen",
      routes: {
        "MainScreen": (context) => MainScreen(),
        "Auth": (context) => Auth(),
        "SignIn": (context) => SignIn(),
        "Register": (context) => Register(),
        "Home": (context) => const Home(),
      },
    );
  }
}
