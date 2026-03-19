import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class GalleryOCRScreen extends StatefulWidget {
  const GalleryOCRScreen({super.key});

  @override
  State<GalleryOCRScreen> createState() => _GalleryOCRScreenState();
}

class _GalleryOCRScreenState extends State<GalleryOCRScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  String _extractedText = '';
  File? _selectedImage;
  bool _isProcessing = false;
  List<String> _extractedEmails = [];
  List<String> _extractedPhones = [];
  List<String> _extractedUrls = [];

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _isProcessing = true;
        _extractedText = '';
        _extractedEmails = [];
        _extractedPhones = [];
        _extractedUrls = [];
      });

      await _processImage(pickedFile.path);
    } catch (e) {
      _showError('Failed to pick image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _isProcessing = true;
        _extractedText = '';
        _extractedEmails = [];
        _extractedPhones = [];
        _extractedUrls = [];
      });

      await _processImage(pickedFile.path);
    } catch (e) {
      _showError('Failed to capture image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImage(String imagePath) async {
    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText result = await _textRecognizer.processImage(inputImage);

      final cleanedText = _cleanOCROutput(result.text);

      setState(() {
        _extractedText = cleanedText;
      });

      _extractStructuredData(cleanedText);
    } catch (e) {
      _showError('Failed to process image: $e');
    }
  }

  String _cleanOCROutput(String rawText) {
    // Remove extra whitespace and blank lines
    String cleaned = rawText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n');

    return cleaned;
  }

  void _extractStructuredData(String text) {
    // Extract emails
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    );
    final emails = emailRegex
        .allMatches(text)
        .map((m) => m.group(0)!)
        .toSet()
        .toList();

    // Extract phone numbers
    final phoneRegex = RegExp(
      r'[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}',
    );
    final phones = phoneRegex
        .allMatches(text)
        .map((m) => m.group(0)!)
        .toSet()
        .toList();

    // Extract URLs
    final urlRegex = RegExp(
      r'https?://[^\s]+|www\.[^\s]+',
    );
    final urls = urlRegex
        .allMatches(text)
        .map((m) => m.group(0)!)
        .toSet()
        .toList();

    setState(() {
      _extractedEmails = emails;
      _extractedPhones = phones;
      _extractedUrls = urls;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _extractedText = '';
      _extractedEmails = [];
      _extractedPhones = [];
      _extractedUrls = [];
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery OCR'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearImage,
              tooltip: 'Clear',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker buttons
              if (_selectedImage == null) ...[
                const SizedBox(height: 20),
                const Icon(
                  Icons.image_search,
                  size: 80,
                  color: Colors.purple,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select an Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose from gallery or capture a new photo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
              ],

              if (_selectedImage == null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),

              // Selected image display
              if (_selectedImage != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Processing indicator
              if (_isProcessing)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Processing image...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

              // Extracted text display
              if (_extractedText.isNotEmpty && !_isProcessing) ...[
                _buildSectionHeader('Extracted Text', Icons.text_fields),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_extractedText.split('\n').length} lines detected',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () => _copyToClipboard(_extractedText),
                              tooltip: 'Copy all text',
                            ),
                          ],
                        ),
                        const Divider(),
                        SelectableText(
                          _extractedText,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Structured data extraction
              if (_extractedEmails.isNotEmpty ||
                  _extractedPhones.isNotEmpty ||
                  _extractedUrls.isNotEmpty) ...[
                _buildSectionHeader('Extracted Data', Icons.auto_awesome),
                const SizedBox(height: 10),

                if (_extractedEmails.isNotEmpty)
                  _buildDataCard(
                    'Emails',
                    Icons.email,
                    _extractedEmails,
                    Colors.blue,
                  ),

                if (_extractedPhones.isNotEmpty)
                  _buildDataCard(
                    'Phone Numbers',
                    Icons.phone,
                    _extractedPhones,
                    Colors.green,
                  ),

                if (_extractedUrls.isNotEmpty)
                  _buildDataCard(
                    'URLs',
                    Icons.link,
                    _extractedUrls,
                    Colors.orange,
                  ),
              ],

              if (_extractedText.isEmpty && _selectedImage != null && !_isProcessing)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No text detected in the image',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard(
      String title,
      IconData icon,
      List<String> items,
      Color color,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () => _copyToClipboard(item),
                    tooltip: 'Copy',
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}