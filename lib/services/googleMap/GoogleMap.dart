import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mafqud_project/shared/loading.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData currentLocation;
  GoogleMapController? mapController;

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text(
              "Select location",
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.center_focus_strong_outlined),
            onPressed: () {
              mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(currentLocation.latitude!,
                          currentLocation.longitude!),
                      zoom: 14)));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 14),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: {
              Marker(
                  markerId: const MarkerId("source"),
                  position: LatLng(
                      currentLocation.latitude!, currentLocation.longitude!))
            },
          ),
        );
}
