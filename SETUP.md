# Room 2.0 - Setup & Configuration Guide

## Project Overview
Room 2.0 is a complete room booking and management system with Firebase backend, Google Maps integration, and real-time database capabilities.

## Prerequisites
- Node.js v14+ installed
- npm or yarn package manager
- Firebase account
- Google Cloud Console access

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/ngoni-nf/room-2.0.git
cd room-2.0
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Configure Environment Variables
Copy `.env.example` to `.env` and fill in your credentials:
```bash
cp .env.example .env
```

Update the following variables in `.env`:
- `FIREBASE_API_KEY`: Your Firebase API Key
- `FIREBASE_PROJECT_ID`: Your Firebase Project ID
- `FIREBASE_SERVICE_ACCOUNT`: Your Firebase Service Account JSON
- `GOOGLE_MAPS_API_KEY`: Your Google Maps API Key
- `FIREBASE_DATABASE_URL`: Your Firestore Database URL

### 4. Firebase Configuration

#### Firestore Database
- Project: `room-app-sa`
- Database: Cloud Firestore (Standard Edition)
- Mode: Test mode (30-day access)
- Location: United States

Collections created:
- `rooms` - Room listings and details
- `bookings` - Booking records and management

#### Required Collections Structure
```
rooms/
  ├── name (string)
  ├── location (string)
  ├── capacity (number)
  ├── price (number)
  ├── amenities (array)
  ├── coordinates (geopoint)
  ├── createdAt (timestamp)
  └── updatedAt (timestamp)

bookings/
  ├── roomId (reference)
  ├── userId (string)
  ├── startDate (timestamp)
  ├── endDate (timestamp)
  ├── totalPrice (number)
  ├── status (string: pending, confirmed, cancelled)
  └── createdAt (timestamp)
```

### 5. Google Maps API

#### API Key Details
- API Key: `AIzaSyBYTRJqiayQmiPeD4hwHFIKqIGDkXmRaVY`
- Status: Unrestricted (Configure restrictions in Cloud Console)
- Project: My First Project

#### Recommended API Restrictions
1. HTTP referrers: Add your domain(s)
2. Restrict to Maps Embed API, Maps JavaScript API, Maps Static API

#### Implementation
The Google Maps API is integrated in `public/index.html`:
```javascript
<script async defer src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
```

### 6. Running the Application

#### Development Mode
```bash
npm run dev
```
Server will start on `http://localhost:5000`

#### Production Mode
```bash
npm start
```

### 7. API Endpoints

#### Rooms API
- `GET /api/rooms` - Get all rooms
- `GET /api/rooms/:id` - Get room by ID
- `POST /api/rooms` - Create new room
- `PUT /api/rooms/:id` - Update room
- `DELETE /api/rooms/:id` - Delete room

#### Bookings API
- `POST /api/bookings` - Create booking
- `GET /api/bookings/:roomId` - Get room bookings

### 8. Frontend Access
Access the web application at: `http://localhost:5000/public/index.html`

## Features

✓ Real-time room listing display
✓ Google Maps integration with room markers
✓ Search and filter functionality
✓ Booking management system
✓ Firebase real-time database sync
✓ Responsive UI design

## Testing

1. Verify Firebase connectivity
```bash
node -e "require('firebase-admin').initializeApp(...)" 
```

2. Test API endpoints
```bash
curl http://localhost:5000/api/rooms
```

3. Check Maps loading in browser console

## Deployment

### Firebase Hosting
```bash
firebase login
firebase deploy
```

### Heroku/Cloud Run
```bash
git push heroku main
```

## Troubleshooting

### Firebase Connection Issues
- Verify `.env` variables are correct
- Check Firebase project is accessible
- Ensure Firestore database is in test mode

### Google Maps Not Loading
- Verify API key is valid
- Check API key restrictions
- Inspect browser console for errors

### Port Already in Use
```bash
PORT=3000 npm run dev
```

## Security Notes
- Never commit `.env` file with real credentials
- Rotate Google Maps API key regularly
- Enable API restrictions in Cloud Console
- Use Firebase Security Rules in production

## Support & Documentation
- Firebase: https://firebase.google.com/docs
- Google Maps: https://developers.google.com/maps
- Node.js: https://nodejs.org/docs

## Version History
- v2.0.0 - Initial release with Maps & Firebase integration
