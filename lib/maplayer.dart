import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:fluttermaps/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class MapLayer extends StatefulWidget {
  const MapLayer({super.key, required this.title});

  final String title;

  @override
  State<MapLayer> createState() => _MapLayerState();
}

class _MapLayerState extends State<MapLayer> {
  // instantiate parser, use the defaults
  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.amber,
    defaultPolygonBorderColor: Colors.amber,
    defaultPolygonFillColor: Colors.amber.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.amber.withOpacity(0.25),
  );

  bool loadingData = false;

  bool myFilterFunction(Map<String, dynamic> properties) {
    if (properties['section'].toString().contains('Point M-4')) {
      return false;
    } else {
      return true;
    }
  }

  void onTapMarkerFunction(Map<String, dynamic> map) {
    // ignore: avoid_print
    print('onTapMarkerFunction: $map');
  }

  Future<void> processData() async {
    geoJsonParser.parseGeoJsonAsString(Constants().dataGeoJson);
  }

  @override
  void initState() {
    geoJsonParser.setDefaultMarkerTapCallback(onTapMarkerFunction);
    geoJsonParser.filterFunction = myFilterFunction;
    loadingData = true;
    Stopwatch stopwatch2 = Stopwatch()..start();
    processData().then((_) {
      setState(() {
        loadingData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GeoJson Processing time: ${stopwatch2.elapsed}'),
          duration: const Duration(milliseconds: 5000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: FlutterMap(
          mapController: MapController(),
          options: const MapOptions(
            initialCenter: LatLng(-6.814594032429642, 39.27999040811724),
           
            initialZoom: 14,
          ),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c']),
           
            loadingData
                ? const Center(child: CircularProgressIndicator())
                : PolygonLayer(
                    polygons: geoJsonParser.polygons,
                  ),
            if (!loadingData) PolylineLayer(polylines: geoJsonParser.polylines),
            if (!loadingData) MarkerLayer(markers: geoJsonParser.markers),
            if (!loadingData) CircleLayer(circles: geoJsonParser.circles),
          ],
        ));
  }
}