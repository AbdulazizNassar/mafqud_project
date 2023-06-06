import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/posts/selectImage.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/services/googleMap/googleMapsAddPosts.dart';
import 'package:mafqud_project/shared/Lists.dart';

import '../../services/googleMap/googleMapsShowPosts.dart';
import '../../services/imagePicker.dart';
import '../../shared/constants.dart';

class EditPost extends StatefulWidget {
  final posts;
  final docID;
  final images;
  const EditPost({super.key, this.posts, this.docID, this.images});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String dropdownValue = 'Electronics';
  var title, description, category, imageName, imageUrl, reward;
  String? status;
  String msg = '';
  late File file;
  var selectedValue;

  final _formKey = GlobalKey<FormState>();
  CollectionReference post = FirebaseFirestore.instance.collection("Posts");

  @override
  void initState() {
    super.initState();
    setState(() {
      status = widget.posts['status'];
      getUserCurrentLocation().then((value) {
        lat = value.latitude;
        long = value.longitude;
      });
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  validateInfo() {
    var data = _formKey.currentState;
    if (data!.validate()) {
      data.save();
      navKey.currentState!.push(MaterialPageRoute(
          builder: (context) => MapScreen(
                title: title,
                lat: widget.posts['Lat'],
                long: widget.posts['Lng'],
                description: description,
                category: category,
                paths: widget.images,
                status: status,
                reward: reward,
                docID: widget.docID,
              )));
    }
  }

  double lat = 0.0;
  double long = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Update Post"),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            onPressed: () {
              navKey.currentState!.push(MaterialPageRoute(
                  builder: (_) => addImages(
                        posts: widget.posts,
                        docID: widget.docID,
                      )));
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          IconButton(
            onPressed: () {
              validateInfo();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
            ),
            icon: const Icon(Icons.check_box_outlined),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Row(
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
                initialValue: widget.posts['title'],
                maxLines: 1,
                maxLength: 30,
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
                onSaved: (val) {
                  setState(() {
                    title = val;
                  });
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
              const Row(
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
                initialValue: widget.posts['description'],
                maxLines: 4,
                maxLength: 250,
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
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
              const Row(
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
                  setState(() {
                    category = val;
                  });
                },
                value: widget.posts['category'],
                decoration: InputDecoration(
                  //Add isDense true and zero Padding.
                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  //Add more decoration as you want here
                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                ),
                isExpanded: true,
                hint: const Text(
                  '  Choose a category',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
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
                  setState(() {
                    category = value;
                  });
                  //Do something when changing the item if you want.
                },
              ),
              const Row(
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
                initialValue: widget.posts['reward'],
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
              const SizedBox(height: 25),
              const Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
