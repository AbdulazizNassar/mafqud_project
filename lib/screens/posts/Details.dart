import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:mafqud_project/screens/posts/detailPageWidgets.dart';
import '../chat/chat_details.dart';
import '../chat/cubit/chat_cubit.dart';

class Details extends StatefulWidget {
  final posts;
  final locality;
  final subLocality;
  final images;

  const Details(
      {super.key, this.posts, this.locality, this.subLocality, this.images});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  bool flag = false;
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

  buildProductImagesWidgets(dynamic posts) {
    List<String> list = [];
    for (var i = 0; i < 3; i++) {
      try {
        if (posts["image"][i] != null) {
          list.add(posts["image"][i]);
        }
      } catch (e) {
        print(e);
      }
    }
    TabController imagesController =
        TabController(length: list.length, vsync: this);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 250,
        child: Center(
            child: DefaultTabController(
                length: list.length,
                child: Stack(
                  children: <Widget>[
                    TabBarView(
                      children: list.map((image) {
                        return Image.network(image);
                      }).toList(),
                    ),
                    Container(
                      alignment: const FractionalOffset(0.5, 0.95),
                      child: TabPageSelector(
                        controller: imagesController,
                        selectedColor: Colors.grey,
                        color: Colors.white,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  _buildProductDetailsPage(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
        future: userRef.doc("${widget.posts!['userID']}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
                          buildProductImagesWidgets(widget.posts),
                          buildProductTitleWidget(widget.posts),
                          const SizedBox(height: 12.0),
                          buildStatusWidget(widget.posts),
                          const SizedBox(height: 12.0),
                          buildDivider(screenSize),
                          const SizedBox(height: 12.0),
                          buildCategoryInfoWidget(widget.posts),
                          const SizedBox(height: 12.0),
                          buildDivider(screenSize),
                          const SizedBox(height: 12.0),
                          buildAuthorInfoWidget(snapshot.data),
                          const SizedBox(height: 12.0),
                          buildDivider(screenSize),
                          buildDetailsAndMaterialWidgets(
                            widget,
                            snapshot.data,
                            userRef,
                            TabController(length: 2, vsync: this),
                          ),
                          const SizedBox(height: 6.0),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return Loading();
        });
  }

  double _rating = 0;
  bool isLoading = false;
  IconData? _selectedIcon;

  Column rate(dynamic data) {
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
          await userRef.doc(data!["uid"]).update({
            "numOfRating": data!['numOfRating'] + 1,
            "rating": _rating + data!['rating'],
          });
          setState(() {
            isLoading = false;
            // confirm = "  Thank you for rating !";
          });
          Navigator.of(context).pop();
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

  Future openDialog(dynamic data) => showDialog(
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
          content: rate(data),
          actionsAlignment: MainAxisAlignment.center,
        ),
      );

  //message and rate button
  _buildBottomNavigationBar(context) {
    Map<String, dynamic> data;
    return FutureBuilder<DocumentSnapshot>(
        future: userRef.doc("${widget.posts!['userID']}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            //prevent user from rating or messaging their own posts
            if (data['uid']
                .toString()
                .contains(AuthService().currentUser!.uid)) {
              return const Text('');
            }
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
                        openDialog(data);
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
                                      receiverUid: data['uid'],
                                      senderUid: uId,
                                      userData: data,
                                      receiverName: data['name'],
                                      senderName:
                                          ChatCubit.get(context).username,
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
          return Loading();
        });
  }
}
