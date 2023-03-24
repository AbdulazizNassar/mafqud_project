import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
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
                    child: const Icon(Icons.center_focus_strong_outlined),
                    onPressed: () async {
                      await getUserCurrentLocation().then((value) {
                        setState(() {
                          _markers.add(Marker(
                            markerId: MarkerId("currentLocation"),
                            position: LatLng(value.latitude, value.longitude),
                          ));
                        });
                        _mapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(value.latitude, value.longitude),
                                zoom: 14)));
                      });
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}
