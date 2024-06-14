// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    //initializeParkingCollection();
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
          _buildMap(context),
          _buildContainer(),
        ],
      ),
    );
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
                  "gerezani",
                  ),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1526626607369-f89fe1ed77a9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.784741726616766,
                  39.218767750446965,
                  "ubungo",
                  ),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNhciUyMHBhcmtpbmd8ZW58MHx8MHx8fDA%3D",
                  -6.814532286980702,
                  39.28799772774392,
                  "posta",
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1543465077-db45d34b88a5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.821214476703329,
                  39.28051110811758,
                  "mnazi",
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://images.unsplash.com/photo-1578859695220-856a4f5edd39?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2FyJTIwcGFya2luZ3xlbnwwfHwwfHx8MA%3D%3D",
                  -6.766000346201719,
                  39.23002729462172,
                  "mwenge",
                  ),
            ),
    
          ],
        ),
      ),
    );
  }

Widget _boxes(String image, double lat, double long, String parkingName) {
  Stream<Map<String, dynamic>> getParkingStream(String parkingName) {
    return FirebaseFirestore.instance
        .collection('parking')
        .doc(parkingName)
        .snapshots()
        .map((snapshot) {
      return {
        'parkingName': snapshot.id,
        'availableSlots': snapshot['availableSlots'],
      };
    });
  }

  return GestureDetector(
    onTap: () {
      showpopup(parkingName, (int newSlots) {
        setState(() {
          // Update Firestore with the new slots value
          FirebaseFirestore.instance
              .collection('parking')
              .doc(parkingName)
              .update({'availableSlots': newSlots});
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
                child: myDetailsContainer1(getParkingStream(parkingName)),
              ),
            ],
          )),
    ),
  );
}


 Widget myDetailsContainer1(Stream<Map<String, dynamic>> parkingStream) {
  return StreamBuilder<Map<String, dynamic>>(
    stream: parkingStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData) {
        return Text('No data available');
      } else {
        final parkingData = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                parkingData['parkingName'],
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
            Text("Parking slots available: ${parkingData['availableSlots']}")
          ],
        );
      }
    },
  );
}



  Widget _buildMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
            target: LatLng(-6.814594032429642, 39.27999040811724), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // _setMapBounds(controller);
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
        .animateCamera(CameraUpdate.newLatLngBounds(darEsSalaamBounds, 10));
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
      String restaurantName, Function(int) updateSlots) {
    if (restaurantName == 'gerezani') {
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
    } else if (restaurantName == 'mwenge') {
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
    } else if (restaurantName == 'posta') {
      routeCoordinates = [
        const LatLng(-6.815353060930553, 39.27957734971781),
        const LatLng(-6.815907017814727, 39.28033909702955),
        const LatLng(-6.814756491262507, 39.28161582843934),
        const LatLng(-6.814223839132042, 39.28225419425496),
        const LatLng(-6.811736345830938, 39.28516975590098),
        const LatLng(-6.8146978994614305, 39.28776613406208),
        const LatLng(-6.814532286980702, 39.28799772774392),
      ];
    } else if (restaurantName == 'ubungo') {
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
    } else if (restaurantName == 'mnazi') {
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
                Text('Parking Slots: $restaurantName'),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Book Parking
                        bookParkingSlot(context, restaurantName);
                        // setState(() {
                        //   parkingSlots--;
                        // });
                        // updateSlots(parkingSlots);
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
                        clearParkingSlot(context, restaurantName);
                        // setState(() {
                        //   parkingSlots++;
                        // });
                       // updateSlots(parkingSlots);
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

Future<void> bookParkingSlot(BuildContext context, String parkingName) async {
  DocumentReference parkingRef =
      FirebaseFirestore.instance.collection('parking').doc(parkingName);
  DocumentSnapshot parkingSnapshot = await parkingRef.get();

  if (parkingSnapshot.exists) {
    int availableSlots = parkingSnapshot['availableSlots'];
    if (availableSlots > 0) {
      await parkingRef.update({'availableSlots': availableSlots - 1});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booked a slot at $parkingName')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No parking slots available at $parkingName')));
    }
  } else {
    print('Error unknown parking $parkingName');
  }
}

Future<void> clearParkingSlot(BuildContext context, String parkingName) async {
  DocumentReference parkingRef =
      FirebaseFirestore.instance.collection('parking').doc(parkingName);
  DocumentSnapshot parkingSnapshot = await parkingRef.get();

  if (parkingSnapshot.exists) {
    int availableSlots = parkingSnapshot['availableSlots'];
    if (availableSlots < 20) {
      await parkingRef.update({'availableSlots': availableSlots + 1});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cleared a slot at $parkingName')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('All parking slots are already empty at $parkingName')));
    }
  }
}

Future<void> initializeParkingCollection() async {
  CollectionReference parkingCollection =
      FirebaseFirestore.instance.collection('parking');

  List<String> parkingNames = [
    'mnazi',
    'mwenge',
    'uhuru',
    'gerezani',
    'ubungo',
    'posta'
  ];

  for (String name in parkingNames) {
    DocumentReference parkingDoc = parkingCollection.doc(name);
    await parkingDoc.set({'availableSlots': 20});
  }
}

Stream<List<Map<String, dynamic>>> getAvailableSlots() {
  return FirebaseFirestore.instance.collection('parking').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return {
        'parkingName': doc.id,
        'availableSlots': doc['availableSlots'],
      };
    }).toList();
  });
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
