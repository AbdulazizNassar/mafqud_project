import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/DetailPage.dart';
import 'package:mafqud_project/screens/posts/history.dart';
import 'package:mafqud_project/services/sharedPreference.dart';
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
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mafqud',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blue, elevation: 2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "MainScreen",
      routes: {
        "MainScreen": (context) => const MainScreen(),
        "Auth": (context) => Auth(),
        "SignIn": (context) => SignIn(),
        "Register": (context) => Register(),
        "Home": (context) => const Home(),
        "Posts": (context) => const Posts(),
        "AddPost": (context) => const AddPosts(
              paths: '',
            ),
        "History": (context) => const History(),
        "GoogleMap": (context) => const MapScreen(
              paths: '',
            ),
        "MapPosts": (context) => const MapPosts(),
        "ProductDetailPage": (context) => const ProductDetailPage(),
      },
    );
  }
}
