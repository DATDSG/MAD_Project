# MAD Project

A comprehensive Flutter application for hostel management and discovery platform with real-time Google Maps integration. This project demonstrates modern mobile development practices with Firebase backend integration, role-based access control, and location-based services.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Building](#building)
- [Architecture](#architecture)
- [API Integration](#api-integration)
- [Development](#development)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication**
  - Sign up and sign in functionality with email verification
  - Secure password reset mechanism
  - Firebase authentication integration

- **Hostel Discovery**
  - Browse and view hostel details on an interactive Google Map
  - Search hostels by location
  - View hostel ratings and amenities

- **User Profiles**
  - Create and customize user profiles
  - Edit personal information
  - Manage preferences and settings

- **Admin Features**
  - Complete hostel management (add, edit, delete)
  - Admin dashboard for analytics
  - Set hostel locations on map
  - Manage hostel details and amenities

- **Google Maps Integration**
  - Real-time location-based hostel search
  - Interactive map with hostel markers
  - Location editing and management
  - GPS-based navigation

## Project Structure

```text
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── pages/                    # UI pages
│   ├── google_map.dart
│   ├── password_reset_page.dart
│   ├── sign_in_page.dart
│   ├── sign_up_page.dart
│   ├── admin/               # Admin-specific pages
│   │   ├── add_hostel.dart
│   │   ├── admin_home_page.dart
│   │   ├── admin_hostel_details.dart
│   │   ├── edit_google_map_location.dart
│   │   ├── edit_hostel.dart
│   │   ├── get_google_map_location.dart
│   │   └── hostel.dart
│   └── user/                # User-specific pages
│       ├── auth_page.dart
│       ├── edit_profile_page.dart
│       ├── google_map_home_page.dart
│       ├── home_page.dart
│       ├── hostel_deails_page.dart
│       ├── map_page.dart
│       └── profile_page.dart
└── services/               # Business logic and services
```

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio or Xcode for native development
- Firebase project configuration

### Installation

1. Clone the repository

```bash
git clone <repository-url>
cd MAD_Project
```

1. Install dependencies

```bash
flutter pub get
```

1. Configure Firebase

- Update `firebase_options.dart` with your Firebase project credentials
- Ensure `google-services.json` is properly configured for Android

1. Run the application

```bash
flutter run
```

## Building

### Android

```bash
flutter build apk
```

### iOS

```bash
flutter build ios
```

## Architecture

### Design Patterns

- **MVC Architecture**: Separation of Model, View, and Controller layers
- **Service Layer**: Business logic abstraction through services
- **Page-based Navigation**: Clear page structure for different user roles

### Technology Stack

- **Frontend**: Flutter & Dart
- **Backend**: Firebase (Firestore, Authentication, Cloud Functions)
- **Maps**: Google Maps API
- **Native**: Kotlin (Android), Swift (iOS)

## Project Dependencies

### Core Dependencies

- **firebase_core**: Firebase initialization and configuration
- **firebase_auth**: User authentication and account management
- **cloud_firestore**: Cloud database for hostel and user data
- **google_maps_flutter**: Interactive map functionality
- **provider/getx**: State management (depending on implementation)

### Development Dependencies

- Dart SDK analysis tools
- Flutter test framework
- Device emulators for testing

## API Integration

### Firebase Services

- **Authentication**: Email/password authentication with secure session management
- **Firestore Database**: Real-time data sync for hostels, users, and bookings
- **Cloud Storage**: Store hostel images and user profile pictures
- **Google Services**: `google-services.json` configuration required

### Google Maps API

- Location search and display
- Marker clustering for multiple hostels
- Custom info windows for hostel details
- Location picking for hostel address setup

## Development

### Best Practices

- **Code Organization**: Pages separated by user role (admin/user)
- **State Management**: Consistent state handling across the app
- **Error Handling**: Proper exception handling and user feedback
- **Security**: Firebase security rules and authentication validation
- **Testing**: Unit tests and integration tests for critical features

### Directory Structure Explanation

- **pages/**: UI implementation for different screens
  - **admin/**: Admin-only pages (add, edit, manage hostels)
  - **user/**: User-specific pages (browse, view, profile)
- **services/**: Business logic, API calls, and data management
- **assets/**: Images and static resources

### Running in Development

```bash
# Enable web development (if needed)
flutter config --enable-web

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator
open -a Simulator && flutter run

# Run on physical device
flutter run -d <device-id>
```

### Common Tasks

```bash
# Format code
dart format lib/

# Analyze code
flutter analyze

# Clean build artifacts
flutter clean

# Rebuild app
flutter pub get && flutter run

# Generate release build
flutter build apk --release
```

## Testing

### Manual Testing Checklist

- [ ] User registration and email verification
- [ ] User login with valid/invalid credentials
- [ ] Password reset functionality
- [ ] Hostel discovery on map
- [ ] Admin hostel creation and editing
- [ ] Profile management and updates
- [ ] Google Maps functionality and location selection

### Device Compatibility

- **Android**: API level 21+
- **iOS**: iOS 11.0+

## Troubleshooting

### Common Issues

#### Google Maps not displaying

- Verify Google Maps API key in `AndroidManifest.xml` and `Info.plist`
- Ensure location permissions are granted
- Check Google Maps API is enabled in Google Cloud Console

#### Firebase connection issues

- Verify `google-services.json` is correctly placed in `android/app/`
- Check Firebase project credentials
- Ensure internet connectivity

#### Build errors

```bash
# Clear cache and rebuild
flutter clean
flutter pub get
flutter run
```

## Contributing

We welcome contributions! Please follow these guidelines:

1. Create a feature branch from `main`
2. Make your changes with descriptive commit messages
3. Test thoroughly before submitting a pull request
4. Follow Flutter/Dart style guidelines

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Project Information

- **Version**: 1.0.0
- **Status**: In Development
- **Last Updated**: November 2025

## Contributors

- Team MAD Project

## Support

For issues, bugs, or feature requests, please open an issue in the repository.

For security-related concerns, please contact the development team privately.
