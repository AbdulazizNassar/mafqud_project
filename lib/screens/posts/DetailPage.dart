import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../shared/DateTime.dart';
import '../chat/chat_details.dart';
import '../chat/cubit/chat_cubit.dart';

class ProductDetailPage extends StatefulWidget {
  final posts;
  final locality;
  final subLocality;

  const ProductDetailPage(
      {super.key, this.posts, this.locality, this.subLocality});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
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
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                Expanded(
                    flex: 3,
                    child: Image.network(
                      widget.posts['image'],
                      fit: BoxFit.fill,
                      height: 350,
                    )),
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

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = TabController(length: 2, vsync: this);
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    try {
      return FutureBuilder<DocumentSnapshot>(
          future: user.doc("${widget.posts['userID']}").get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
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
                                    height: 50,
                                  ),
                                  Text(
                                    "Ad posted by : ${data['name']}",
                                    style: textStyle,
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

  _buildBottomNavigationBar() {
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
              onPressed: () {},
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                              receiverUid: widget.posts.id,
                              senderUid: uId,
                              userData: data,
                              receiverName: data!['name'],
                              senderName: ChatCubit.get(context).username,
                            )));
              },
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
