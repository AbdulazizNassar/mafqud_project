import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../shared/DateTime.dart';
import '../chat/chat_details.dart';
import '../chat/cubit/chat_cubit.dart';
import 'package:mafqud_project/screens/MenuItems/RateUs.dart';

class Details extends StatefulWidget {
  final posts;
  final locality;
  final subLocality;

  const Details({super.key, this.posts, this.locality, this.subLocality});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: _buildProductDetailsPage(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  _buildProductDetailsPage(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    return FutureBuilder<DocumentSnapshot>(
        future: user.doc("${widget.posts['userID']}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildProductImagesWidgets(),
                        _buildProductTitleWidget(),
                        const SizedBox(height: 12.0),
                        _buildDivider(screenSize),
                        const SizedBox(height: 12.0),
                        _buildDivider(screenSize),
                        const SizedBox(height: 12.0),
                        _buildDetailsAndMaterialWidgets(),
                        const SizedBox(height: 6.0),
                        _buildDivider(screenSize),
                        const SizedBox(height: 6.0),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Loading();
        });
  }

  _buildDivider(Size screenSize) {
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

  _buildProductImagesWidgets() {
    TabController imagesController = TabController(length: 1, vsync: this);

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
                  widget.posts['image'],
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

  _buildProductTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.posts['title'],
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
                readTimestamp(widget.posts["Date"]),
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  CollectionReference user = FirebaseFirestore.instance.collection("users");

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = TabController(length: 2, vsync: this);
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status: ${widget.posts["status"]}",
                                    style: textStyle,
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Ad posted by :\n ${data!['name']}(",
                                        style: textStyle,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow.shade700,
                                        size: 35,
                                      ),
                                      Text(
                                        "\n${data!['rating']})",
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
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
    } catch (e) {
      print(e);
    }
  }

  double _rating = 0;
  bool isLoading = false;
  IconData? _selectedIcon;

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
          await user.doc(data!["uid"]).update({
            "rating": _rating,
          });
          setState(() {
            isLoading = false;
            // confirm = "  Thank you for rating !";
          });
        } else {
          setState(() {
            // confirm = "Please Select at least 1 star";
          });
        }
      },
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _heading('Rating'),
        _ratingBar(),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 50,
          width: 120,
          child: elevatedButton,
        ),
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
      itemSize: 42.0,
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

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rate ${data!['name']}",
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 40,
                ),
              )
            ],
          ),
          content: rate(),
          actionsAlignment: MainAxisAlignment.center,
          actions: [],
        ),
      );

  //message and rate button
  _buildBottomNavigationBar(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 15,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900),
              onPressed: () {
                openDialog();
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.star_border,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Rate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatDetailsScreen(
                              receiverUid: data!['uid'],
                              senderUid: uId,
                              userData: data,
                              receiverName: data!['name'],
                              senderName: ChatCubit.get(context).username,
                            )));
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.message_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Message",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
