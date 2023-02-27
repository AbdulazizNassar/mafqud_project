
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key}) : super(key: key);

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  String dropdownValue = 'Electronics';
  final List<String> items = ['Electronics', 'Personal items','Animals'];
  var title, description, category;
  var selectedValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
              SizedBox(height: 50,),
              Row(
                children: [
                  Text("Title",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25), )
                ],
              ),
              SizedBox(height: 7,),
              TextFormField(
                maxLines: 1,
                maxLength: 30,
                onSaved: (val){
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
                  Text("Description",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25), )
                ],
              ),
              SizedBox(height: 7,),
              TextFormField(
                maxLines: 4,
                maxLength: 250,
                onSaved: (val){
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
                  Text("Category",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25), )
                ],
              ),
              SizedBox(height: 7,),
              DropdownButtonFormField(
                onSaved: (val){
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
                  'Choose a category',
                  style: TextStyle(fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                items: items
                    .map((item) =>
                    DropdownMenuItem<String>(
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
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {},
                child: const Text('Create post'),
              ),
            ],
          ),
        ),
      ),
    );


  }
}

