import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mafqud_project/services/GoogleMap.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key}) : super(key: key);

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  String dropdownValue = 'Electronics';
  var title, description, category, imageName, imageUrl;
  String? status;
  String msg = '';
  var selectedValue;
  late File file;
  final _formKey = GlobalKey<FormState>();
  CollectionReference posts = FirebaseFirestore.instance.collection("Posts");

  createPost(BuildContext context) async {
    var data = _formKey.currentState;
    if (data!.validate() && status != null) {
      if (imageUrl != null) {
        data.save();
        savePostToFirebase(
            title, description, category, imageName, imageUrl, status);
        Navigator.of(context as BuildContext).pushReplacementNamed('Posts');
      } else {
        setState(() {
          msg = "Please choose image";
        });
      }
    } else {
      setState(() {
        msg = "Please choose type of the post";
      });
    }
  }

  imgUpload(file) async {
    print('${file?.path}');

    if (file == null) return 'Please choose image';
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(file.name);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  showBottomSheet(BuildContext context) {
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
                    ImagePicker picker = ImagePicker();
                    XFile? file =
                        await picker.pickImage(source: ImageSource.gallery);
                    imgUpload(file);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: const [
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
                    ImagePicker picker = ImagePicker();
                    XFile? file =
                        await picker.pickImage(source: ImageSource.camera);
                    imgUpload(file);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: const [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        backgroundColor: Colors.blue[900],
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
              Row(
                children: const [
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
                children: const [
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
                children: const [
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
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
              ),
              const SizedBox(height: 25),
              Row(
                children: const [
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
              ElevatedButton(
                onPressed: () {
                  showBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text("Add Image"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await createPost(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(60, 5, 60, 5),
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text('Create post'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
