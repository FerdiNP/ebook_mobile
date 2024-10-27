import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class AddBooksPage extends StatefulWidget {
  @override
  _AddBooksPageState createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String id = '';
  String title = '';
  String author = '';
  String description = '';
  String genre = '';
  DateTime? publicationDate;
  String coverImageUrl = '';
  String fileUrl = '';
  int pages = 0;
  String language = '';
  File? _coverImageFile; // To store the picked cover image file
  File? _uploadedFile; // To store the picked file for upload
  bool _isUploading = false; // To prevent double uploads
  bool _isLoading = false; // To show loading indicator

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null) {
      id = args['id'] ?? '';
      title = args['title'] ?? '';
      author = args['author'] ?? '';
      description = args['description'] ?? '';
      genre = args['genre'] ?? '';
      coverImageUrl = args['coverImageUrl'] ?? '';
      fileUrl = args['fileUrl'] ?? '';
      pages = args['pages'] ?? 0;
      language = args['language'] ?? '';
      publicationDate = args['publicationDate'] ?? DateTime.now();
    }
  }

  Future<void> _pickCoverImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImageFile = File(pickedFile.path);
        print("Picked cover image path: ${pickedFile.path}"); // Debugging
      });
    }
  }

  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Change if you need a different file type
    if (pickedFile != null) {
      setState(() {
        _uploadedFile = File(pickedFile.path);
        print("Picked file path: ${pickedFile.path}"); // Debugging
      });
    }
  }

  Future<String> _uploadFile(File file, String folder) async {
    final storageRef = FirebaseStorage.instance.ref().child('$folder/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(file);
    await uploadTask;

    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (publicationDate == null) {
        Get.snackbar('Error', 'Please select a publication date.');
        return;
      }

      setState(() {
        _isLoading = true; // Start loading indicator
      });

      try {
        if (_coverImageFile != null && !_isUploading) {
          _isUploading = true; // Prevent double uploads
          coverImageUrl = await _uploadFile(_coverImageFile!, 'covers');
          print("Cover image uploaded to: $coverImageUrl");
        }

        if (_uploadedFile != null && !_isUploading) {
          _isUploading = true; // Prevent double uploads
          fileUrl = await _uploadFile(_uploadedFile!, 'files');
          print("File uploaded to: $fileUrl");
        }

        if (id.isNotEmpty) {
          await FirebaseFirestore.instance.collection('books').doc(id).update({
            'title': title,
            'author': author,
            'description': description,
            'genre': genre,
            'publicationDate': Timestamp.fromDate(publicationDate!),
            'coverImageUrl': coverImageUrl,
            'fileUrl': fileUrl,
            'pages': pages,
            'language': language,
          });
          Get.snackbar('Success', 'Book updated successfully!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.lightGreenAccent);
        } else {
          await FirebaseFirestore.instance.collection('books').add({
            'title': title,
            'author': author,
            'description': description,
            'genre': genre,
            'publicationDate': Timestamp.fromDate(publicationDate!),
            'coverImageUrl': coverImageUrl,
            'fileUrl': fileUrl,
            'pages': pages,
            'language': language,
          });
          Get.snackbar('Success', 'Book added successfully!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.lightGreenAccent);
        }

        Get.offAndToNamed(Routes.MANAGE_BOOKS);
      } catch (e) {
        Get.snackbar('Error', 'Failed to save book: $e');
      } finally {
        setState(() {
          _isLoading = false; // Stop loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          id.isNotEmpty ? 'Edit Book' : 'Add Book',
          style: const TextStyle(
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back(); // Navigate back
          },
        ),
      ),
      body: Stack( // Use Stack for overlaying loading indicator
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextFormField('Title', title, (value) => title = value ?? ''),
                        const SizedBox(height: 12),
                        _buildTextFormField('Author', author, (value) => author = value ?? ''),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          'Description',
                          description,
                              (value) => description = value ?? '',
                          maxLines: 5, // Allow for more lines
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField('Genre', genre, (value) => genre = value ?? ''),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          'Pages',
                          pages > 0 ? pages.toString() : '',
                              (value) => pages = int.tryParse(value ?? '') ?? 0,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField('Language', language, (value) => language = value ?? ''),
                        const SizedBox(height: 12),
                        _selectPublicationDate(context), // Publication date field
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickCoverImage,
                          child: _buildUploadField('Cover Image URL', coverImageUrl, _coverImageFile), // Pass _coverImageFile
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickFile,
                          child: _buildUploadField('File URL', fileUrl, _uploadedFile), // Pass _coverImageFile
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              backgroundColor: Colors.teal[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _saveBook,
                            child: Text(
                              id.isNotEmpty ? 'Update Book' : 'Add Book',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black54, // Optional: add a background color
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField(String label, String initialValue, Function(String?) onSaved, {TextInputType keyboardType = TextInputType.text, int? maxLines}) {
    return TextFormField(
      initialValue: initialValue,
      style: const TextStyle(fontSize: 16),
      maxLines: maxLines ?? 1, // Allow for multiple lines if specified
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _selectPublicationDate(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: publicationDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            publicationDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              publicationDate != null
                  ? '${publicationDate!.toLocal().toString().split(' ')[0]}'
                  : 'Select Publication Date',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Container _buildUploadField(String label, String url, File? imageFile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          // Check if a local image file is picked
          if (imageFile != null)
            Image.file(
              imageFile,
              fit: BoxFit.cover, // Maintain aspect ratio
            )
          // If no local image, check for a URL
          else if (url.isNotEmpty)
          // Use Image.network with a default placeholder for error handling
            Image.network(
              url,
              fit: BoxFit.cover, // Maintain aspect ratio
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child; // When image is fully loaded
                return Center(
                  child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null),
                ); // Show loading indicator while image loads
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Text('Failed to load image', style: TextStyle(color: Colors.grey)); // Error handling
              },
            )
          // If neither image is available, show a standard TextField
          else
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'No file chosen',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

}
