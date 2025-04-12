import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(18.420652, 73.905094); // Default: Pune

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Function to get live location
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Location services are disabled.");
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ Location permissions permanently denied.");
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the map with the new location
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Move the camera to the current location
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Location Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
          _getUserLocation(); // Get user location when map loads
        },
        myLocationEnabled: true, // Shows blue dot for current location
        myLocationButtonEnabled: true, // Adds a button to find location
      ),
    );
  }
}
