import 'package:fav_places_app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Image
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.file(
                place.image,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Place Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                place.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            const SizedBox(height: 16),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 8),

            // Map
            SizedBox(
              height: 250,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: place.location,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.example.fav_places_app',
                  ),

                  MarkerLayer(
                    markers: [
                      Marker(
                        point: place.location,
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
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}