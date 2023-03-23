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
  GoogleMapController? mapController;
  Set<Marker> _markers = Set();

  @override
  void initState() {
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
              Location location = Location();
              location.getLocation().then((location) {
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(location.latitude!, location.longitude!),
                        zoom: 14)));
              });
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          body: GoogleMap(
            initialCameraPosition:
                //TODO: get current user location
                CameraPosition(target: LatLng(35, 25), zoom: 14),
            onTap: (LatLng newpos) {
              setState(() {
                _markers.add(
                  Marker(
                    // This marker id can be anything that uniquely identifies each marker.
                    markerId: MarkerId('title'),
                    position: LatLng(newpos.latitude, newpos.longitude),
                  ),
                );
              });
            },
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: _markers,
          ),
        );
}
