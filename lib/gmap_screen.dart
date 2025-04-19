// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class GMapPage extends StatefulWidget {
//   @override
//   _GMapPageState createState() => _GMapPageState();
// }
//
// class _GMapPageState extends State<GMapPage> {
//   final Completer<GoogleMapController> _controller = Completer();
//   late GoogleMapController _mapController;
//
//   LatLng _currentPosition = LatLng(18.420652, 73.905094);
//   LatLng sourceLocation = LatLng(18.5204, 73.8567);
//   LatLng destination = LatLng(18.5310, 73.8446);
//
//   List<LatLng> polylineCoordinates = [];
//   LocationData? currentLocation;
//
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
//
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//
//   final String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo"; // Replace this
//   final Color primaryColor = Colors.blue;
//
//   void getCurrentLocation() async {
//     Location location = Location();
//     currentLocation = await location.getLocation();
//
//     GoogleMapController googleMapController = await _controller.future;
//
//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: 15,
//             target: LatLng(newLoc.latitude!, newLoc.longitude!),
//           ),
//         ),
//       );
//       setState(() {});
//     });
//   }
//
//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       google_api_key,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );
//
//     if (result.points.isNotEmpty) {
//       polylineCoordinates.clear();
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//       setState(() {});
//     }
//   }
//
//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, "assets/pin_source.png")
//         .then((icon) => sourceIcon = icon);
//
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, "assets/pin_destination.png")
//         .then((icon) => destinationIcon = icon);
//
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, "assets/pin_Badge.png")
//         .then((icon) => currentLocationIcon = icon);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     getPolyPoints();
//     _getUserLocation();
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.deniedForever) return;
//
//     Position position =
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//     });
//
//     _mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(_currentPosition, 15),
//     );
//   }
//
//   void _onSearch() {
//     // Hardcoded example - replace with geocoding if needed
//     if (sourceController.text.trim().toLowerCase() == 'shivajinagar') {
//       sourceLocation = LatLng(18.5308, 73.8470);
//     }
//     if (destinationController.text.trim().toLowerCase() == 'swargate') {
//       destination = LatLng(18.5018, 73.8636);
//     }
//
//     getPolyPoints();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           currentLocation == null
//               ? const Center(child: Text("Loading..."))
//               : GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(
//                   currentLocation!.latitude!, currentLocation!.longitude!),
//               zoom: 15,
//             ),
//             polylines: {
//               Polyline(
//                 polylineId: PolylineId("route"),
//                 points: polylineCoordinates,
//                 color: primaryColor,
//                 width: 6,
//               ),
//             },
//             markers: {
//               Marker(
//                 markerId: MarkerId("currentLocation"),
//                 icon: currentLocationIcon,
//                 position: LatLng(currentLocation!.latitude!,
//                     currentLocation!.longitude!),
//               ),
//               Marker(
//                 markerId: MarkerId("source"),
//                 icon: sourceIcon,
//                 position: sourceLocation,
//               ),
//               Marker(
//                 markerId: MarkerId("destination"),
//                 icon: destinationIcon,
//                 position: destination,
//               ),
//             },
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _controller.complete(controller);
//             },
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//           ),
//
//           // Search bar UI
//           Positioned(
//             top: 30,
//             left: 15,
//             right: 15,
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 5,
//                         offset: Offset(0, 2),
//                       )
//                     ],
//                   ),
//                   child: TextField(
//                     controller: sourceController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter source (e.g. Shivajinagar)',
//                       border: InputBorder.none,
//                       icon: Icon(Icons.location_on),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 5,
//                         offset: Offset(0, 2),
//                       )
//                     ],
//                   ),
//                   child: TextField(
//                     controller: destinationController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter destination (e.g. Swargate)',
//                       border: InputBorder.none,
//                       icon: Icon(Icons.location_pin),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _onSearch,
//                   child: Text("Get Route"),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

  LatLng _currentPosition = LatLng(18.420652, 73.905094);
  LatLng sourceLocation = LatLng(18.5204, 73.8567);
  LatLng destination = LatLng(18.5310, 73.8446);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo"; // Replace this
  final Color primaryColor = Colors.blue;

  void getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 15,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );
      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: google_api_key,
      request: PolylineRequest(origin:  PointLatLng(sourceLocation.latitude, sourceLocation.longitude), destination: PointLatLng(destination.latitude, destination.longitude),  mode: TravelMode.driving)
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/pin_source.png")
        .then((icon) => sourceIcon = icon);

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/pin_destination.png")
        .then((icon) => destinationIcon = icon);

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/pmt_bus.png")
        .then((icon) => currentLocationIcon = icon);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position =
    await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition, 15),
    );
  }

  void _onSearch() {
    // Hardcoded example - replace with geocoding if needed
    if (sourceController.text.trim().toLowerCase() == 'shivajinagar') {
      sourceLocation = LatLng(18.5308, 73.8470);
    }
    if (destinationController.text.trim().toLowerCase() == 'swargate') {
      destination = LatLng(18.5018, 73.8636);
    }

    getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: Text("Loading..."))
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 15,
            ),
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: polylineCoordinates,
                color: primaryColor,
                width: 6,
              ),
            },
            markers: {
              Marker(
                markerId: MarkerId("currentLocation"),
                icon: currentLocationIcon,
                position: LatLng(currentLocation!.latitude!,
                    currentLocation!.longitude!),
              ),
              Marker(
                markerId: MarkerId("source"),
                icon: sourceIcon,
                position: sourceLocation,
              ),
              Marker(
                markerId: MarkerId("destination"),
                icon: destinationIcon,
                position: destination,
              ),
            },
            onMapCreated: (controller) {
              _mapController = controller;
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // Search bar UI
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: sourceController,
                    decoration: InputDecoration(
                      hintText: 'Enter source (e.g. Shivajinagar)',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: 'Enter destination (e.g. Swargate)',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: Text("Get Route"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
