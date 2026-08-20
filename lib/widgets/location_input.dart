import 'package:fav_places_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationPicked});

  final void Function(LatLng location) onLocationPicked;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? pickedLocation;

  bool isGettingLocation = false;

  // =========================================================
  // Get Current Location
  // =========================================================

  Future<void> getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    final location = Location();

    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        setState(() {
          isGettingLocation = false;
        });
        return;
      }
    }

    // Check permission
    PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          isGettingLocation = false;
        });
        return;
      }
    }

    // Get location
    final locationData = await location.getLocation();

    final currentLocation = LatLng(
      locationData.latitude,
      locationData.longitude,
    );

    setState(() {
      pickedLocation = currentLocation;
      isGettingLocation = false;
    });

    // Send location to AddPlaceScreen
    widget.onLocationPicked(currentLocation);
  }

  Future<void> selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => MapScreen(initialLocation: pickedLocation),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        pickedLocation = selectedLocation;
      });

      // Send selected location to AddPlaceScreen
      widget.onLocationPicked(selectedLocation);
    }
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    Widget previewContent;

    // Loading
    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    // No location
    else if (pickedLocation == null) {
      previewContent = Text(
        'No Location Chosen',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    // Show map
    else {
      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: pickedLocation!,
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.fav_places_app',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: pickedLocation!,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: previewContent,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: isGettingLocation ? null : getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),

            TextButton.icon(
              onPressed: selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
