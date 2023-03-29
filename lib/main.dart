import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'Screens/homepage/Home.dart';
import 'screens/Authentication/register.dart';
import 'screens/Authentication/sign_in.dart';
import 'screens/posts/addPost.dart';
import 'screens/posts/posts.dart';
import 'Screens/Authentication/auth.dart';
import 'screens/MainScreen.dart';
import 'services/firebase_options.dart';
import 'package:mafqud_project/services/googleMap/googleMapsAddPosts.dart';
import 'package:mafqud_project/services/googleMap/googleMapsShowPosts.dart';

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
        appBarTheme: const AppBarTheme(color: Colors.blue, elevation: 2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "Posts",
      routes: {
        "MainScreen": (context) => const MainScreen(),
        "Auth": (context) => Auth(),
        "SignIn": (context) => SignIn(),
        "Register": (context) => Register(),
        "Home": (context) => const Home(),
        "Posts": (context) => const Posts(),
        "AddPost": (context) => const AddPosts(),
        "History": (context) => const History(),
        "GoogleMap": (context) => const MapScreen(),
        "MapPosts": (context) => const MapPosts(),
      },
    );
  }
}
