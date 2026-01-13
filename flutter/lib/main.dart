import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Room20App());
}

class Room20App extends StatelessWidget {
  const Room20App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final TextEditingController searchController = TextEditingController();
  String selectedCapacity = 'All';
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('rooms').get();
      final loadedRooms = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      setState(() {
        rooms = loadedRooms;
        markers.clear();
        for (var room in rooms) {
          if (room['coordinates'] != null) {
            final geopoint = room['coordinates'] as GeoPoint;
            markers.add(
              Marker(
                markerId: MarkerId(room['id']),
                position: LatLng(geopoint.latitude, geopoint.longitude),
                infoWindow: InfoWindow(
                  title: room['name'],
                  snippet: 'R${room['price']}/night',
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading rooms: $e')),
      );
    }
  }

  void _filterRooms(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _loadRooms();
      } else {
        rooms = rooms.where((room) => 
          room['name'].toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
          room['location'].toString().toLowerCase().contains(searchTerm.toLowerCase())
        ).toList();
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room 2.0'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: _filterRooms,
                  decoration: InputDecoration(
                    hintText: 'Search rooms...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', '1', '2', '4', '6+'].map((capacity) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(capacity),
                          selected: selectedCapacity == capacity,
                          onSelected: (selected) {
                            setState(() {
                              selectedCapacity = selected ? capacity : 'All';
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-26.2, 28.0),
                zoom: 12,
              ),
              markers: markers,
            ),
          ),
          Expanded(
            child: RoomListView(rooms: rooms),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class RoomListView extends StatelessWidget {
  final List<Map<String, dynamic>> rooms;

  const RoomListView({Key? key, required this.rooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const Center(
        child: Text('No rooms found'),
      );
    }

    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCard(room: room);
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room['name'] ?? 'Unnamed Room',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Location: ${room['location'] ?? 'N/A'}'),
            Text('Capacity: ${room['capacity'] ?? 'N/A'} people'),
            Text('Amenities: ${(room['amenities'] as List?)?.join(', ') ?? 'None'}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R${room['price'] ?? '0'}/night',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27AE60),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Booking ${room['name']} - Coming soon!')),
                    );
                  },
                  child: const Text('Book'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
