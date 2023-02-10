import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Electronics';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70,),
              Text('Search an item:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              SizedBox(height: 10,),
              TextField(
                onChanged: (value) => null,
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              SizedBox(height: 70,),
              Text(' Or by Categories: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              SizedBox(height: 30,),
              DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    items: <String>['Electronics', 'Personal items', 'Animals']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize:17),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      },
                  ),
              SizedBox(height: 30,),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text("Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                ),
              )
                ],
              ),
          )

      );
  }
}
