import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mafqud_project/services/auth.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

LatLng? selectedLocation;
void savePostToFirebase(var title, description, category, imageName, imageUrl,
    String? status) async {
  var userID = AuthService().currentUser!.uid;
  await FirebaseFirestore.instance.collection("Posts").add({
    "title": title,
    "description": description,
    "category": category,
    "userID": userID,
    "status": status,
    "image": imageUrl,
    "Date": DateTime.now(),
    "LatLng": selectedLocation,
  });
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> _markers = Set();
  final String googleApikey = "AIzaSyCj2A3BXC5GYHBlbyjIJlJPr8AWLHKCRv8";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(1, 1);
  String location = "Search Location";

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation().then((value) {
      startLocation = LatLng(value.altitude, value.longitude);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Location"),
          centerTitle: true,
          backgroundColor: Colors.blue.shade900,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          //TODO: create post
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.done))],
        ),
        body: Stack(children: [
          GoogleMap(
            myLocationEnabled: true,
            onTap: (LatLng newpos) {
              setState(() {
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
              target: startLocation, //initial position
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
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
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
                    mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(pos.latitude, pos.longitude),
                            zoom: 14)));
                  });
                },
                child: const Icon(Icons.location_on_sharp)),
          )
        ]));
  }
}
