import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();

    selectedLocation = widget.initialLocation;
  }

  void selectLocation(TapPosition tapPosition, LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void confirmLocation() {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a location first',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pop(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    // Default location
    //
    // Cairo coordinates are used only when
    // the user hasn't selected a location yet.
    final initialLocation =
        widget.initialLocation ??
        const LatLng(
          30.0444,
          31.2357,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
        ),
      ),

      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: initialLocation,
              initialZoom: 12,

              onTap: selectLocation,
            ),

            children: [
              // OpenStreetMap
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.myapp',
              ),

              // Marker
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 55,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Bottom confirmation button
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: confirmLocation,
                icon: const Icon(
                  Icons.check,
                ),
                label: const Text(
                  'Confirm Location',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}