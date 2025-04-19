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

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDesriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDesriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDesriptor.defaultMarker;

  void getCurrentLocation (){
    Location location = Location();


    location.getLocation().then((location) {
      currentLocation = location;
    },
    );
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 15,
              target: LatLng(newLoc.latitude!, newLoc.longitude!,))))
      setState(() {});
    };

        void getPolyPoints() async {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = polylinePoints.getRouteBetweenCoordinates(google_api_key,
          PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
          PointLatLng(destination.latitude, destination.longitude)
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
        ),
    };
    setState((){} );

    };
    void setCustoMarkerIcon(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_source.png")then((icon) {
    sourceIcon = icon;
    },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_destination.png")then((icon) {
    destinationIconIcon = icon;
    },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin_Badge.png")then((icon) {
    currentLocationIcon = icon;
    },
    );
    }
    @override
    void initState() {
    getCurrentLocation();
    setCustoMarkerIcon();
    getPolyPoints();
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
    appBar: AppBar(title: Text('Live Location Map',
    style:TextStyle(color: Colors.black, fontsize: 16),
    ),
    ),
    body: currentLocation == null
    ? const Centre(child: Text("Loading"))
        : GoogleMap(
    initialCameraPosition: CameraPosition(
    target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
    zoom: 15,
    ),
    polylines: {
    Polyline(polylineId: PolylineId("route"),
    points: polylineCoordinates,
    color: primaryColor,
    width: 6,
    ),
    };
    markers: {
    const marker(
    markerId: MarkerId("currentLocation"),
    icon: currentLocationIcon,
    position: LatLang(currentLocation!.latitude!, currentLocation.longitude!),
    ),
    const marker(
    markerId: MarkerId("source"),
    icon: sourceIcon,
    position: sourceLocation,
    ),
    const marker(
    markerId: MarkerId("destination"),
    icon: destinationIcon,
    position: destination,
    ),
    },
    onMapCreated: (mapcontroller) {
    _controller.complete(mapController);
    _getUserLocation(); // Get user location when map loads
    },
    myLocationEnabled: true, // Shows blue dot for current location
    myLocationButtonEnabled: true, // Adds a button to find location
    ),
    );
    }
  }