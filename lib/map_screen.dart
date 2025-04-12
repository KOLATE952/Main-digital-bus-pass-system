import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  // Updated start and end locations
  static const LatLng _startLocation = LatLng(18.420652, 73.905094);
  static const LatLng _endLocation = LatLng(18.5104, 73.9239);

  // Markers list
  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('start'),
      position: _startLocation,
      infoWindow: InfoWindow(title: "Start Bus Stop"),
    ),
    Marker(
      markerId: MarkerId('end'),
      position: _endLocation,
      infoWindow: InfoWindow(title: "End Bus Stop (Hadapsar, Pune)"),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Bus Route Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startLocation,
          zoom: 12,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
