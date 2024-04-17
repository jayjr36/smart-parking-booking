import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              //
            }),
        title: const Text("Smart Parking"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: const Icon(Icons.minimize_rounded, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: const Icon(Icons.add_a_photo_rounded, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: const LatLng(-6.814594032429642, 39.27999040811724),
        zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: const LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1562426509-5044a121aa49?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.825588173357321,
                  39.273032979282505,
                  "Gerezani"),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1526626607369-f89fe1ed77a9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.784741726616766,
                  39.218767750446965,
                  "Ubungo"),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNhciUyMHBhcmtpbmd8ZW58MHx8MHx8fDA%3D",
                  -6.814532286980702,
                  39.28799772774392,
                  "Posta"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1543465077-db45d34b88a5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.821214476703329,
                  39.28051110811758,
                  "Mnazi"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1578859695220-856a4f5edd39?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.766000346201719,
                  39.23002729462172,
                  "Mwenge"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://media.istockphoto.com/id/1490441258/photo/lot-of-used-car-for-sales-in-stock-with-sky-and-clouds.webp?b=1&s=170667a&w=0&k=20&c=fV6omVeLkajMGVbij1KBoFgAJSyUlqbFExIxh4i_0-4=",
                  -6.85551794396956,
                  39.27255129706642,
                  "Uhuru"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: const Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: myDetailsContainer1(restaurantName),
                ),
              ],
            )),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            restaurantName,
            style: const TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5.0),
        const Text(
          "24 hours parking service",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-6.814594032429642, 39.27999040811724), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          mnaziMarker,
          mwengeMarker,
          uhuruMarker,
          gerezaniMarker,
          ubungoMarker,
          postaMarker
        },
      ),
    );
  }


Future<void> _gotoLocation(double lat, double long) async {
  final GoogleMapController controller = await _controller.future;

  // Starting position
  double userLat = -6.814594032429642;
  double userLong = 39.27999040811724;

  // Fetch route information from Google Directions API
  final String apiUrl =
      "https://maps.googleapis.com/maps/api/directions/json?origin=$userLat,$userLong&destination=$lat,$long&key=YOUR_API_KEY";
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    List<LatLng> points = _decodePoly(decoded["routes"][0]["overview_polyline"]["points"]);

    // Create a list of LatLng objects from the decoded polyline
    List<LatLng> routeCoordinates = List<LatLng>.from(points);

    // Add user's current location to the beginning of route coordinates
    routeCoordinates.insert(0, LatLng(userLat, userLong));

    // Draw the route on the map
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(userLat, userLong),
          northeast: LatLng(lat, long),
        ),
        100,
      ),
    );

    controller.addPolyline(Polyline(
      polylineId: PolylineId('route'),
      points: routeCoordinates,
      color: Colors.blue,
      width: 4,
    ));
  } else {
    throw Exception('Failed to load route');
  }
}

// Function to decode Google Polyline
List<LatLng> _decodePoly(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    double latlng = lat / 1E5;
    double lnglng = lng / 1E5;

    LatLng position = LatLng(latlng, lnglng);
    poly.add(position);
  }

  return poly;
}

  //Future<void> _gotoLocation(double lat, double long) async {
   // final GoogleMapController controller = await _controller.future;
   // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
   //   target: LatLng(lat, long),
    //  zoom: 15,
     // tilt: 50.0,
    //  bearing: 45.0,
  //  )));
  //}
}

Marker gerezaniMarker = Marker(
  markerId: const MarkerId('Gerezani'),
  position: const LatLng(-6.825588173357321, 39.273032979282505),
  infoWindow: const InfoWindow(title: 'Gerezani'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker ubungoMarker = Marker(
  markerId: const MarkerId('Ubungo'),
  position: const LatLng(-6.784741726616766, 39.218767750446965),
  infoWindow: const InfoWindow(title: 'Ubungo'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker postaMarker = Marker(
  markerId: const MarkerId('Posta'),
  position: const LatLng(-6.814532286980702, 39.28799772774392),
  infoWindow: const InfoWindow(title: 'Posta'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker mnaziMarker = Marker(
  markerId: const MarkerId('mnazi'),
  position: const LatLng(-6.821214476703329, 39.28051110811758),
  infoWindow: const InfoWindow(title: 'Mnazi mmoja'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker mwengeMarker = Marker(
  markerId: const MarkerId('mwenge'),
  position: const LatLng(-6.766000346201719, 39.23002729462172),
  infoWindow: const InfoWindow(title: 'Mwenge'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker uhuruMarker = Marker(
  markerId: const MarkerId('uhuru'),
  position: const LatLng(-6.85551794396956, 39.27255129706642),
  infoWindow: const InfoWindow(title: 'Uhuru'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
