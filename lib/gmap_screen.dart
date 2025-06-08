// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo"; // Your API Key here
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
//   LatLng _defaultPosition = LatLng(18.5204, 73.8567); // Pune center
//   LatLng? sourceLocation;
//   LatLng? destination;
//
//   loc.Location location = loc.Location();
//   loc.LocationData? currentLocation;
//
//   late BitmapDescriptor sourceIcon;
//   late BitmapDescriptor destinationIcon;
//
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//   Set<Marker> markers = {};
//
//   final sourceController = TextEditingController(text: "Katraj");
//   final destinationController = TextEditingController(text: "Saswad");
//
//   bool _isMapReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocationAndIcons();
//   }
//
//   Future<void> _initLocationAndIcons() async {
//     await _checkPermissions();
//     await _setCustomIcons();
//     _listenToLocation();
//   }
//
//   Future<void> _checkPermissions() async {
//     if (!await location.serviceEnabled()) {
//       if (!await location.requestService()) return;
//     }
//     if (await location.hasPermission() == loc.PermissionStatus.denied) {
//       await location.requestPermission();
//     }
//   }
//
//   void _listenToLocation() async {
//     currentLocation = await location.getLocation();
//     setState(() {});
//   }
//
//   Future<void> _setCustomIcons() async {
//     sourceIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//     destinationIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
//   }
//
//   Future<LatLng?> _getCoordinates(String inputAddress) async {
//     final address = "${inputAddress.trim()}, Pune, India";
//     try {
//       final list = await locationFromAddress(address);
//       if (list.isNotEmpty) {
//         final loc0 = list.first;
//         return LatLng(loc0.latitude, loc0.longitude);
//       }
//
//       // fallback to HTTP geocode API
//       final url = Uri.parse(
//           'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$google_api_key');
//       final response = await http.get(url);
//       final json = jsonDecode(response.body);
//       if (json['status'] == 'OK') {
//         final coords = json['results'][0]['geometry']['location'];
//         return LatLng(coords['lat'], coords['lng']);
//       }
//
//       Fluttertoast.showToast(
//           msg: "Could not geo-locate \"$inputAddress\"",
//           backgroundColor: Colors.red);
//       return null;
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Error finding \"$inputAddress\"",
//           backgroundColor: Colors.red);
//       return null;
//     }
//   }
//
//   void _onSearch() async {
//     if (!_isMapReady) {
//       Fluttertoast.showToast(
//           msg: "Map not ready yet", backgroundColor: Colors.orange);
//       return;
//     }
//
//     final src = await _getCoordinates(sourceController.text);
//     final dest = await _getCoordinates(destinationController.text);
//
//     if (src != null && dest != null) {
//       setState(() {
//         sourceLocation = src;
//         destination = dest;
//
//         markers.clear();
//         polylines.clear();
//
//         markers.add(Marker(
//             markerId: MarkerId("source"),
//             position: sourceLocation!,
//             icon: sourceIcon,
//             infoWindow: InfoWindow(title: "Source")));
//         markers.add(Marker(
//             markerId: MarkerId("destination"),
//             position: destination!,
//             icon: destinationIcon,
//             infoWindow: InfoWindow(title: "Destination")));
//       });
//
//       await _getPolyline();
//     } else {
//       Fluttertoast.showToast(
//           msg: "Could not find coordinates for source or destination",
//           backgroundColor: Colors.red);
//     }
//   }
//
//   Future<void> _getPolyline() async {
//     if (!_isMapReady || sourceLocation == null || destination == null) {
//       Fluttertoast.showToast(
//           msg: "Map or locations not ready", backgroundColor: Colors.orange);
//       return;
//     }
//
//     // Correct method call as per flutter_polyline_points 2.1.0
//     final PolylinePoints polylinePoints = PolylinePoints();
//
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       request: PolylineRequest(
//         origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
//         destination: PointLatLng(destination!.latitude, destination!.longitude),
//         mode: TravelMode.driving,
//       ),
//       googleApiKey: google_api_key,
//     );
//
//     if (result.points.isNotEmpty) {
//       polylineCoordinates.clear();
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//
//       final routePolyline = Polyline(
//         polylineId: PolylineId("route"),
//         color: Colors.blue.withOpacity(1.0), // Blue line for route highlight
//         width: 6,
//         points: polylineCoordinates,
//         jointType: JointType.round,
//         startCap: Cap.roundCap,
//         endCap: Cap.roundCap,
//       );
//
//       setState(() {
//         polylines.clear();
//         polylines.add(routePolyline);
//       });
//
//       try {
//         final bounds = _boundsFromLatLngList(polylineCoordinates);
//         _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
//       } catch (e) {
//         // If bounds calculation fails, fallback zoom to source
//         _mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: sourceLocation!, zoom: 12),
//           ),
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//           msg: "Route not found", backgroundColor: Colors.orange);
//     }
//   }
//
//   LatLngBounds _boundsFromLatLngList(List<LatLng> points) {
//     double minLat = points.first.latitude, maxLat = points.first.latitude;
//     double minLng = points.first.longitude, maxLng = points.first.longitude;
//
//     for (var p in points) {
//       if (p.latitude < minLat) minLat = p.latitude;
//       if (p.latitude > maxLat) maxLat = p.latitude;
//       if (p.longitude < minLng) minLng = p.longitude;
//       if (p.longitude > maxLng) maxLng = p.longitude;
//     }
//
//     return LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//   }
//
//   void _clearRoute() {
//     sourceController.clear();
//     destinationController.clear();
//     setState(() {
//       polylines.clear();
//       markers.clear();
//       sourceLocation = null;
//       destination = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//       AppBar(title: Text("Google Map Route"), backgroundColor: primaryColor),
//       body: Stack(children: [
//         GoogleMap(
//           initialCameraPosition:
//           CameraPosition(target: _defaultPosition, zoom: 12),
//           polylines: polylines,
//           markers: markers,
//           onMapCreated: (controller) {
//             _mapController = controller;
//             _controller.complete(controller);
//             setState(() {
//               _isMapReady = true;
//             });
//           },
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//         ),
//         Positioned(
//           top: 20,
//           left: 15,
//           right: 15,
//           child: Column(children: [
//             _buildTextField(sourceController, "Source"),
//             SizedBox(height: 10),
//             _buildTextField(destinationController, "Destination"),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _isMapReady ? _onSearch : null,
//                   child: Text("Get Route"),
//                 ),
//                 ElevatedButton(
//                   onPressed: _clearRoute,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   child: Text("Clear"),
//                 ),
//               ],
//             ),
//           ]),
//         )
//       ]),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController ctl, String hint) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
//       ),
//       child: TextField(
//         controller: ctl,
//         decoration: InputDecoration(
//           icon: Icon(Icons.location_on),
//           hintText: hint,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
//

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
const Color primaryColor = Color(0xFF7861FF);

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

  LatLng _defaultPosition = LatLng(18.5204, 73.8567);
  LatLng? sourceLocation;
  LatLng? destination;

  loc.Location location = loc.Location();
  loc.LocationData? currentLocation;

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor busIcon;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Marker? movingBusMarker;
  int _busMarkerIndex = 0;
  Timer? _busMovementTimer;

  final sourceController = TextEditingController(text: "Katraj");
  final destinationController = TextEditingController(text: "Saswad");

  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _initLocationAndIcons();
  }

  Future<void> _initLocationAndIcons() async {
    await _checkPermissions();
    await _setCustomIcons();
    _listenToLocation();
  }

  Future<void> _checkPermissions() async {
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) return;
    }
    if (await location.hasPermission() == loc.PermissionStatus.denied) {
      await location.requestPermission();
    }
  }

  void _listenToLocation() async {
    currentLocation = await location.getLocation();
    setState(() {});
  }

  Future<void> _setCustomIcons() async {
    sourceIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    destinationIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    busIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), "assets/bus.png"); // You must add a bus icon in assets
  }

  Future<LatLng?> _getCoordinates(String inputAddress) async {
    final address = "${inputAddress.trim()}, Pune, India";
    try {
      final list = await locationFromAddress(address);
      if (list.isNotEmpty) {
        final loc0 = list.first;
        return LatLng(loc0.latitude, loc0.longitude);
      }

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$google_api_key');
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final coords = json['results'][0]['geometry']['location'];
        return LatLng(coords['lat'], coords['lng']);
      }

      Fluttertoast.showToast(msg: "Could not geo-locate \"$inputAddress\"", backgroundColor: Colors.red);
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error finding \"$inputAddress\"", backgroundColor: Colors.red);
      return null;
    }
  }

  void _onSearch() async {
    if (!_isMapReady) return;

    final src = await _getCoordinates(sourceController.text);
    final dest = await _getCoordinates(destinationController.text);

    if (src != null && dest != null) {
      setState(() {
        sourceLocation = src;
        destination = dest;
        markers.clear();
        polylines.clear();
        _busMarkerIndex = 0;
        _busMovementTimer?.cancel();
      });

      markers.add(Marker(markerId: MarkerId("source"), position: src, icon: sourceIcon));
      markers.add(Marker(markerId: MarkerId("destination"), position: dest, icon: destinationIcon));

      await _getPolyline();
    } else {
      Fluttertoast.showToast(msg: "Invalid locations", backgroundColor: Colors.red);
    }
  }

  Future<void> _getPolyline() async {
    if (sourceLocation == null || destination == null) return;

    final polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        destination: PointLatLng(destination!.latitude, destination!.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: google_api_key,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((p) {
        polylineCoordinates.add(LatLng(p.latitude, p.longitude));
      });

      setState(() {
        polylines.add(Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          width: 6,
          points: polylineCoordinates,
        ));
      });

      final bounds = _boundsFromLatLngList(polylineCoordinates);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

      _startBusMovement();
    } else {
      Fluttertoast.showToast(msg: "Route not found", backgroundColor: Colors.orange);
    }
  }

  void _startBusMovement() {
    _busMovementTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_busMarkerIndex < polylineCoordinates.length) {
        final position = polylineCoordinates[_busMarkerIndex];
        final marker = Marker(
          markerId: MarkerId("bus"),
          position: position,
          icon: busIcon,
          infoWindow: InfoWindow(title: "Bus"),
        );

        setState(() {
          markers.removeWhere((m) => m.markerId.value == "bus");
          markers.add(marker);
        });

        _busMarkerIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> points) {
    double minLat = points.first.latitude, maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _clearRoute() {
    sourceController.clear();
    destinationController.clear();
    setState(() {
      polylines.clear();
      markers.clear();
      sourceLocation = null;
      destination = null;
      polylineCoordinates.clear();
      _busMarkerIndex = 0;
    });
    _busMovementTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map "), backgroundColor: Colors.teal),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _defaultPosition, zoom: 12),
          polylines: polylines,
          markers: markers,
          onMapCreated: (controller) {
            _mapController = controller;
            _controller.complete(controller);
            setState(() => _isMapReady = true);
          },
          myLocationEnabled: true,
        ),
        Positioned(
          top: 20,
          left: 15,
          right: 15,
          child: Column(children: [
            _buildTextField(sourceController, "Source"),
            SizedBox(height: 10),
            _buildTextField(destinationController, "Destination"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _onSearch, child: Text("Get Route")),
                ElevatedButton(onPressed: _clearRoute, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text("Clear")),
              ],
            ),
          ]),
        )
      ]),
    );
  }

  Widget _buildTextField(TextEditingController ctl, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: TextField(
        controller: ctl,
        decoration: InputDecoration(
          icon: Icon(Icons.location_on),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
