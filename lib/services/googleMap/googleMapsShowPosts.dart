import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import '../../screens/posts/posts.dart';
import '../../shared/PostCards.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class MapPosts extends StatefulWidget {
  const MapPosts({super.key, this.lat, this.long, this.navKey});
  final lat;
  final long;
  final navKey;
  @override
  State<MapPosts> createState() => _MapPostsState();
}

//a set to store and display markers on the map
Set<Marker> _markers = {};

class _MapPostsState extends State<MapPosts> {
  @override
  final String googleApikey = "AIzaSyCj2A3BXC5GYHBlbyjIJlJPr8AWLHKCRv8";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  String location = "Search Location";

  @override
  void initState() {
    super.initState();
    postMapBuilder('');
  }

  postMapBuilder(String category) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      _markers.clear();
      if (categoryTitle != 'Filter') {
        await FirebaseFirestore.instance
            .collection("Posts")
            .where('category', isEqualTo: category)
            .get()
            .then((value) => value.docs.forEach((post) {
                  setState(() {
                    _markers.add(Marker(
                      icon: post["status"] == 'Found'
                          ? BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen)
                          : BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                      markerId: MarkerId(post.id),
                      position: LatLng(post["Lat"], post["Lng"]),
                      onTap: () {
                        try {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).clearSnackBars;
                          snackBarPostDetails(post, context);
                        } catch (e) {
                          print(e);
                        }
                      },
                    ));
                  });
                }));
      } else {
        await FirebaseFirestore.instance
            .collection("Posts")
            .get()
            .then((value) => value.docs.forEach((post) {
                  setState(() {
                    _markers.add(Marker(
                      icon: post["status"] == 'Found'
                          ? BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen)
                          : BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                      markerId: MarkerId(post.id),
                      position: LatLng(post["Lat"], post["Lng"]),
                      onTap: () {
                        try {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).clearSnackBars;

                          snackBarPostDetails(post, context);
                        } catch (e) {
                          print(e);
                        }
                      },
                    ));
                  });
                }));
      }

      setState(() {
        isLoading = false;
      });
    } else {
      return;
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  Theme filterButton(BuildContext context) {
    return Theme(
      data: themeData(context, highLightedColor),
      child: SizedBox(
        child: TextButton(
          onPressed: () {},
          child: PopupMenuButton<CategoryItem>(
            initialValue: selectedMenu,
            onOpened: () {
              if (categoryFlag) {
                setState(() {
                  categoryFlag = false;
                  highLightedColor = false;
                  categoryTitle = 'Filter';
                });
              }
            },
            onCanceled: () {
              setState(() {
                highLightedColor = false;
                categoryFlag = false;
                categoryTitle = "Filter";
              });
              postMapBuilder(categoryTitle);
            },
            onSelected: (CategoryItem item) {
              if (categoryFlag) {
                setState(() {
                  categoryFlag = false;
                  highLightedColor = false;
                  categoryTitle = "Filter";
                });
              } else {
                setState(() {
                  highLightedColor = true;
                  categoryFlag = true;
                  if (item.name == "Personalitems") {
                    categoryTitle =
                        "${item.name.substring(0, 8)} ${item.name.substring(8)}";
                  } else {
                    categoryTitle = item.name;
                  }
                });
              }
              selectedMenu = item;
              postMapBuilder(categoryTitle);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CategoryItem>>[
              PopupMenuItem(
                value: CategoryItem.Animals,
                child: ListTile(
                  leading: const Icon(
                    Icons.pets_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Animals", style: popupMenuStyle(context)),
                ),
              ),
              PopupMenuItem(
                value: CategoryItem.Electronics,
                child: ListTile(
                  leading: const Icon(
                    Icons.phone_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Electronics", style: popupMenuStyle(context)),
                ),
              ),
              PopupMenuItem(
                value: CategoryItem.Personalitems,
                child: ListTile(
                  leading: const Icon(
                    Icons.person_search_outlined,
                    color: Colors.white,
                  ),
                  title: Text("Personal Items", style: popupMenuStyle(context)),
                ),
              ),
            ],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                categoryFlag
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            highLightedColor = false;
                            categoryFlag = false;
                            categoryTitle = "Filter";
                          });
                          postMapBuilder(categoryTitle);
                        },
                        icon:
                            const Icon(Icons.close_outlined, color: Colors.red))
                    : filterIcon,
                FittedBox(
                  child: Text(
                    categoryTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Position? userLocation;
  bool searchFlag = false;
  bool categoryFlag = false;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Posts');
  CategoryItem? selectedMenu;
  String categoryTitle = 'Filter';
  Icon filterIcon = const Icon(
    Icons.filter_alt_outlined,
    color: Colors.white,
  );
  bool highLightedColor = false;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Posts"),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.blue.shade900,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  try {
                    setState(() {
                      isLoading = true;
                    });

                    navKey.currentState!.pushReplacement(MaterialPageRoute(
                        builder: (context) => Posts(
                              navKey: navKey,
                            )));
                    setState(() {
                      isLoading = false;
                    });
                  } catch (_) {}
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        navKey.currentState!.pushReplacement(MaterialPageRoute(
                            builder: (context) => Posts(
                                  navKey: navKey,
                                )));
                        setState(() {
                          isLoading = false;
                        });
                      } catch (_) {}
                    },
                    icon: const Icon(Icons.list_sharp)),
                filterButton(context),
              ],
            ),
            body: Stack(children: [
              GoogleMap(
                onTap: (_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
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
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          var newlatlang = LatLng(lat, lang);

                          //move map camera to selected place with animation
                          mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: newlatlang, zoom: 17)));
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
              ),
            ]));
  }
}
