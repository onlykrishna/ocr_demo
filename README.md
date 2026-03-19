# Flutter OCR Demo App

A comprehensive demonstration of Optical Character Recognition (OCR) in Flutter using Google ML Kit Text Recognition.

## Features

✨ **Real-Time Camera OCR**
- Live text recognition from camera feed
- Pause/resume detection capability
- Visual scanning guides
- Copy recognized text to clipboard

📸 **Gallery Image OCR**
- Select images from device gallery
- Capture new photos with camera
- Extract structured data (emails, phone numbers, URLs)
- Copy individual items or full text

🎯 **Smart Text Extraction**
- Automatic email detection
- Phone number extraction
- URL parsing
- Clean text post-processing

## Screenshots

### Home Screen
The main menu allows users to choose between Live Camera OCR and Gallery Image OCR.

### Live Camera OCR
Real-time text recognition with visual guides and pause/resume controls.

### Gallery OCR
Select images and extract text with automatic structured data detection.

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode
- Physical device (recommended for camera features)

## Installation

### 1. Clone or Download the Project

```bash
git clone <repository-url>
cd flutter_ocr_demo
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Platform-Specific Setup

#### Android

Minimum SDK Version is already set to 21 in `android/app/build.gradle`.

Permissions are configured in `android/app/src/main/AndroidManifest.xml`:
- Camera
- Read/Write External Storage

#### iOS

Minimum iOS version: 12.0

Permissions are configured in `ios/Runner/Info.plist`:
- NSCameraUsageDescription
- NSPhotoLibraryUsageDescription

### 4. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For a specific device
flutter devices
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
└── screens/
    ├── home_screen.dart               # Main navigation screen
    ├── live_ocr_screen.dart          # Real-time camera OCR
    └── gallery_ocr_screen.dart       # Gallery image OCR

android/
└── app/
    ├── build.gradle                   # Android build configuration
    └── src/main/AndroidManifest.xml  # Android permissions

ios/
└── Runner/
    └── Info.plist                     # iOS permissions
```

## Dependencies

```yaml
dependencies:
  google_mlkit_text_recognition: ^0.11.0  # OCR engine
  image_picker: ^1.0.4                    # Image selection
  camera: ^0.10.5+5                       # Camera access
  permission_handler: ^11.0.1             # Runtime permissions
  path_provider: ^2.1.1                   # File paths
```

## Key Features Explained

### 1. Live Camera OCR

The `LiveOCRScreen` implements:
- Camera controller initialization
- Image stream processing
- Frame throttling to prevent performance issues
- Real-time text recognition
- Pause/resume functionality

**Performance Optimization:**
- Uses `_isProcessing` flag to throttle frame processing
- Skips frames when already processing
- Converts camera frames to ML Kit InputImage format

### 2. Gallery OCR

The `GalleryOCRScreen` provides:
- Image selection from gallery
- Photo capture with camera
- Text extraction from static images
- Structured data extraction (emails, phones, URLs)

**Post-Processing:**
- Regex patterns for email detection
- Phone number extraction
- URL parsing
- Text cleaning and formatting

### 3. Permission Handling

Both screens implement:
- Runtime permission requests
- Permission denial handling
- Settings navigation for manual permission grants

## Usage Guide

### Live Camera OCR

1. Launch the app and tap "Live Camera OCR"
2. Grant camera permission when prompted
3. Point your camera at text within the green frame
4. Text will be recognized in real-time
5. Use the pause button to freeze detection
6. Tap the copy icon to copy recognized text

### Gallery Image OCR

1. Tap "Gallery Image OCR" from the home screen
2. Choose "Gallery" to select an existing image or "Camera" to take a photo
3. Wait for processing to complete
4. View extracted text and structured data
5. Tap copy icons to copy individual items or full text
6. Tap the clear icon to process another image

## Troubleshooting

### Common Issues

**Camera not initializing:**
- Ensure camera permissions are granted
- Check if the device has a working camera
- Verify minSdkVersion is 21 or higher (Android)

**Text recognition not working:**
- Ensure good lighting conditions
- Keep text within the scanning frame
- Try with higher contrast images
- Verify ML Kit dependencies are properly installed

**Performance issues:**
- Use a physical device instead of emulator
- Reduce camera resolution if needed
- Ensure frame throttling is working

**Permission errors:**
- Check AndroidManifest.xml for Android
- Check Info.plist for iOS
- Manually grant permissions in device settings

## Testing

### Test on Physical Devices

OCR works best on physical devices. Test with:
- Business cards
- Book pages
- Printed documents
- Signs and labels
- Receipts and invoices

### Test Different Scenarios

- Various lighting conditions
- Different fonts and sizes
- Handwritten text (limited support)
- Multiple languages
- Curved or angled text

## Best Practices

1. **Always test on physical devices** - Emulators have limited camera support
2. **Handle permissions gracefully** - Provide clear explanations for permission requests
3. **Implement error handling** - Camera and OCR operations can fail
4. **Optimize performance** - Use frame throttling for real-time OCR
5. **Post-process text** - Clean and structure OCR output before displaying
6. **Dispose resources** - Always close TextRecognizer and CameraController

## Advanced Features to Add

- Multi-language support (Chinese, Japanese, Korean, Devanagari)
- Tesseract OCR integration for specialized needs
- Document scanning with edge detection
- Text-to-speech for accessibility
- Translation integration
- Cloud OCR for complex documents
- Batch processing for multiple images
- Export to various formats (PDF, TXT, CSV)

## Performance Tips

1. **Camera Resolution**: Use `ResolutionPreset.medium` for better performance
2. **Frame Skipping**: Process every 2nd or 3rd frame for better responsiveness
3. **Image Quality**: Balance quality vs. processing speed
4. **Memory Management**: Always dispose of recognizers and controllers

## Resources

- [Google ML Kit Documentation](https://developers.google.com/ml-kit/vision/text-recognition)
- [Flutter Camera Plugin](https://pub.dev/packages/camera)
- [Image Picker Plugin](https://pub.dev/packages/image_picker)
- [Permission Handler](https://pub.dev/packages/permission_handler)

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Submit a pull request
- Contact: support@flutterdevs.com

## License

MIT License - feel free to use this project for learning and commercial purposes.

## Credits

Developed as a comprehensive demonstration of OCR capabilities in Flutter.
Powered by Google ML Kit Text Recognition.

---

**Happy Coding! 🚀**
