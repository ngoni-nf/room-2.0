const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();
const admin = require('firebase-admin');

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

// Initialize Firebase Admin SDK
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL
});

const db = admin.firestore();

// Routes
app.get('/', (req, res) => {
  res.send('Room 2.0 API Server is running');
});

// Get all rooms
app.get('/api/rooms', async (req, res) => {
  try {
    const snapshot = await db.collection('rooms').get();
    const rooms = [];
    snapshot.forEach(doc => {
      rooms.push({ id: doc.id, ...doc.data() });
    });
    res.json(rooms);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get room by ID
app.get('/api/rooms/:id', async (req, res) => {
  try {
    const doc = await db.collection('rooms').doc(req.params.id).get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'Room not found' });
    }
    res.json({ id: doc.id, ...doc.data() });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create new room
app.post('/api/rooms', async (req, res) => {
  try {
    const { name, location, capacity, price, amenities, coordinates } = req.body;
    const docRef = await db.collection('rooms').add({
      name,
      location,
      capacity,
      price,
      amenities,
      coordinates,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    res.json({ id: docRef.id, ...req.body });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update room
app.put('/api/rooms/:id', async (req, res) => {
  try {
    const { name, location, capacity, price, amenities, coordinates } = req.body;
    await db.collection('rooms').doc(req.params.id).update({
      name,
      location,
      capacity,
      price,
      amenities,
      coordinates,
      updatedAt: new Date()
    });
    res.json({ id: req.params.id, ...req.body });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete room
app.delete('/api/rooms/:id', async (req, res) => {
  try {
    await db.collection('rooms').doc(req.params.id).delete();
    res.json({ message: 'Room deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Bookings endpoints
app.post('/api/bookings', async (req, res) => {
  try {
    const { roomId, userId, startDate, endDate, totalPrice } = req.body;
    const docRef = await db.collection('bookings').add({
      roomId,
      userId,
      startDate,
      endDate,
      totalPrice,
      status: 'pending',
      createdAt: new Date()
    });
    res.json({ id: docRef.id, ...req.body });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/bookings/:roomId', async (req, res) => {
  try {
    const snapshot = await db.collection('bookings')
      .where('roomId', '==', req.params.roomId)
      .get();
    const bookings = [];
    snapshot.forEach(doc => {
      bookings.push({ id: doc.id, ...doc.data() });
    });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Room 2.0 API Server running on port ${PORT}`);
});

module.exports = app;
