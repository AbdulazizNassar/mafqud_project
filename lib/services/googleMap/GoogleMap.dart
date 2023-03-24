import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mafqud_project/services/googleMap/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'location_controller.dart';
import 'location_search_dialogue.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _cameraPosition;
  @override
  void initState() {
    super.initState();
    _cameraPosition =
        const CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
  }

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = new Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Select Location'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              backgroundColor: Colors.blue[700],
            ),
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  myLocationButtonEnabled: true,
                  onTap: (LatLng selectedPos) {
                    setState(() {
                      _markers.add(Marker(
                          markerId: const MarkerId("selectedLocation"),
                          position: selectedPos));
                    });
                  },
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                    locationController = mapController as LocationController;
                  },
                  initialCameraPosition: _cameraPosition,
                  markers: _markers,
                ),
                Positioned(
                  top: 5,
                  left: 10,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Get.dialog(
                        LocationSearchDialog(mapController: _mapController)),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Icon(Icons.location_on,
                            size: 25, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 5),
                        //here we show the address on the top
                        Expanded(
                          child: Text(
                            '${locationController.pickPlaceMark.name ?? ''} ${locationController.pickPlaceMark.locality ?? ''} '
                            '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                            style: const TextStyle(fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.search,
                            size: 25,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ]),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(25),
                  child: FloatingActionButton(
                    onPressed: () {
                      _currentLocation();
                    },
                    child: const Icon(Icons.center_focus_strong),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
