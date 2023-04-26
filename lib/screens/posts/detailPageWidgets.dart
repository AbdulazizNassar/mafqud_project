import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/DateTime.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

buildProductImagesWidgets(dynamic posts) {
  // TabController imagesController = TabController(length: 1, vsync: this);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      height: 250.0,
      child: Center(
        child: DefaultTabController(
          length: 1,
          child: Stack(
            children: <Widget>[
              Image.network(
                posts['image'],
                fit: BoxFit.fill,
                height: 350,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

buildProductTitleWidget(dynamic posts) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          posts['title'],
          style: textStyle,
        ),
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 30,
              color: Colors.blue.shade900,
            ),
            Text(
              readTimestamp(posts["Date"]),
              style: textStyle,
            ),
          ],
        ),
      ],
    ),
  );
}

buildStatusWidget(dynamic posts) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const Text(
          "Status:",
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          "${posts['status']}",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue[700],
          ),
        ),
      ],
    ),
  );
}

buildDivider(Size screenSize) {
  return Column(
    children: <Widget>[
      Container(
        color: Colors.grey[600],
        width: screenSize.width,
        height: 0.25,
      ),
    ],
  );
}

buildCategoryInfoWidget(dynamic posts) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      children: <Widget>[
        const Text(
          'Category:',
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Text(
          "${posts['category']}",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue[700],
          ),
        ),
      ],
    ),
  );
}

buildAuthorInfoWidget(dynamic data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      children: <Widget>[
        // const Text(
        //   'Author:',
        //   style: TextStyle(fontSize: 16.0, color: Colors.black),
        // ),
        const Icon(
          Icons.person_pin_circle_outlined,
          size: 28,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Text(
          "${data!['name']}",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue[700],
          ),
        ),

        const SizedBox(
          width: 50,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow.shade700,
          size: 35,
        ),
        Text(
          "${data!['rating'] / data!['numOfRating']}",
          style: textStyle,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "(${data!['numOfRating']})",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue[700],
          ),
        ),
      ],
    ),
  );
}

buildDetailsAndMaterialWidgets(dynamic widget, dynamic data,
    CollectionReference user, TabController tabController) {
  try {
    return FutureBuilder<DocumentSnapshot>(
        future: user.doc("${widget.posts['userID']}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  controller: tabController,
                  tabs: const <Widget>[
                    Tab(
                      child: Text(
                        "DETAILS",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  height: MediaQuery.of(context).size.height / 3.1,
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pin_drop_outlined,
                                  size: 40,
                                  color: Colors.blue.shade900,
                                ),
                                Text(
                                    "${widget.locality}, ${widget.subLocality}",
                                    style: textStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.posts['description']}",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return Loading();
        });
  } catch (e) {}
}
