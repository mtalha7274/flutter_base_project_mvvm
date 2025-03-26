# Flutter Base Project

## Overview
This Flutter project provides a quick foundation with the following features available out of the box:

- **Localization Support**: Multi-language support is integrated.
- **Light & Dark Themes**: Toggle between light and dark mode from settings.
- **Splash Screens**: Native and custom splash screens are set up.
- **MVVM Architecture**: Uses `get_it` for dependency injection.
- **Navigation**: Configured using `Navigator`.
- **Responsive Design**: Extensions on `int` and `double` for responsive UI (e.g., `10.h`, `20.0.w`).
- **State Management**: Uses `Provider`, but can be replaced with other state management solutions.
- **Keyboard Action Function**: Enhances user experience while handling input fields.
- **.env Support**: Secure API keys and environment configurations.
- **Debug Flavor**: Preconfigured for development and debugging.
- **Settings Page**:
  - Privacy Policy
  - Terms of Use
  - Rate App
  - Share App
  - Contact Us (pre-fills device info, country, and package details in email)
- **API Manager**: Includes an error handler class, utilizing the `http` package.
- **Firebase Remote Config**: Ready-to-use forced update popup implementation.
- **Firebase Analytics & Crashlytics**: Integrated for performance monitoring and crash reporting.
- **AdMob Ads Manager**: Configured to manage ads effectively.
- **Animated Bottom Navigation Bar**: Uses `flutter_animate` for smooth animations.
- **Fonts & Icons**: Custom fonts and icon support included.
- **Local Storage Manager**: Uses `shared_preferences` for persistent local storage.
- **Custom Modal Progress HUD**: Displays loading indicators elegantly.

---

## Getting Started

### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Dart SDK
- Firebase CLI (`flutterfire` CLI)

### Setup Instructions
1. **Create a `.env` file** in the root folder and add the following:
   ```
   DEBUG=true
   ```

2. **Firebase Setup**:
   - The project includes a `firebase_options` file with test keys.
   - Run the following command to set up Firebase in your project:
     ```sh
     flutterfire configure
     ```
   - Override the existing Firebase configuration with your own.

3. **Review and Configure the Project**:
   - Check all the `TODO` comments in the project.
   - Update the `config.dart` file as required.
