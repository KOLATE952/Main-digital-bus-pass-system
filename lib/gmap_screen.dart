import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';// Import geocoding
import 'constants.dart'; // Assuming your google_api_key is in constants.dart
import 'package:fluttertoast/fluttertoast.dart'; // For showing error messages

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

  LatLng _currentPosition = LatLng(18.420652, 73.905094);
  LatLng? sourceLocation; // Make these nullable
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {}; // To hold the displayed route
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  get location => null;

  void getCurrentLocation() async {
    var locationInstance = location();
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
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
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
      return null;
    }
  }

  void getPolyPoints() async {
    if (sourceLocation != null && destination != null) {
      PolylinePoints polylinePoints = PolylinePoints(apiKey: google_api_key);
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
          destination: PointLatLng(destination!.latitude, destination!.longitude),
          transitMode: TravelMode.driving.name, mode: TravelMode.driving, // Accessing the name property of the enum
        )@
      );

      // ... rest of your getPolyPoints(

      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _createPolyline();
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
    }
  }

  void _createPolyline() {
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: primaryColor,
        width: 6,
      ),
    );
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

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    }
  }

  void _onSearch() async {
    sourceLocation = await _getCoordinatesFromAddress(sourceController.text.trim());
    destination = await _getCoordinatesFromAddress(destinationController.text.trim());

    if (sourceLocation != null && destination != null) {
      getPolyPoints();
    }
  }

  void _clearRoute() {
    setState(() {
      polylines.clear();
      polylineCoordinates.clear();
    });
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
                      hintText: 'Enter source address',
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
                      hintText: 'Enter destination address',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}