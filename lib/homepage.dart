import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermaps/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> routeCoordinates = [];
   final FirebaseAuth _auth = FirebaseAuth.instance;
 void _signOut() async {
    await _auth.signOut();
  }
  int postaslots = 20;
  int mwengeslots = 25;
  int ubungoslots = 15;
  int mnazislots = 20;
  int gerezanislots = 22;
  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Smart Parking Reservation",
          style: TextStyle(color: Colors.white),
        ),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const AuthenticationWrapper()),
                (Route<dynamic> route) => false,
              );
            },
          ),
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
                  "Gerezani",
                  gerezanislots),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1526626607369-f89fe1ed77a9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.784741726616766,
                  39.218767750446965,
                  "Ubungo",
                  ubungoslots),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNhciUyMHBhcmtpbmd8ZW58MHx8MHx8fDA%3D",
                  -6.814532286980702,
                  39.28799772774392,
                  "Posta",
                  postaslots),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1543465077-db45d34b88a5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.821214476703329,
                  39.28051110811758,
                  "Mnazi",
                  mnazislots),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1578859695220-856a4f5edd39?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.766000346201719,
                  39.23002729462172,
                  "Mwenge",
                  mwengeslots),
            ),
            //Padding(
            //  padding: const EdgeInsets.all(8.0),
            //  child: _boxes(
            //    "https://media.istockphoto.com/id/1490441258/photo/lot-of-used-car-for-sales-in-stock-with-sky-and-clouds.webp?b=1&s=170667a&w=0&k=20&c=fV6omVeLkajMGVbij1KBoFgAJSyUlqbFExIxh4i_0-4=",
            //    -6.85551794396956,
            //     39.27255129706642,
            //     "Uhuru",
            //     uhuruslots),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String image, double lat, double long, String restaurantName,
      int parkingslots) {
    return GestureDetector(
      onTap: () {
        showpopup(restaurantName, parkingslots, (int newSlots) {
          setState(() {
            parkingslots = newSlots;
          });
        });
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
                  child: myDetailsContainer1(restaurantName, parkingslots),
                ),
              ],
            )),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName, int parkingslots) {
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
        Text("Parking slots available: $parkingslots")
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-6.814594032429642, 39.27999040811724), zoom: 20),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapBounds(controller);
        },
        markers: {
          mnaziMarker,
          mwengeMarker,
          uhuruMarker,
          gerezaniMarker,
          ubungoMarker,
          postaMarker
        },
        polygons: {
          createRectangle(mnaziMarker.position, 'mnaziPolygon'),
          createRectangle(mwengeMarker.position, 'mwengePolygon'),
          createRectangle(uhuruMarker.position, 'uhuruPolygon'),
          createRectangle(gerezaniMarker.position, 'gerezaniPolygon'),
          createRectangle(ubungoMarker.position, 'ubungoPolygon'),
          createRectangle(postaMarker.position, 'postaPolygon'),
        },
        polylines: Set<Polyline>.of(_polylines.values),
      ),
    );
  }

  Future<void> _setMapBounds(GoogleMapController controller) async {
    // Define the bounds for Dar es Salaam
    LatLngBounds darEsSalaamBounds = LatLngBounds(
      southwest: const LatLng(-6.852783886932728, 39.35222429150831),
      northeast: const LatLng(-6.676862766362094, 39.09112732792641),
    );

    // Update the map to fit within these bounds
    await controller
        .animateCamera(CameraUpdate.newLatLngBounds(darEsSalaamBounds, 50));
  }

  Polygon createRectangle(LatLng center, String id) {
    const double offset = 0.001;
    return Polygon(
      polygonId: PolygonId(id),
      points: [
        LatLng(center.latitude + offset, center.longitude + offset),
        LatLng(center.latitude + offset, center.longitude - offset),
        LatLng(center.latitude - offset, center.longitude - offset),
        LatLng(center.latitude - offset, center.longitude + offset),
      ],
      strokeWidth: 2,
      fillColor: const Color.fromARGB(255, 253, 115, 3).withOpacity(0.5),
      strokeColor: const Color.fromARGB(255, 82, 55, 5),
    );
  }

  final Map<PolylineId, Polyline> _polylines = {};

  void _showRoute(List<LatLng> routeCoordinates) {
    const PolylineId polylineId = PolylineId('route');
    final Polyline routePolyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      points: routeCoordinates,
      width: 5,
    );

    setState(() {
      _polylines[polylineId] = routePolyline;
    });
  }

  void showpopup(
      String restaurantName, int parkingSlots, Function(int) updateSlots) {
    if (restaurantName == 'Gerezani') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.814950909123785, 39.281540726702424),
        const LatLng(-6.816053496710698, 39.28037933018597),
        const LatLng(-6.817105480076892, 39.280095016063356),
        const LatLng(-6.820828683652697, 39.28127518803471),
        const LatLng(-6.82424292647016, 39.28137174747198),
        const LatLng(-6.82609651451612, 39.278764640475494),
        const LatLng(-6.8274707217182025, 39.27611461805896),
        const LatLng(-6.825169721398683, 39.274365817892594),
        const LatLng(-6.8252655966328355, 39.27403322399593),
        // const LatLng(),
        // LatLng(lat, long),
      ];
    } else if (restaurantName == 'Mwenge') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.810180990339358, 39.2866503345708),
        const LatLng(-6.803362933342494, 39.286028062327986),
        const LatLng(-6.796906996463267, 39.28160778200808),
        const LatLng(-6.781075735062877, 39.27431217381138),
        const LatLng(-6.7782418203349115, 39.269870435569345),
        const LatLng(-6.778327051087862, 39.252768671313945),
        const LatLng(-6.775471812485749, 39.24367061831496),
        const LatLng(-6.763816297485713, 39.22873607840942),
        const LatLng(-6.7665437557411705, 39.23186889828605),
        const LatLng(-6.766000346201719, 39.23002729462172),
        // const LatLng(),
        // LatLng(lat, long),
      ];
    } else if (restaurantName == 'Posta') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.811736345830938, 39.28516975590098),
        const LatLng(-6.8146978994614305, 39.28776613406208),
        const LatLng(-6.814532286980702, 39.28799772774392),
      ];
    } else if (restaurantName == 'Ubungo') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.810180990339358, 39.2866503345708),
        const LatLng(-6.803362933342494, 39.286028062327986),
        const LatLng(-6.796906996463267, 39.28160778200808),
        const LatLng(-6.781075735062877, 39.27431217381138),
        const LatLng(-6.7782418203349115, 39.269870435569345),
        const LatLng(-6.778327051087862, 39.252768671313945),
        const LatLng(-6.775471812485749, 39.24367061831496),
        const LatLng(-6.763816297485713, 39.22873607840942),
        const LatLng(-6.764221155754598, 39.229251062517044),
        const LatLng(-6.779392434250391, 39.216719782797334),
        const LatLng(-6.788682475920738, 39.20890919026892),
        const LatLng(-6.792262077133359, 39.208265460146336),
        const LatLng(-6.792922596101161, 39.21064726078291),
        const LatLng(-6.784741726616766, 39.218767750446965),
      ];
    } else if (restaurantName == 'Mnazi') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.814950909123785, 39.281540726702424),
        const LatLng(-6.816053496710698, 39.28037933018597),
        const LatLng(-6.817105480076892, 39.280095016063356),
        const LatLng(-6.820828683652697, 39.28127518803471),
      ];
    } else {
      const Center(
        child: Text("No route Defined"),
      );
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(restaurantName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Parking Slots: $parkingSlots'),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Book Parking

                        setState(() {
                          parkingSlots--;
                        });
                        updateSlots(parkingSlots);
                        Fluttertoast.showToast(
                            msg: "Parking slot reserved",
                            backgroundColor: Colors.green,
                            fontSize: 18);
                      },
                      child: const Text('Book Parking'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Show Route
                        _showRoute(routeCoordinates);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Show Route'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          parkingSlots++;
                        });
                        updateSlots(parkingSlots);
                        Fluttertoast.showToast(
                            msg: "Thank you for using our service",
                            backgroundColor: Colors.yellow,
                            fontSize: 18);
                      },
                      child: const Text('Clear Parking'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"))
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
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
  //Future<void> _gotoLocation(double lat, double long) async {
  // final GoogleMapController controller = await _controller.future;
  // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //   target: LatLng(lat, long),
  //  zoom: 15,
  // tilt: 50.0,
  //  bearing: 45.0,
  //  )));
  //}