import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final double price;
  final List<String> amenities;
  final GeoPoint? coordinates;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Room({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.price,
    required this.amenities,
    this.coordinates,
    this.createdAt,
    this.updatedAt,
  });

  factory Room.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Room(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      capacity: data['capacity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      amenities: List<String>.from(data['amenities'] ?? []),
      coordinates: data['coordinates'] as GeoPoint?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'capacity': capacity,
      'price': price,
      'amenities': amenities,
      'coordinates': coordinates,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String roomsCollection = 'rooms';

  Future<List<Room>> getAllRooms() async {
    try {
      final snapshot = await _firestore.collection(roomsCollection).get();
      return snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Room?> getRoomById(String roomId) async {
    try {
      final doc = await _firestore.collection(roomsCollection).doc(roomId).get();
      if (doc.exists) {
        return Room.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createRoom(Room room) async {
    try {
      final docRef = await _firestore
          .collection(roomsCollection)
          .add(room.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRoom(String roomId, Room room) async {
    try {
      await _firestore
          .collection(roomsCollection)
          .doc(roomId)
          .update(room.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      await _firestore.collection(roomsCollection).doc(roomId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Room>> getRoomsStream() {
    return _firestore.collection(roomsCollection).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList(),
    );
  }

  Future<List<Room>> searchRoomsByLocation(String location) async {
    try {
      final snapshot = await _firestore
          .collection(roomsCollection)
          .where('location', isGreaterThanOrEqualTo: location)
          .where('location', isLessThan: location + 'z')
          .get();
      return snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Room>> getRoomsByCapacity(int minCapacity) async {
    try {
      final snapshot = await _firestore
          .collection(roomsCollection)
          .where('capacity', isGreaterThanOrEqualTo: minCapacity)
          .get();
      return snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
