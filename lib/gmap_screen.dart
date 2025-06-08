// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as loc;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
//
// // Replace with your actual API key here or import from constants.dart
// const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
// const Color primaryColor = Color(0xFF7861FF);
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
//   LatLng? sourceLocation;
//   LatLng? destination;
//
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//
//   loc.Location location = loc.Location();
//   loc.LocationData? currentLocation;
//
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
//
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     _getUserLocation();
//   }
//
//   void getCurrentLocation() async {
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
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   Future<LatLng?> _getCoordinatesFromAddress(String address) async {
//     try {
//       var locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         return LatLng(locations.first.latitude, locations.first.longitude);
//       } else {
//         Fluttertoast.showToast(
//           msg: "Location not found: $address",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//         return null;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error geocoding: $address - $e",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//       return null;
//     }
//   }
//
//   void getPolyPoints() async {
//     if (sourceLocation != null && destination != null) {
//       final polylinePoints = PolylinePoints();
//
//       final request = DirectionsRequest(
//         origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
//         destination: PointLatLng(destination!.latitude, destination!.longitude),
//         travelMode: TravelMode.driving,
//       );
//
//       final result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: google_api_key,
//         request: request,
//       );
//
//
//       if (result.points.isNotEmpty) {
//         // handle points here
//       }
//
//
//       if (result.points.isNotEmpty) {
//         polylineCoordinates.clear();
//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }
//         _createPolyline();
//
//         // Animate camera to fit polyline route
//         final GoogleMapController controller = await _controller.future;
//         LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
//         controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
//
//         setState(() {});
//       } else {
//         Fluttertoast.showToast(
//           msg: "Could not find a route between the specified locations.",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.orangeAccent,
//           textColor: Colors.white,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Please enter both source and destination.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.grey,
//         textColor: Colors.white,
//       );
//     }
//   }
//
//   void _createPolyline() {
//     polylines.clear();
//     polylines.add(
//       Polyline(
//         polylineId: PolylineId("route"),
//         points: polylineCoordinates,
//         color: primaryColor,
//         width: 6,
//       ),
//     );
//   }
//
//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_source.png")
//         .then((icon) => setState(() => sourceIcon = icon));
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_destination.png")
//         .then((icon) => setState(() => destinationIcon = icon));
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pmt_bus.png")
//         .then((icon) => setState(() => currentLocationIcon = icon));
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(
//         msg: "Please enable location services",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Fluttertoast.showToast(
//           msg: "Location permission denied",
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//         msg: "Location permissions are permanently denied",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition();
//     if (mounted) {
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });
//
//       _mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(_currentPosition, 15),
//       );
//     }
//   }
//
//   void _onSearch() async {
//     sourceLocation = await _getCoordinatesFromAddress(sourceController.text.trim());
//     destination = await _getCoordinatesFromAddress(destinationController.text.trim());
//
//     if (sourceLocation != null && destination != null) {
//       getPolyPoints();
//     }
//   }
//
//   void _clearRoute() {
//     setState(() {
//       polylines.clear();
//       polylineCoordinates.clear();
//       sourceLocation = null;
//       destination = null;
//       sourceController.clear();
//       destinationController.clear();
//     });
//   }
//
//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double x0 = list[0].latitude;
//     double x1 = list[0].latitude;
//     double y0 = list[0].longitude;
//     double y1 = list[0].longitude;
//
//     for (LatLng latLng in list) {
//       if (latLng.latitude > x1) x1 = latLng.latitude;
//       if (latLng.latitude < x0) x0 = latLng.latitude;
//       if (latLng.longitude > y1) y1 = latLng.longitude;
//       if (latLng.longitude < y0) y0 = latLng.longitude;
//     }
//     return LatLngBounds(
//       northeast: LatLng(x1, y1),
//       southwest: LatLng(x0, y0),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Map Route'),
//         backgroundColor: primaryColor,
//       ),
//       body: Stack(
//         children: [
//           currentLocation == null
//               ? const Center(child: CircularProgressIndicator())
//               : GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//               zoom: 15,
//             ),
//             polylines: polylines,
//             markers: {
//               Marker(
//                 markerId: MarkerId("currentLocation"),
//                 icon: currentLocationIcon,
//                 position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//               ),
//               if (sourceLocation != null)
//                 Marker(
//                   markerId: MarkerId("source"),
//                   icon: sourceIcon,
//                   position: sourceLocation!,
//                 ),
//               if (destination != null)
//                 Marker(
//                   markerId: MarkerId("destination"),
//                   icon: destinationIcon,
//                   position: destination!,
//                 ),
//             },
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _controller.complete(controller);
//             },
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//           ),
//           Positioned(
//             top: 30,
//             left: 15,
//             right: 15,
//             child: Column(
//               children: [
//                 _buildTextField(sourceController, 'Enter source address', Icons.location_on),
//                 SizedBox(height: 10),
//                 _buildTextField(destinationController, 'Enter destination address', Icons.location_pin),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _onSearch,
//                       child: Text("Get Route"),
//                     ),
//                     ElevatedButton(
//                       onPressed: _clearRoute,
//                       child: Text("Clear Route"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           icon: Icon(icon),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as loc;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
// const Color primaryColor = Color(0xFF7861FF);
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
//   LatLng? sourceLocation;
//   LatLng? destination;
//
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//
//   loc.Location location = loc.Location();
//   loc.LocationData? currentLocation;
//
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
//
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     _getUserLocation();
//   }
//
//   void getCurrentLocation() async {
//     currentLocation = await location.getLocation();
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
//       if (mounted) setState(() {});
//     });
//   }
//
//   Future<LatLng?> _getCoordinatesFromAddress(String address) async {
//     try {
//       var locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         return LatLng(locations.first.latitude, locations.first.longitude);
//       } else {
//         Fluttertoast.showToast(
//           msg: "Location not found: $address",
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error geocoding: $e",
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//     }
//     return null;
//   }
//
//   void getPolyPoints() async {
//     if (sourceLocation == null || destination == null) {
//       Fluttertoast.showToast(
//         msg: "Enter both source & destination",
//         backgroundColor: Colors.grey,
//       );
//       return;
//     }
//
//     final polylinePoints = PolylinePoints();
//
//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       request: PolylineRequest(
//         origin: PointLatLng(
//             sourceLocation!.latitude, sourceLocation!.longitude),
//         destination: PointLatLng(
//             destination!.latitude, destination!.longitude),
//         mode: TravelMode.driving,
//       ),
//       googleApiKey: google_api_key,
//     );
//
//     if (result.points.isNotEmpty) {
//       polylineCoordinates.clear();
//       result.points.forEach((point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//       _createPolyline();
//
//       final controller = await _controller.future;
//       LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
//       controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
//
//       setState(() {});
//     } else {
//       Fluttertoast.showToast(
//         msg: "No route found",
//         backgroundColor: Colors.orangeAccent,
//       );
//     }
//   }
//
//   void _createPolyline() {
//     polylines.clear();
//     polylines.add(Polyline(
//       polylineId: PolylineId('route'),
//       points: polylineCoordinates,
//       color: primaryColor,
//       width: 6,
//     ));
//   }
//
//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, 'assets/pin_source.png')
//         .then((icon) => setState(() => sourceIcon = icon));
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, 'assets/pin_destination.png')
//         .then((icon) => setState(() => destinationIcon = icon));
//     BitmapDescriptor.fromAssetImage(
//         ImageConfiguration.empty, 'assets/pmt_bus.png')
//         .then((icon) => setState(() => currentLocationIcon = icon));
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(
//         msg: "Enable location services",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }
//
//     LocationPermission perm = await Geolocator.checkPermission();
//     if (perm == LocationPermission.denied) {
//       perm = await Geolocator.requestPermission();
//       if (perm == LocationPermission.denied) {
//         Fluttertoast.showToast(
//           msg: "Location permission denied",
//           backgroundColor: Colors.red,
//         );
//         return;
//       }
//     }
//     if (perm == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//         msg: "Location permanently denied",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }
//
//     Position pos = await Geolocator.getCurrentPosition();
//     if (mounted) {
//       setState(() => _currentPosition = LatLng(pos.latitude, pos.longitude));
//       _mapController.animateCamera(
//           CameraUpdate.newLatLngZoom(_currentPosition, 15));
//     }
//   }
//
//   void _onSearch() async {
//     sourceLocation =
//     await _getCoordinatesFromAddress(sourceController.text.trim());
//     destination =
//     await _getCoordinatesFromAddress(destinationController.text.trim());
//     if (sourceLocation != null && destination != null) {
//       getPolyPoints();
//     }
//   }
//
//   void _clearRoute() {
//     setState(() {
//       polylines.clear();
//       polylineCoordinates.clear();
//       sourceLocation = destination = null;
//       sourceController.clear();
//       destinationController.clear();
//     });
//   }
//
//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double minLat = list.first.latitude, maxLat = list.first.latitude;
//     double minLng = list.first.longitude, maxLng = list.first.longitude;
//     for (var p in list) {
//       if (p.latitude < minLat) minLat = p.latitude;
//       if (p.latitude > maxLat) maxLat = p.latitude;
//       if (p.longitude < minLng) minLng = p.longitude;
//       if (p.longitude > maxLng) maxLng = p.longitude;
//     }
//     return LatLngBounds(
//         southwest: LatLng(minLat, minLng),
//         northeast: LatLng(maxLat, maxLng));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Google Map Route'),
//           backgroundColor: primaryColor,
//         ),
//         body: Stack(
//           children: [
//             currentLocation == null
//                 ? Center(child: CircularProgressIndicator())
//                 : GoogleMap(
//               initialCameraPosition:
//               CameraPosition(target: _currentPosition, zoom: 15),
//               polylines: polylines,
//               markers: {
//                 Marker(
//                     markerId: MarkerId('current'),
//                     position: LatLng(currentLocation!.latitude!,
//                         currentLocation!.longitude!),
//                     icon: currentLocationIcon),
//                 if (sourceLocation != null)
//                   Marker(
//                       markerId: MarkerId('source'),
//                       position: sourceLocation!,
//                       icon: sourceIcon),
//                 if (destination != null)
//                   Marker(
//                       markerId: MarkerId('dest'),
//                       position: destination!,
//                       icon: destinationIcon),
//               },
//               onMapCreated: (ctrl) {
//                 _mapController = ctrl;
//                 _controller.complete(ctrl);
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//             Positioned(
//                 top: 30,
//                 left: 15,
//                 right: 15,
//                 child: Column(
//                   children: [
//                     _buildTextField(sourceController, 'Enter source', Icons.location_on),
//                     SizedBox(height: 10),
//                     _buildTextField(destinationController, 'Enter destination', Icons.location_pin),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(onPressed: _onSearch, child: Text("Get Route")),
//                         ElevatedButton(
//                             onPressed: _clearRoute,
//                             child: Text("Clear"),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.redAccent, foregroundColor: Colors.white))
//                       ],
//                     )
//                   ],
//                 ))
//           ],
//         ));
//   }
//
//   Widget _buildTextField(
//       TextEditingController ctrl, String hint, IconData icon) =>
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
//           BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0,2))
//         ]),
//         child: TextField(
//           controller: ctrl,
//           decoration: InputDecoration(hintText: hint, border: InputBorder.none, icon: Icon(icon)),
//         ),
//       );
// }


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as loc;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// // Replace with your actual API key here or import from constants.dart
// const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
// const Color primaryColor = Color(0xFF7861FF);
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
//   LatLng? sourceLocation;
//   LatLng? destination;
//
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//
//   loc.Location location = loc.Location();
//   loc.LocationData? currentLocation;
//
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
//
//   final TextEditingController sourceController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     _getUserLocation();
//   }
//
//   void getCurrentLocation() async {
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
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   Future<LatLng?> _getCoordinatesFromAddress(String address) async {
//     try {
//       var locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         return LatLng(locations.first.latitude, locations.first.longitude);
//       } else {
//         Fluttertoast.showToast(
//           msg: "Location not found: $address",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//         return null;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error geocoding: $address - $e",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//       return null;
//     }
//   }
//
//   void getPolyPoints() async {
//     if (sourceLocation != null && destination != null) {
//       PolylinePoints polylinePoints = PolylinePoints();
//
//       final request = DirectionsRequest(
//         origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
//         destination: PointLatLng(destination!.latitude, destination!.longitude),
//         travelMode: TravelMode.driving,
//       );
//
//       final result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: google_api_key,
//         request: request,
//       );
//
//       if (result.points.isNotEmpty) {
//         polylineCoordinates.clear();
//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }
//         _createPolyline();
//
//         // Animate camera to fit polyline route
//         final GoogleMapController controller = await _controller.future;
//         LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
//         controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
//
//         setState(() {});
//       } else {
//         Fluttertoast.showToast(
//           msg: "Could not find a route between the specified locations.",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.orangeAccent,
//           textColor: Colors.white,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: "Please enter both source and destination.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.grey,
//         textColor: Colors.white,
//       );
//     }
//   }
//
//   void _createPolyline() {
//     polylines.clear();
//     polylines.add(
//       Polyline(
//         polylineId: PolylineId("route"),
//         points: polylineCoordinates,
//         color: primaryColor,
//         width: 6,
//       ),
//     );
//   }
//
//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_source.png")
//         .then((icon) => setState(() => sourceIcon = icon));
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_destination.png")
//         .then((icon) => setState(() => destinationIcon = icon));
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pmt_bus.png")
//         .then((icon) => setState(() => currentLocationIcon = icon));
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(
//         msg: "Please enable location services",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Fluttertoast.showToast(
//           msg: "Location permission denied",
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//         msg: "Location permissions are permanently denied",
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition();
//     if (mounted) {
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });
//
//       _mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(_currentPosition, 15),
//       );
//     }
//   }
//
//   void _onSearch() async {
//     sourceLocation = await _getCoordinatesFromAddress(sourceController.text.trim());
//     destination = await _getCoordinatesFromAddress(destinationController.text.trim());
//
//     if (sourceLocation != null && destination != null) {
//       getPolyPoints();
//     }
//   }
//
//   void _clearRoute() {
//     setState(() {
//       polylines.clear();
//       polylineCoordinates.clear();
//       sourceLocation = null;
//       destination = null;
//       sourceController.clear();
//       destinationController.clear();
//     });
//   }
//
//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double x0 = list[0].latitude;
//     double x1 = list[0].latitude;
//     double y0 = list[0].longitude;
//     double y1 = list[0].longitude;
//
//     for (LatLng latLng in list) {
//       if (latLng.latitude > x1) x1 = latLng.latitude;
//       if (latLng.latitude < x0) x0 = latLng.latitude;
//       if (latLng.longitude > y1) y1 = latLng.longitude;
//       if (latLng.longitude < y0) y0 = latLng.longitude;
//     }
//     return LatLngBounds(
//       northeast: LatLng(x1, y1),
//       southwest: LatLng(x0, y0),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Map Route'),
//         backgroundColor: primaryColor,
//       ),
//       body: Stack(
//         children: [
//           currentLocation == null
//               ? const Center(child: CircularProgressIndicator())
//               : GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//               zoom: 15,
//             ),
//             polylines: polylines,
//             markers: {
//               Marker(
//                 markerId: MarkerId("currentLocation"),
//                 icon: currentLocationIcon,
//                 position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//               ),
//               if (sourceLocation != null)
//                 Marker(
//                   markerId: MarkerId("source"),
//                   icon: sourceIcon,
//                   position: sourceLocation!,
//                 ),
//               if (destination != null)
//                 Marker(
//                   markerId: MarkerId("destination"),
//                   icon: destinationIcon,
//                   position: destination!,
//                 ),
//             },
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _controller.complete(controller);
//             },
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//           ),
//           Positioned(
//             top: 30,
//             left: 15,
//             right: 15,
//             child: Column(
//               children: [
//                 _buildTextField(sourceController, 'Enter source address', Icons.location_on),
//                 SizedBox(height: 10),
//                 _buildTextField(destinationController, 'Enter destination address', Icons.location_pin),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _onSearch,
//                       child: Text("Get Route"),
//                     ),
//                     ElevatedButton(
//                       onPressed: _clearRoute,
//                       child: Text("Clear Route"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           icon: Icon(icon),
//         ),
//       ),
//     );
//   }
//
//   DirectionsRequest({required PointLatLng origin, required PointLatLng destination, required TravelMode travelMode}) {}
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';

<<<<<<< Updated upstream
// Replace with your actual API key here or import from constants.dart
=======
>>>>>>> Stashed changes
const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
const Color primaryColor = Color(0xFF7861FF);

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  // late GoogleMapController _mapController;

  LatLng _currentPosition = LatLng(18.420652, 73.905094);
  LatLng? sourceLocation;
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  loc.Location location = loc.Location();
  loc.LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    getCurrentLocation();
    setCustomMarkerIcon();
    _getUserLocation();
  }

  void getCurrentLocation() async {
    currentLocation = await location.getLocation();

    final GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) async {
      currentLocation = newLoc;
      if (_controller.isCompleted) {
        final controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15,
              target: LatLng(newLoc.latitude!, newLoc.longitude!),
            ),
          ),
        );
      }
      if (mounted) {
        setState(() {});
      }
=======
    _checkPermissions();
    setCustomMarkerIcon();
    _listenToLocation();
  }

  Future<void> _checkPermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Fluttertoast.showToast(msg: "Enable location services", backgroundColor: Colors.red);
      return;
    }
    await Geolocator.requestPermission();
  }

  void _listenToLocation() async {
    _initCurrentLocation();
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      _mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(newLoc.latitude!, newLoc.longitude!),
      ));
      setState(() {});
>>>>>>> Stashed changes
    });
  }

  Future<void> _initCurrentLocation() async {
    currentLocation = await location.getLocation();
    _currentPosition = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newLatLngZoom(_currentPosition, 15));
    setState(() {});
  }

  Future<LatLng?> _getCoordinates(String address) async {
    try {
<<<<<<< Updated upstream
      var locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        Fluttertoast.showToast(
          msg: "Location not found: $address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error geocoding: $address - $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
=======
      var locs = await locationFromAddress(address);
      return LatLng(locs.first.latitude, locs.first.longitude);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error geocoding: $e", backgroundColor: Colors.redAccent);
>>>>>>> Stashed changes
      return null;
    }
  }

  void getPolyPoints() async {
<<<<<<< Updated upstream
    if (sourceLocation != null && destination != null) {
      final polylinePoints = PolylinePoints();

      final request = PolylineRequest(
        origin:
            PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        destination: PointLatLng(destination!.latitude, destination!.longitude),
        mode: TravelMode.driving,
      );

      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: google_api_key,
        request: request,
      );

      if (result.points.isNotEmpty) {
        // handle points here
      }

      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _createPolyline();

        // Animate camera to fit polyline route
        final GoogleMapController controller = await _controller.future;
        LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

        setState(() {});
      } else {
        Fluttertoast.showToast(
          msg: "Could not find a route between the specified locations.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          textColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please enter both source and destination.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
=======
    if (sourceLocation == null || destination == null) {
      Fluttertoast.showToast(msg: "Enter source and destination", backgroundColor: Colors.grey);
      return;
    }
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        destination: PointLatLng(destination!.latitude, destination!.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: google_api_key,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
      _createPolyline();
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(), 70));
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Route not found", backgroundColor: Colors.orangeAccent);
>>>>>>> Stashed changes
    }
  }

  void _createPolyline() {
    polylines = {
      Polyline(polylineId: PolylineId('route'), points: polylineCoordinates, color: primaryColor, width: 6)
    };
  }

  LatLngBounds _bounds() {
    var lats = polylineCoordinates.map((p) => p.latitude);
    var lngs = polylineCoordinates.map((p) => p.longitude);
    return LatLngBounds(
      southwest: LatLng(lats.reduce((a,b) => a < b ? a : b), lngs.reduce((a,b) => a < b ? a : b)),
      northeast: LatLng(lats.reduce((a,b) => a > b ? a : b), lngs.reduce((a,b) => a > b ? a : b)),
    );
  }

  void setCustomMarkerIcon() {
<<<<<<< Updated upstream
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pin_source.png")
        .then((icon) => setState(() => sourceIcon = icon));

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pin_destination.png")
        .then((icon) => setState(() => destinationIcon = icon));

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pmt_bus.png")
        .then((icon) => setState(() => currentLocationIcon = icon));
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
        msg: "Please enable location services",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
          msg: "Location permission denied",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "Location permissions are permanently denied",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Wait for the controller to be available
      if (_controller.isCompleted) {
        final controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition, 15),
        );
      }
    }
  }

  void _onSearch() async {
    sourceLocation =
        await _getCoordinatesFromAddress(sourceController.text.trim());
    destination =
        await _getCoordinatesFromAddress(destinationController.text.trim());

    if (sourceLocation != null && destination != null) {
      getPolyPoints();
    }
  }

  void _clearRoute() {
    setState(() {
      polylines.clear();
      polylineCoordinates.clear();
      sourceLocation = null;
      destination = null;
      sourceController.clear();
      destinationController.clear();
    });
=======
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pin_source.png')
        .then((i) => setState(() => sourceIcon = i));
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pin_destination.png')
        .then((i) => setState(() => destinationIcon = i));
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pmt_bus.png')
        .then((i) => setState(() => currentLocationIcon = i));
  }

  void _onSearch() async {
    sourceLocation = await _getCoordinates(sourceController.text.trim());
    destination = await _getCoordinates(destinationController.text.trim());
    getPolyPoints();
  }

  void _clearRoute() {
    polylineCoordinates.clear();
    polylines.clear();
    sourceController.clear();
    destinationController.clear();
    setState((){});
>>>>>>> Stashed changes
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double x0 = list[0].latitude;
    double x1 = list[0].latitude;
    double y0 = list[0].longitude;
    double y1 = list[0].longitude;

    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(x1, y1),
      southwest: LatLng(x0, y0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Route'),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          currentLocation == null
<<<<<<< Updated upstream
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 15,
                  ),
                  polylines: polylines,
                  markers: {
                    Marker(
                      markerId: MarkerId("currentLocation"),
                      icon: currentLocationIcon,
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                    ),
                    if (sourceLocation != null)
                      Marker(
                        markerId: MarkerId("source"),
                        icon: sourceIcon,
                        position: sourceLocation!,
                      ),
                    if (destination != null)
                      Marker(
                        markerId: MarkerId("destination"),
                        icon: destinationIcon,
                        position: destination!,
                      ),
                  },
                  onMapCreated: (controller) {
                    // _mapController = controller;
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
=======
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 15),
            polylines: polylines,
            markers: {
              if (currentLocation != null)
                Marker(markerId: MarkerId('current'), position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), icon: currentLocationIcon),
              if (sourceLocation != null)
                Marker(markerId: MarkerId('source'), position: sourceLocation!, icon: sourceIcon),
              if (destination != null)
                Marker(markerId: MarkerId('dest'), position: destination!, icon: destinationIcon),
            },
            onMapCreated: (c) { _mapController = c; _controller.complete(c); },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
>>>>>>> Stashed changes
          Positioned(
            top: 30, left: 15, right: 15,
            child: Column(
              children: [
<<<<<<< Updated upstream
                _buildTextField(sourceController, 'Enter source address',
                    Icons.location_on),
                SizedBox(height: 10),
                _buildTextField(destinationController,
                    'Enter destination address', Icons.location_pin),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _onSearch,
                      child: Text("Get Route"),
                    ),
                    ElevatedButton(
                      onPressed: _clearRoute,
                      child: Text("Clear Route"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
=======
                _tf(sourceController, 'Source', Icons.location_on),
                SizedBox(height: 8),
                _tf(destinationController, 'Destination', Icons.location_pin),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: _onSearch, child: Text('Route')),
                    ElevatedButton(onPressed: _clearRoute, child: Text('Clear'), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent)),
>>>>>>> Stashed changes
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< Updated upstream
  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon) {
    return Container(
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(icon),
        ),
      ),
    );
  }
=======
  Widget _tf(TextEditingController ctrl, String hint, IconData ic) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
    child: TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, icon: Icon(ic), border: InputBorder.none)),
  );
>>>>>>> Stashed changes
}
