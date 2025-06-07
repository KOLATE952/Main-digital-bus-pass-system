import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';


// Replace with your actual API key here or import from constants.dart
const String google_api_key = "AIzaSyCuJ95Ynset11JahQ96woXW5EM7S-d3BTo";
const Color primaryColor = Color(0xFF7861FF);

class GMapPage extends StatefulWidget {
  @override
  _GMapPageState createState() => _GMapPageState();
}

class _GMapPageState extends State<GMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

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
    getCurrentLocation();
    setCustomMarkerIcon();
    _getUserLocation();
  }

  void getCurrentLocation() async {
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
      final polylinePoints = PolylinePoints();

      final request = DirectionsRequest(
        origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        destination: PointLatLng(destination!.latitude, destination!.longitude),
        travelMode: TravelMode.driving,
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
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_source.png")
        .then((icon) => setState(() => sourceIcon = icon));

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_destination.png")
        .then((icon) => setState(() => destinationIcon = icon));

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pmt_bus.png")
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
      sourceLocation = null;
      destination = null;
      sourceController.clear();
      destinationController.clear();
    });
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
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 15,
            ),
            polylines: polylines,
            markers: {
              Marker(
                markerId: MarkerId("currentLocation"),
                icon: currentLocationIcon,
                position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
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
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Column(
              children: [
                _buildTextField(sourceController, 'Enter source address', Icons.location_on),
                SizedBox(height: 10),
                _buildTextField(destinationController, 'Enter destination address', Icons.location_pin),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
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
}
