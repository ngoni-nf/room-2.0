# Room 2.0 Flutter Mobile App

Complete mobile booking and management system built with Flutter, Firebase, and Google Maps.

## Overview

The Room 2.0 Flutter application provides a cross-platform mobile experience for browsing and booking rooms with real-time Firebase integration and interactive Google Maps functionality.

## Features

✓ Cross-platform support (iOS, Android, Web)
✓ Firebase Firestore real-time database
✓ Google Maps integration with geolocation markers
✓ Real-time room listing and search
✓ Advanced filtering by capacity and location
✓ Material 3 design language
✓ Responsive UI with provider state management
✓ Room details and booking management
✓ Multi-language support ready

## Project Structure

```
flutter/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── firebase_options.dart     # Firebase configuration for all platforms
│   └── services/
│       └── room_service.dart     # Firestore integration and data models
├── pubspec.yaml                  # Flutter dependencies
└── android/                      # Android platform specific code
└── ios/                          # iOS platform specific code
└── web/                          # Web platform specific code
```

## Dependencies

### Core
- **flutter**: Flutter framework
- **firebase_core**: ^2.20.0 - Firebase initialization
- **cloud_firestore**: ^4.10.0 - Firestore database
- **google_maps_flutter**: ^2.5.0 - Google Maps integration

### State Management
- **provider**: ^6.0.0 - State management solution

### UI/UX
- **cached_network_image**: ^3.3.0 - Image caching
- **flutter_rating_bar**: ^4.0.1 - Rating widget
- **search_page**: ^2.0.1 - Search functionality

### Utilities
- **http**: ^1.1.0 - HTTP requests
- **intl**: ^0.19.0 - Internationalization

## Installation

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- iOS 11+ (for iOS builds)
- Android API 21+ (for Android builds)
- Chrome (for web builds)

### Setup

1. **Clone repository**
```bash
git clone https://github.com/ngoni-nf/room-2.0.git
cd room-2.0/flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Update `lib/firebase_options.dart` with your Firebase configuration
- For Android: Configure `android/build.gradle`
- For iOS: Configure `ios/Podfile` and `Info.plist`
- For Web: Configure `web/index.html`

4. **Configure Google Maps**
- Add your Google Maps API key to:
  - Android: `android/app/src/main/AndroidManifest.xml`
  - iOS: `ios/Runner/GoogleService-Info.plist`
  - Web: Already configured in `lib/main.dart`

## Running the App

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d iphone
```

### Web
```bash
flutter run -d chrome
```

### Release Build

**Android APK**
```bash
flutter build apk --release
```

**iOS App**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

## Architecture

### Data Models

**Room Model** (`room_service.dart`)
- id: String
- name: String
- location: String
- capacity: int
- price: double
- amenities: List<String>
- coordinates: GeoPoint (latitude, longitude)
- createdAt: DateTime
- updatedAt: DateTime

### Services

**RoomService** - Handles all Firestore operations:
- `getAllRooms()` - Fetch all rooms
- `getRoomById(roomId)` - Get specific room
- `createRoom(room)` - Create new room
- `updateRoom(roomId, room)` - Update room details
- `deleteRoom(roomId)` - Delete room
- `getRoomsStream()` - Real-time updates
- `searchRoomsByLocation(location)` - Search by location
- `getRoomsByCapacity(minCapacity)` - Filter by capacity

## Firebase Configuration

### Firestore Collections

**rooms**
```javascript
{
  name: string,
  location: string,
  capacity: number,
  price: number,
  amenities: array,
  coordinates: geopoint,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{document=**} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
  }
}
```

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test --verbose
```

## Performance Optimization

- Pagination for large datasets
- Image caching with cached_network_image
- Lazy loading with ListView.builder
- Efficient Firestore queries
- Provider for optimized rebuilds

## Troubleshooting

### Firebase Connection Issues
- Verify Firebase credentials in `firebase_options.dart`
- Check Firestore security rules
- Ensure internet connectivity

### Google Maps Not Loading
- Verify API key configuration
- Check device/emulator location services
- Verify API key restrictions

### Platform-Specific Issues

**Android:**
- Ensure targetSdkVersion 33+
- Update android/build.gradle
- Configure ProGuard rules

**iOS:**
- Run `pod install` in ios/ directory
- Update deployment target to 11.0+
- Check Info.plist permissions

## Deployment

### Google Play Store
1. Create app in Google Play Console
2. Build release APK/AAB
3. Configure signing
4. Upload and distribute

### Apple App Store
1. Create app in App Store Connect
2. Build release iOS app
3. Configure signing certificate
4. Submit for review

### Firebase Hosting (Web)
```bash
flutter build web --release
firebase deploy --only hosting
```

## Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Submit pull request

## Version History

### v2.0.0 (Current)
- Complete Flutter mobile app
- Firebase Firestore integration
- Google Maps support for all platforms
- Material 3 design
- Multi-platform support (iOS, Android, Web)

## License

MIT License - See LICENSE file

## Support

- Flutter: https://flutter.dev
- Firebase: https://firebase.google.com/docs
- Google Maps: https://developers.google.com/maps

## Author

ngoni-nf (ngoni@room20.com)
