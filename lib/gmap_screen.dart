import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

  final LatLng _defaultPosition = LatLng(18.5204, 73.8567); // Pune default
  LatLng _currentPosition = LatLng(18.5204, 73.8567);
  LatLng? sourceLocation;
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

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
    setCustomMarkerIcon();
    _getUserLocation();
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
      var locations = await locationFromAddress(address);
      return LatLng(locations.first.latitude, locations.first.longitude);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error finding location: $address",
        backgroundColor: Colors.redAccent,
      );
      return null;
    }
  }

  void getPolyPoints() async {
    if (sourceLocation != null && destination != null) {
      await Future.delayed(Duration(milliseconds: 200));
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: google_api_key,
        request: PolylineRequest(
          origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
          destination: PointLatLng(destination!.latitude, destination!.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates = result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
        _createPolyline();
        _placeBusMarker();
        _moveCameraToFitBounds();
      } else {
        Fluttertoast.showToast(msg: "No route found.");
      }
    }
  }

  void _createPolyline() {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: primaryColor,
        width: 6,
      ),
    );
    setState(() {});
  }

  void _placeBusMarker() {
    if (polylineCoordinates.isNotEmpty) {
      LatLng busPos = polylineCoordinates[polylineCoordinates.length ~/ 2];
      markers.add(
        Marker(
          markerId: MarkerId("bus"),
          position: busPos,
          icon: currentLocationIcon,
          infoWindow: InfoWindow(title: "Bus Location"),
        ),
      );
    }
    setState(() {});
  }

  void _moveCameraToFitBounds() async {
    if (sourceLocation != null && destination != null) {
      LatLngBounds bounds;
      if (sourceLocation!.latitude > destination!.latitude) {
        bounds = LatLngBounds(southwest: destination!, northeast: sourceLocation!);
      } else {
        bounds = LatLngBounds(southwest: sourceLocation!, northeast: destination!);
      }
      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_source.png")
        .then((icon) => sourceIcon = icon);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_destination.png")
        .then((icon) => destinationIcon = icon);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pmt_bus.png")
        .then((icon) => currentLocationIcon = icon);
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onSearch() async {
    markers.clear();
    sourceLocation = await _getCoordinatesFromAddress(sourceController.text.trim());
    destination = await _getCoordinatesFromAddress(destinationController.text.trim());

    if (sourceLocation != null && destination != null) {
      markers.add(Marker(markerId: MarkerId("source"), position: sourceLocation!, icon: sourceIcon));
      markers.add(Marker(markerId: MarkerId("destination"), position: destination!, icon: destinationIcon));
      getPolyPoints();
    }
  }

  void _clearRoute() {
    setState(() {
      polylines.clear();
      markers.clear();
      polylineCoordinates.clear();
      sourceLocation = null;
      destination = null;
      sourceController.clear();
      destinationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map Route'), backgroundColor: primaryColor),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14),
            polylines: polylines,
            markers: markers,
            onMapCreated: (controller) {
              _mapController = controller;
              _controller.complete(controller);

              // Delay camera animation to avoid channel error
              Future.delayed(Duration(milliseconds: 1000), () {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _currentPosition,
                      zoom: 14,
                    ),
                  ),
                );
              });
            },


            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Column(
              children: [
                _buildTextField(sourceController, 'Enter source', Icons.location_on),
                SizedBox(height: 10),
                _buildTextField(destinationController, 'Enter destination', Icons.location_pin),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: _onSearch, child: Text("Get Route")),
                    ElevatedButton(
                      onPressed: _clearRoute,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child: Text("Clear Route"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, icon: Icon(icon)),
      ),
    );
  }
}
