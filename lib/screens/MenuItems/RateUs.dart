import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  late Icon icon;
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
                child: rate(),
              ),
            ),
          ),
        );

  Column rate() {
    var elevatedButton = ElevatedButton(
      child: const Text(
        "send",
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      onPressed: () async {
        if (!(_rating.isNaN)) {
          setState(() {
            isLoading = true;
          });
          await ratingCollection.doc(user!.uid).set({
            "rating": _rating,
            "uid": user!.uid,
          });
          setState(() {
            isLoading = false;
            confirm = "  Thank you for rating !";
          });
        } else {
          setState(() {
            confirm = "Please Select at least 1 star";
          });
        }
      },
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 40.0,
        ),
        _heading('Rating'),
        _ratingBar(),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 50,
          width: 120,
          child: elevatedButton,
        ),
        const SizedBox(height: 20.0),
        if (confirm.isNotEmpty) _confirmation(confirm),
      ],
    );
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      minRating: 0,
      allowHalfRating: true,
      initialRating: 1,
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

  Widget _confirmation(String text) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 40, color: Colors.green),
          Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 24.0,
                color: Colors.green),
          )
        ],
      );
}
