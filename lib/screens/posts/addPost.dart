
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({Key? key}) : super(key: key);

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  String dropdownValue = 'Electronics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        backgroundColor: Colors.blue[900],
      ),
      body:  Container(
        child: Column(
          children: [
            Form(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    TextFormField(
                      onSaved: (val){},
                      style: TextStyle(fontSize: 25, color: Colors.grey[900]),
                      maxLength: 30,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Title",
                        prefixIcon: Icon(Icons.note)),
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 2,
                      maxLength: 200,
                      style: TextStyle(fontSize: 25, color: Colors.grey[900]),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Description",
                          prefixIcon: Icon(Icons.note)),
                    ),
                    SizedBox(height: 10,),
                    DropdownButton<String>(
                      isExpanded: true,

                      value: dropdownValue,

                      style: TextStyle(fontSize: 35, color: Colors.grey[900]),
                      items: <String>['Electronics', 'Personal items', 'Animals']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300, color: Colors.grey[700]),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 10,),
                    TextButton(
                        onPressed: (){},
                        child: Text("Add Image"),
                    ),
                      ]
                      ),
                    ),
      ],
                ))
    );


  }
}

