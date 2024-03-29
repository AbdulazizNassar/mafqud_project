import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/loading.dart';

import '../../screens/posts/editPost.dart';
import '../../screens/posts/posts.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.long,
      this.lat,
      this.title,
      this.description,
      this.category,
      required this.paths,
      this.status,
      this.reward,
      this.docID});
  final title;
  final description;
  final category;
  final paths;
  final status;
  final reward;
  final lat;
  final long;
  final docID;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

LatLng? selectedLocation;
savePostToFirebase(var title, description, category, imageUrl, String? status,
    reward, docID) async {
  var userID = AuthService().currentUser!.uid;
  List<String> imagePath = [];
  if (docID != null) {
    await FirebaseFirestore.instance.collection("Posts").doc(docID).update({
      "title": title,
      "description": description,
      "category": category,
      "userID": userID,
      "status": status,
      "image": imageUrl,
      "Date": DateTime.now(),
      "Lat": selectedLocation!.latitude,
      "Lng": selectedLocation!.longitude,
      'reward': reward,
    });
  } else {
    await FirebaseFirestore.instance.collection("Posts").add({
      "title": title,
      "description": description,
      "category": category,
      "userID": userID,
      "status": status,
      "image": imageUrl,
      "Date": DateTime.now(),
      'expiry': DateTime.now().add(const Duration(days: 14)),
      "Lat": selectedLocation!.latitude,
      "Lng": selectedLocation!.longitude,
      'reward': reward,
    });
  }
}

class _MapScreenState extends State<MapScreen> {
  loadMarker() {
    if (widget.lat != null) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('1'),
          position: LatLng(widget.lat, widget.long),
        ));
      });
    }
  }

  final Set<Marker> _markers = {};
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
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMarker();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Select Location 3/3"),
            centerTitle: true,
            backgroundColor: Colors.blue.shade900,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                navKey.currentState!.pop();
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (selectedLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBarError(
                          "Please Select a location",
                          "Select a location by manually selected the pin or by searching"));
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await savePostToFirebase(
                          widget.title,
                          widget.description,
                          widget.category,
                          widget.paths,
                          widget.status,
                          widget.reward,
                          widget.docID);
                      navKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const Posts()));
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBarSuccess(
                              "success", "Post created successfully"));

                      navKey.currentState!.pushReplacementNamed("Posts");
                    }
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: Stack(children: [
            GoogleMap(
              myLocationEnabled: true,
              onTap: (LatLng newpos) {
                setState(() {
                  _markers.clear();
                  _markers.add(Marker(
                    markerId: const MarkerId('selectedLocation'),
                    position: LatLng(newpos.latitude, newpos.longitude),
                  ));
                  selectedLocation = LatLng(newpos.latitude, newpos.longitude);
                });
              },
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: LatLng(widget.lat, widget.long), //initial position
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
                        setState(() {
                          _markers.add(Marker(
                            markerId: const MarkerId('selectedLocation'),
                            position: LatLng(
                                newlatlang.latitude, newlatlang.longitude),
                          ));
                          selectedLocation =
                              LatLng(newlatlang.latitude, newlatlang.longitude);
                        });
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
