import 'dart:io';

import 'package:fav_places_app/provider/places_provider.dart';
import 'package:fav_places_app/widgets/image_input.dart';
import 'package:fav_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? selectdImage;
  LatLng? selectedLocation;

  void savePlace() {
    final enterdtitle = _titleController.text;
    if (enterdtitle.isEmpty || selectdImage == null|| selectedLocation == null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enterdtitle, selectdImage!,selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            ImageInput(
              onImagePicked: (image) {
                selectdImage = image;
              },
            ),
            const SizedBox(height: 12),
            LocationInput(onLocationPicked: (selectedLocation) {
              selectedLocation = selectedLocation;
            }
            ,),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
