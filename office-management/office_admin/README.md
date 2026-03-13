# Office Admin

## Environments

The app supports three environments:

- `local`
- `uat`
- `prod`

Flutter entrypoints:

- `lib/main_local.dart`
- `lib/main_uat.dart`
- `lib/main_prod.dart`

## Run Commands

Web local:

```bash
flutter run -d chrome -t lib/main_local.dart
```

Android local:

```bash
flutter run -d android -t lib/main_local.dart --flavor local
```

Android UAT:

```bash
flutter run -d android -t lib/main_uat.dart --flavor uat
```

Android prod:

```bash
flutter run -d android -t lib/main_prod.dart --flavor prod
```

## Android Tester Builds

Build local APK:

```bash
flutter build apk --flavor local -t lib/main_local.dart
```

Build UAT APK:

```bash
flutter build apk --flavor uat -t lib/main_uat.dart
```

Build production APK:

```bash
flutter build apk --release --flavor prod -t lib/main_prod.dart
```

Build production App Bundle:

```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

Generated outputs:

- `build/app/outputs/flutter-apk/`
- `build/app/outputs/bundle/`

## Android Signing

For real tester or store-ready Android release builds, create:

- `android/key.properties`

Use the template:

- `android/key.properties.example`

Expected keys:

```properties
storePassword=your-password
keyPassword=your-password
keyAlias=upload
storeFile=/absolute/path/to/your-upload-keystore.jks
```

If `android/key.properties` is missing, release builds fall back to the debug signing key. That is acceptable for quick internal testing, but not for production distribution.

## iOS Release Preparation

The iOS project is prepared with placeholders so you can complete signing later when you have a paid Apple Developer account.

Update these values in:

- `ios/Flutter/AppConfig.xcconfig`

Fields:

```xcconfig
APP_DISPLAY_NAME=Office Admin
APP_BUNDLE_IDENTIFIER=com.yourcompany.officeadmin
APPLE_DEVELOPMENT_TEAM=YOUR_TEAM_ID
```

Optional export template:

- `ios/ExportOptions.plist.example`

## iOS Build Commands

Local iOS run:

```bash
flutter run -d ios -t lib/main_local.dart
```

UAT iOS run:

```bash
flutter run -d ios -t lib/main_uat.dart
```

Production iOS release build:

```bash
flutter build ipa -t lib/main_prod.dart --release
```

Archive only:

```bash
flutter build ios -t lib/main_prod.dart --release
```

After you add your Apple Developer team and signing in Xcode, you can distribute through TestFlight.

## Important iOS Note

Without a paid Apple Developer account you can:

- run on iOS simulator
- run on your own iPhone with limited free signing

Without the paid Apple Developer Program you cannot properly distribute iOS builds to outside testers through TestFlight or App Store Connect.
