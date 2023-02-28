import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/shared/loading.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  late double _rating;
  IconData? _selectedIcon;
  String confirm = '';
  bool isLoading = false;
  var user = AuthService().currentUser;
  CollectionReference ratingCollection =
      FirebaseFirestore.instance.collection("rating");

  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.white),
            ),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Rate Us'),
              ),
              drawer: const NavMenu(),
              body: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 40.0,
                    ),
                    _heading('Rating Bar'),
                    _ratingBar(),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text("send"),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await ratingCollection.doc(user!.uid).set({
                          "rating": _rating,
                          "uid": user!.uid,
                        });
                        setState(() {
                          isLoading = false;
                          confirm = "Thank you for rating !";
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _confirmation(confirm),
                  ],
                ),
              ),
            ),
          ),
        );

  Widget _ratingBar() {
    return RatingBar.builder(
      minRating: 1,
      allowHalfRating: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 50.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );

  Widget _confirmation(String text) => Column(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 50,
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 24.0,
                color: Colors.green),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );
}
