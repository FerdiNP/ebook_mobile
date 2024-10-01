import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
              onTap: _pickImage, // Tap Ubah Gambar
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/images/profile-picture.png') as ImageProvider, // Gambar default
              ),
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
