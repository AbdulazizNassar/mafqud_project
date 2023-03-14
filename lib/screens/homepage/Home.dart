import 'package:flutter/material.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/shared/Lists.dart';
import 'package:mafqud_project/shared/NavMenu.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Electronics';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
        ),
        drawer: const NavMenu(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              const Text('Search an item:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) => null,
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 70,
              ),
              const Text(' Or by Categories: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(
                height: 30,
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                items: Categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("Posts");
                  },
                  child: const Text(
                    "Search",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
