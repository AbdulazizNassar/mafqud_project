import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/main.dart';
import '../screens/posts/Details.dart';

showPostDetailsPage(
    {required posts,
    required context,
    required images,
    required postID}) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(posts["Lat"], posts['Lng']);

    navKey.currentState!.push(MaterialPageRoute(
        builder: (context) => Details(
              posts: posts,
              locality: placemarks.first.locality!,
              subLocality: placemarks.first.subLocality!,
              postID: postID,
            )));
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarError("Error", 'Couldn\'t find post'));
  }
}
