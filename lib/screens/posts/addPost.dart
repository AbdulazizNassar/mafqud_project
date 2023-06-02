import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/services/googleMap/googleMapsAddPosts.dart';
import '../../shared/constants.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key, required this.paths}) : super(key: key);
  final paths;

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  String dropdownValue = 'Electronics';
  var title, description, category, imageName, reward;
  String? status;
  String msg = '';
  var selectedValue;
  var startlocation;
  double lat = 0.0;
  double long = 0.0;
  late MapScreen postition;

  late File file;
  final _formKey = GlobalKey<FormState>();
  CollectionReference posts = FirebaseFirestore.instance.collection("Posts");

  createPost(BuildContext context) {
    var data = _formKey.currentState;
    if (data!.validate() && status != null) {
      data.save();
      navKey.currentState!.push(MaterialPageRoute(
          builder: (context) => MapScreen(
                paths: widget.paths,
                lat: lat,
                long: long,
                title: title,
                description: description,
                category: category,
                status: status,
                reward: reward.toString().isEmpty ? '0' : reward,
              )));
    } else {
      setState(() {
        msg = "Please choose type of the post";
      });
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    setState(() {
      getUserCurrentLocation().then((value) {
        lat = value.latitude;
        long = value.longitude;
      });
    });
    setState(() {
      getUserCurrentLocation().then((value) {
        lat = value.latitude;
        long = value.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post 2/3"),
        backgroundColor: Colors.blue[900],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
               Row(
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
                maxLines: 1,
                maxLength: 30,
                onSaved: (val) {
                  title = val;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Enter the title',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
               Row(
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
                maxLines: 4,
                maxLength: 250,
                onSaved: (val) {
                  description = val;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Enter the description',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
               Row(
                children: [
                  Text(
                    "Category",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),

              const SizedBox(
                height: 7,
              ),
              DropdownButtonFormField(
                onSaved: (val) {
                  category = val;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                isExpanded: true,
                hint: const Text(
                  '  Choose a category',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black38,
                ),
                iconSize: 30,
                items: postCategories
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select category.';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
              ),
              const SizedBox(
                height: 7,
              ),
               Row(
                children: [
                  Text(
                    "Reward",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return null;
                  }
                  if (!val.isNum && !val.isNotEmpty) {
                    return "Enter Reward Value";
                  }
                  return null;
                },
                maxLines: 1,
                onSaved: (val) {
                  reward = val;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  hintText: '0 SAR (OPTIONAL)',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
               Row(
                children: [
                  Text(
                    "Post type",
                    style: textStyle,
                  ),
                ],
              ),

              //status radio button
              Column(
                children: [
                  RadioListTile(
                      title: const Text("Lost"),
                      value: "Lost",
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      }),
                  RadioListTile(
                      title: const Text("Found"),
                      value: "Found",
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      })
                ],
              ),
              Text(
                msg,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      createPost(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(60, 5, 60, 5),
                      backgroundColor: Colors.blue[900],
                    ),
                    child: const Text('Select Location'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
