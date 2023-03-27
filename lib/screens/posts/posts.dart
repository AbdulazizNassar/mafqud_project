import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mafqud_project/screens/posts/postDetails.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/services/auth.dart';

import '../../shared/loading.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

//get address based on long and lat
late String locality;
late String subLocality;
getPlacmark(posts) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(posts["Lat"], posts['Lng']);
  locality = placemarks.first.locality!;
  subLocality = placemarks.first.subLocality!;
  print("$locality, $subLocality");
}

class _PostsState extends State<Posts> {
  Query<Map<String, dynamic>> postsRef =
      FirebaseFirestore.instance.collection('Posts').orderBy('Date');

  var posts = [];

  Future<void> getData() async {
    // Get docs from collection reference
    Query query = postsRef.where("status", isEqualTo: "Lost");
    QuerySnapshot querySnapshot = await query.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    posts = allData;
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.list))
            ],
            title: const Text("Posts"),
            backgroundColor: Colors.blue[900],
            bottom: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blue.shade300),
                tabs: const [
                  Tab(
                    child: Text("Found"),
                  ),
                  Tab(
                    child: Text("Lost"),
                  )
                ]),
          ),
          body: TabBarView(
            children: [
              post("Found"),
              post("Lost"),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[900],
            onPressed: () {
              Navigator.of(context).pushNamed("AddPost");
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> post(String status) {
    return FutureBuilder(
        future: postsRef.where("status", isEqualTo: status).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, i) {
                  return ListPosts(posts: snapshot.data?.docs[i]);
                });
          } else if (snapshot.hasError) {
            return const Text("Error");
            print(snapshot.error);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            const Text("loading");
          }
          return const Text(".");
        });
  }
}

class MapPosts extends StatefulWidget {
  final posts;
  const MapPosts({super.key, this.posts});

  @override
  State<MapPosts> createState() => _MapPostsState();
}

class _MapPostsState extends State<MapPosts> {
  @override
  final String googleApikey = "AIzaSyCj2A3BXC5GYHBlbyjIJlJPr8AWLHKCRv8";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  String location = "Search Location";

  @override
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Results"),
            centerTitle: true,
            backgroundColor: Colors.blue.shade900,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            //TODO: create post
            actions: [
              IconButton(onPressed: () async {}, icon: const Icon(Icons.done))
            ],
          ),
          body: Stack(children: [
            GoogleMap(
              myLocationEnabled: true,

              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: LatLng(widget.posts['lat'],
                    widget.posts['lng']), //initial position
                zoom: 14.0, //initial zoom level
              ),
              mapType: MapType.normal, //map type
              onMapCreated: (controller) {
                //method called when map is created
                setState(() {
                  mapController = controller;
                });
              },
              markers: _markers,
            ),

            //search autoconplete input
            Positioned(
                //search input bar
                top: 10,
                child: InkWell(
                    onTap: () async {
                      var place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: googleApikey,
                          mode: Mode.overlay,
                          types: [],
                          components: [Component(Component.country, 'SA')],
                          strictbounds: false,
                          //google_map_webservice package
                          onError: (err) {
                            print(err);
                          });

                      if (place != null) {
                        setState(() {
                          location = place.description.toString();
                        });

                        //form google_maps_webservice package
                        final plist = GoogleMapsPlaces(
                          apiKey: googleApikey,
                          apiHeaders:
                              await const GoogleApiHeaders().getHeaders(),
                          //from google_api_headers package
                        );
                        String placeid = place.placeId ?? "0";
                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;
                        var newlatlang = LatLng(lat, lang);

                        //move map camera to selected place with animation
                        mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: newlatlang, zoom: 17)));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: ListTile(
                              title: Text(
                                location,
                                style: const TextStyle(fontSize: 18),
                              ),
                              trailing: const Icon(Icons.search),
                              dense: true,
                            )),
                      ),
                    ))),
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.all(20),
              child: FloatingActionButton(
                  onPressed: () async {
                    await getUserCurrentLocation().then((pos) {
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(pos.latitude, pos.longitude),
                              zoom: 14)));
                    });
                  },
                  child: const Icon(Icons.location_on_sharp)),
            )
          ]));
}

class ListPosts extends StatelessWidget {
  final posts;

  const ListPosts({super.key, this.posts});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => postDetails(posts: posts)));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Image.network(
                  posts['image'],
                  fit: BoxFit.cover,
                )),
            Expanded(
                flex: 9,
                child: ListTile(
                  title: Text("${posts['title']}"),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("${posts['category']}")),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${posts['status']}",
                            style: const TextStyle(
                              backgroundColor: Colors.amber,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ]),
                )),
            const Icon(
              Icons.timer_outlined,
              size: 30,
            ),
            Text(
              readTimestamp(posts["Date"]),
              style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
            ),
            const Icon(
              Icons.keyboard_double_arrow_right_outlined,
              size: 30,
            ),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
