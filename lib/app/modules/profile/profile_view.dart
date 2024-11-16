import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:prak_mobile/app/controller/auth_controller/storage_controller.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final StorageController _storageController = StorageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(color: Color(0xFFCDE7BE)
          ),
        ),
        backgroundColor: Color(0xFF181919), // Background
        iconTheme: IconThemeData(
          color: Color(0xFFCDE7BE), // Warna Ikon
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Profil
            GestureDetector(
                onTap: () async {
                  final ImageSource? source = await showDialog<ImageSource>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Pilih Sumber Gambar'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, ImageSource.gallery),
                          child: Text('Galeri'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, ImageSource.camera),
                          child: Text('Kamera'),
                        ),
                      ],
                    ),
                  );
                  if (source != null) {
                    _storageController.pickImage(source);
                  }
                },
                child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey.shade300,
                child: Obx(() {
                  return _storageController.isImageLoading.value
                      ? const CircularProgressIndicator()
                      : _storageController.selectedImagePath.value == ''
                      ? const Text('No image selected')
                      : ClipOval(
                    child: Image.file(
                        File(_storageController.selectedImagePath.value),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                    ),
                  );
                }),
              )
            ),
            SizedBox(height: 16),
            Text(
              'Tap to change profile picture',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 32),
            // Informasi Profil
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Save Changes', 
                style: TextStyle(color: Color(0xFF181919)
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCDE7BE), // Warna Button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
