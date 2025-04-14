import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventDetailPage({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Extract event details from the eventData map.
    final String title = eventData['title'] ?? 'No Title';
    final String address = eventData['address'] ?? 'No Address';
    final String date = eventData['date'] ?? 'No Date Provided';
    final String time = eventData['time'] ?? 'No Time Provided';
    final String description =
        eventData['description'] ?? 'No description available.';

    // 2. Extract imageUrl from the Firestore document
    final String? imageUrl = eventData['imageUrl'] as String?;

    // 3. Extract the location from the eventData (lat/lng for the map)
    final Map<String, dynamic>? locationData =
        eventData['location'] as Map<String, dynamic>?;
    final double lat = locationData?['lat']?.toDouble() ?? 0.0;
    final double lng = locationData?['lng']?.toDouble() ?? 0.0;
    final LatLng eventLatLng = LatLng(lat, lng);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========== CARD 1: Image & Basic Info ===========
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: Image.network(
                      // Use imageUrl from Firestore if available, else a fallback
                      (imageUrl != null && imageUrl.isNotEmpty)
                          ? imageUrl
                          : 'https://via.placeholder.com/600x300.png?text=No+Image+Available',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Title, Date, Time, Address, Description
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Date & Time Row
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 18),
                            const SizedBox(width: 6),
                            Text(date, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 20),
                            const Icon(Icons.access_time, size: 18),
                            const SizedBox(width: 6),
                            Text(time, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Address Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                address,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Full Description
                        Text(
                          description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========== CARD 2: Map ===========
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Lat/Lng text (optional)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.my_location, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Latitude: $lat, Longitude: $lng',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Map
                    SizedBox(
                      height: 250,
                      child: FlutterMap(
                        options: MapOptions(
                          center: eventLatLng,
                          zoom: 14.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.myapp',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80,
                                height: 80,
                                point: eventLatLng,
                                builder: (ctx) => const Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          // Manually display attribution
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              color: Colors.white70,
                              padding: const EdgeInsets.all(4),
                              child: const Text(
                                '© OpenStreetMap contributors',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
