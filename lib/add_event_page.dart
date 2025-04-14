import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user logged in')),
        );
        return;
      }
      final currentUserUid = user.uid;
      // Optionally, you might also store the user's displayName:
      // final currentUserName = user.displayName ?? 'Unknown';

      final newEvent = {
        'title': _titleController.text.trim(),
        'address': _addressController.text.trim(),
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
        'shortDescription': _shortDescriptionController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'location': {
          'lat': double.tryParse(_latController.text) ?? 0.0,
          'lng': double.tryParse(_lngController.text) ?? 0.0,
        },
        'createdBy': currentUserUid, // save creator's UID
        // Optionally, add 'creatorName': currentUserName,
      };

      try {
        // Write the event to the global events collection.
        await FirebaseFirestore.instance.collection('events').add(newEvent);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );

        Navigator.pop(context); // Go back after creation
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _shortDescriptionController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 10),
              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 10),
              // Date
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              const SizedBox(height: 10),
              // Time
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              const SizedBox(height: 10),
              // Short Description
              TextFormField(
                controller: _shortDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Short Description'),
              ),
              const SizedBox(height: 10),
              // Full Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 10),
              // Latitude
              TextFormField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Longitude
              TextFormField(
                controller: _lngController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
