import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mafqud_project/shared/AlertBox.dart';

import '../screens/posts/Details.dart';

showPostDetailsPage({required posts, required context, required images}) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(posts["Lat"], posts['Lng']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Details(
                  posts: posts,
                  locality: placemarks.first.locality!,
                  subLocality: placemarks.first.subLocality!,
                )));
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarError("Error", 'Couldn\'t find post'));
  }
}
