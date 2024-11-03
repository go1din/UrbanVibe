import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class SearchPageMap extends StatefulWidget {
  final List<Map<String, String>> events;

  SearchPageMap({required this.events});

  @override
  SearchPageMapState createState() => SearchPageMapState();
}

class SearchPageMapState extends State<SearchPageMap> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  Marker? _firstMarker;

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() async {
    LatLngBounds? bounds;
    for (var event in widget.events) {
      if (event['address'] != null && event['address']!.isNotEmpty) {
        try {
          List<Location> locations =
              await locationFromAddress(event['address']!);
          if (locations.isNotEmpty) {
            final marker = Marker(
              markerId: MarkerId(event['name'] ?? ''),
              position: LatLng(locations[0].latitude, locations[0].longitude),
              infoWindow: InfoWindow(
                title: event['name'],
                snippet: event['address'],
              ),
            );
            setState(() {
              _markers.add(marker);
              _firstMarker ??= marker;
              if (bounds == null) {
                bounds = LatLngBounds(
                  southwest:
                      LatLng(locations[0].latitude, locations[0].longitude),
                  northeast:
                      LatLng(locations[0].latitude, locations[0].longitude),
                );
              } else {
                bounds = LatLngBounds(
                  southwest: LatLng(
                    bounds!.southwest.latitude < locations[0].latitude
                        ? bounds!.southwest.latitude
                        : locations[0].latitude,
                    bounds!.southwest.longitude < locations[0].longitude
                        ? bounds!.southwest.longitude
                        : locations[0].longitude,
                  ),
                  northeast: LatLng(
                    bounds!.northeast.latitude > locations[0].latitude
                        ? bounds!.northeast.latitude
                        : locations[0].latitude,
                    bounds!.northeast.longitude > locations[0].longitude
                        ? bounds!.northeast.longitude
                        : locations[0].longitude,
                  ),
                );
              }
            });
          }
        } catch (e) {
          print('Error setting marker for ${event['name']}: $e');
        }
      }
    }
    if (bounds != null) {
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 50));
      if (_firstMarker != null) {
        mapController.showMarkerInfoWindow(_firstMarker!.markerId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          if (_markers.isNotEmpty) {
            LatLngBounds bounds = _calculateBounds();
            mapController
                .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
            if (_firstMarker != null) {
              mapController.showMarkerInfoWindow(_firstMarker!.markerId);
            }
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers,
      ),
    );
  }

  LatLngBounds _calculateBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: _markers.first.position,
      northeast: _markers.first.position,
    );
    for (var marker in _markers) {
      bounds = LatLngBounds(
        southwest: LatLng(
          bounds.southwest.latitude < marker.position.latitude
              ? bounds.southwest.latitude
              : marker.position.latitude,
          bounds.southwest.longitude < marker.position.longitude
              ? bounds.southwest.longitude
              : marker.position.longitude,
        ),
        northeast: LatLng(
          bounds.northeast.latitude > marker.position.latitude
              ? bounds.northeast.latitude
              : marker.position.latitude,
          bounds.northeast.longitude > marker.position.longitude
              ? bounds.northeast.longitude
              : marker.position.longitude,
        ),
      );
    }
    return bounds;
  }
}
