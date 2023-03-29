import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../screens/posts/postDetails.dart';

showPostDetailsPage({required posts, required context}) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(posts["Lat"], posts['Lng']);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => postDetails(
                posts: posts,
                locality: placemarks.first.locality!,
                subLocality: placemarks.first.subLocality!,
              )));
}
