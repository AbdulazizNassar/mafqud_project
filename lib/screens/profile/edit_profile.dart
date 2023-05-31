// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafqud_project/screens/chat/cubit/chat_cubit.dart';
import 'package:mafqud_project/screens/profile/profile.dart';
import '../../services/imagePicker.dart';
import '../../shared/AlertBox.dart';
import '../../shared/showToast.dart';

//profile screen -- to show signed in user info
class EditProfileScreen extends StatefulWidget {
  // final ChatUser user;

  EditProfileScreen({
    this.name,
    this.phone,
    this.uid,
    this.email,
    this.image,
    super.key,
    this.ID,
  });
  final String? name;

  final String? email;
  var image;
  final String? phone;
  final int? ID;
  final String? uid;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    idController = TextEditingController(text: widget.ID.toString());
    phoneController = TextEditingController(text: widget.phone);
    super.initState();
  }

  showBottomSheet(BuildContext context) {
    ImagePicker picker = ImagePicker();
    XFile? file;
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
                    file = await picker.pickImage(source: ImageSource.gallery);
                    file = await imgUpload(file);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBarSuccess("Successful", "Information updated "));
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
                    file = await picker.pickImage(source: ImageSource.camera);
                    widget.image = await imgUpload(file);
                    setState(() {});
                    showToast(
                        text: 'image updated', state: ToastStates.success);
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
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          title: const Text(
            'Edit Information',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromRGBO(59, 92, 222, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                //user profile picture
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Stack(alignment: Alignment.bottomRight, children: [
                        widget.image! == ''
                            ? const CircleAvatar(
                                radius: 60,
                                child: Image(
                                    image: AssetImage('assets/user.png'),
                                    height: 70),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.green,
                                backgroundImage: NetworkImage(widget.image!),
                              ),
                        CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                const Color.fromRGBO(59, 92, 222, 1.0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                showBottomSheet(context);
                              },
                            )),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                // about input field
                TextFormField(
                  //initialValue: widget.email,
                  controller: emailController,
                  // onsd: (val) => APIs.me.email = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email,
                          color: Color.fromRGBO(59, 92, 222, 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'example@mail.com',
                      label: const Text('Email')),
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                // name input field
                TextFormField(
                  //initialValue: widget.name,
                  controller: nameController,
                  // onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person,
                          color: Color.fromRGBO(59, 92, 222, 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'name',
                      label: const Text('Name')),
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                // about input field
                TextFormField(
                  controller: phoneController,
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone,
                          color: Color.fromRGBO(59, 92, 222, 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: '+966 XXXXXXXXXX',
                      label: const Text('phone')),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                TextFormField(
                  controller: idController,
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required Field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.card_giftcard,
                          color: Color.fromRGBO(59, 92, 222, 1.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: '',
                      label: const Text('ID')),
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                // update profile button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(59, 92, 222, 1.0),
                      shape: const StadiumBorder(),
                      minimumSize: Size(MediaQuery.of(context).size.width * .5,
                          MediaQuery.of(context).size.height * .06)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance.currentUser!
                          .updateEmail(emailController.text)
                          .then((value) {});
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .update({
                            'name': nameController.text,
                            'email': emailController.text,
                            'phoneNum': phoneController.text,
                            'ID': int.parse(idController.text),
                            "image": widget.image
                          })
                          .then((value) => {
                                ChatCubit.get(context).getUserData(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBarSuccess("Successful",
                                        "Information Update complete")),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ProfileScreen())),
                              })
                          .catchError((e) {
                            print(e.toString());
                          });
                    }
                  },
                  child: const Text('Save Changes',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
