import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, String> event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['name']!),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0), // Replace with the event's location
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('eventLocation'),
                  position: LatLng(0, 0), // Replace with the event's location
                  infoWindow: InfoWindow(title: event['name']),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: [
                    LatLng(0, 0), // Replace with the user's current location
                    LatLng(0, 0), // Replace with the event's location
                  ],
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
