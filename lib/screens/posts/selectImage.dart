import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/posts/addPost.dart';
import 'package:mafqud_project/screens/posts/editPost.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mafqud_project/services/googleMap/googleMapsAddPosts.dart';
import '../../services/imagePicker.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';
import 'package:mafqud_project/services/googleMap/googleMapsAddPosts.dart';

class addImages extends StatefulWidget {
  const addImages({super.key, this.posts, this.docID});
  final posts;
  final docID;
  @override
  State<addImages> createState() => _addImagesState();
}

class _addImagesState extends State<addImages> {
  var imageUrl;
  XFile? file;
  bool isloaded = false;
  List<XFile?> images = [];
  String msg = '';
  List<String> list = [];

  loadImage() {
    for (var i = 0; i < 3; i++) {
      try {
        if (widget.posts["image"][i] != null) {
          list.add(widget.posts["image"][i]);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  showBottomSheet(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please Choose Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (file == null) {
                      return;
                    }
                    if (widget.posts != null) {
                      list.add(await imgUpload(file));
                      setState(() {
                        isloaded = true;
                      });
                    } else {
                      setState(() {
                        images.add(file);
                        isloaded = true;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Gallery",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    file = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (file == null) {
                      return;
                    }
                    if (widget.posts != null) {
                      list.add(await imgUpload(file));
                      setState(() {
                        isloaded = true;
                      });
                    } else {
                      setState(() {
                        images.add(file);
                        isloaded = true;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.camera,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Camera",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      loadImage();
    } catch (e) {}
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : SafeArea(
          child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        List<String> paths = [];

                        if (images.isNotEmpty) {
                          for (var element in images) {
                            paths.add(await imgUpload(element));
                          }

                          navKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => AddPosts(
                                    paths: paths,
                                  )));
                        } else if (list.isNotEmpty) {
                          navKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => EditPost(
                                    images: list,
                                    posts: widget.posts,
                                    docID: widget.docID,
                                  )));
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          setState(() {
                            msg = 'You must upload at least 1 image ';
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Colors.green,
                      ))
                ],
                centerTitle: true,
                title: const Text("Choose Image 1/3"),
                backgroundColor: Colors.blue.shade900,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                        thickness: 10,
                      ),
                      itemCount: list.isNotEmpty
                          ? list.length
                          : images.isNotEmpty
                              ? images.length
                              : 3,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              try {
                                if (images.isNotEmpty) {
                                  images.removeAt(index);
                                } else if (list.isNotEmpty) {
                                  list.removeAt(index);
                                }
                              } catch (e) {}
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              images.isEmpty && list.isEmpty
                                  ? imageContainer(
                                      context,
                                      index,
                                      const Center(
                                          child: Icon(
                                        Icons.image_outlined,
                                        size: 100,
                                      )))
                                  : list.isNotEmpty
                                      ? imageContainer(
                                          context,
                                          index,
                                          Image.network(
                                            list[index],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : imageContainer(
                                          context,
                                          index,
                                          Image.file(
                                            File(images[index]!.path),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                              const Align(
                                alignment: Alignment.bottomLeft,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (images.length < 3 && list.length < 3) {
                        showBottomSheet(context);
                      } else {
                        setState(() {
                          msg = 'Maximum 3 images';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                    ),
                  ),
                  Text(
                    msg,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              )));

  Container imageContainer(BuildContext context, int index, Widget? child) {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        child: child);
  }
}
