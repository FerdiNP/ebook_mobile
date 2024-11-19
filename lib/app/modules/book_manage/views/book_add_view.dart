import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prak_mobile/app/controller/auth_controller/audio_controller.dart';
import 'package:prak_mobile/app/controller/auth_controller/storage_controller.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';

class AddBooksPage extends StatefulWidget {
  @override
  _AddBooksPageState createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  final StorageController _storageController = StorageController();
  final AudioController _audioController = Get.put(AudioController());
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String id = '';
  String title = '';
  String author = '';
  String description = '';
  String genre = '';
  DateTime? publicationDate;
  String coverImageUrl = '';
  String videoUrl = '';
  String audioUrl = '';
  String fileUrl = '';
  int pages = 0;
  String language = '';
  File? _coverImageFile;
  File? _videoFile;
  File? _audioFile;
  File? _uploadedFile;
  bool _isUploading = false;
  bool _isLoading = false;

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
      videoUrl = args['videoUrl'] ?? '';
      audioUrl = args['audioUrl'] ?? '';
      fileUrl = args['fileUrl'] ?? '';
      pages = args['pages'] ?? 0;
      language = args['language'] ?? '';
      publicationDate = args['publicationDate'] ?? DateTime.now();
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
          _isUploading = false;
        }

        // if (_uploadedFile != null && !_isUploading) {
        //   _isUploading = true; // Prevent double uploads
        //   fileUrl = await _uploadFile(_uploadedFile!, 'files');
        //   print("File uploaded to: $fileUrl");
        // }

        if (_videoFile != null && !_isUploading) {
          _isUploading = true; // Prevent double uploads
          videoUrl = await _uploadFile(_videoFile!, 'videos');
          print("Video uploaded to: $videoUrl");
          _isUploading = false;
        } else {
          print("Not Found");
        }

          if (_audioFile != null && !_isUploading) {
            _isUploading = true; // Prevent double uploads
            audioUrl = await _uploadFile(_audioFile!, 'audios');
            print("Audio uploaded to: $audioUrl");
            _isUploading = false;
          } else {
            print("Not Found");
          }

        if (id.isNotEmpty) {
          await FirebaseFirestore.instance.collection('books').doc(id).update({
            'title': title,
            'author': author,
            'description': description,
            'genre': genre,
            'publicationDate': Timestamp.fromDate(publicationDate!),
            'coverImageUrl': coverImageUrl,
            'videoUrl': videoUrl,
            'audioUrl': audioUrl,
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
            'videoUrl': videoUrl,
            'audioUrl': audioUrl,
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
      body: Stack(
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
                              final file = await _picker.pickImage(source: source);
                              if (file != null) {
                                setState(() {
                                  _coverImageFile = File(file.path);
                                });
                              }
                            }
                          },
                          child: _buildUploadImageField('Cover Image', coverImageUrl, _coverImageFile),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            final ImageSource? source = await showDialog<ImageSource>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Pilih Sumber Video'),
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
                              final file = await _picker.pickVideo(source: source);
                              if (file != null) {
                                setState(() {
                                  _videoFile = File(file.path);
                                  if (_videoFile != null) {
                                    _storageController.videoPlayerController = VideoPlayerController.file(_videoFile!)
                                      ..initialize().then((_) {
                                        setState(() {});
                                        _storageController.videoPlayerController!.play();
                                      });
                                  }
                                });
                              }
                            }
                          },
                          child: _buildUploadVideoField('Video File', videoUrl, _videoFile, _storageController.videoPlayerController),
                        ),
                        const SizedBox(height: 20),
                        // GestureDetector(
                        //   onTap: _pickFile,
                        //   child: _buildUploadField('File URL', fileUrl, _uploadedFile),
                        // ),
                        GestureDetector(
                          child: _buildUploadAudioField('Audio File', audioUrl, _audioFile, _audioController),
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
  Widget _buildUploadImageField(String label, String imageUrl, File? file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          height: 150,  // Fixed height for the box
          width: double.infinity,  // Make the box fill the available width
          color: Colors.grey[300],
          child: Center(  // Center the content inside the box
            child: file != null
                ? Image.file(
              file,
              fit: BoxFit.cover,
              height: 150,
            )
                : imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
            )
                : FittedBox(
              fit: BoxFit.scaleDown,  // Ensure the text is scaled down within the box
              child: Text(
                'No image selected',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadVideoField(String label, String videoUrl,File? file, VideoPlayerController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        // Dynamic sizing based on screen width and height
        controller != null && controller.value.isInitialized
            ? SizedBox(
          height: Get.height / 2.2,  // Adjust height dynamically based on screen size
          width: double.infinity,      // Set width dynamically based on screen width
          child: Card(
            child: Column(
              children: [
                // AspectRatio to maintain the correct video aspect ratio
                AspectRatio(
                  aspectRatio: 1,  // Aspect ratio of 1 for square video
                  child: VideoPlayer(controller),
                ),
                // Video progress indicator
                VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                ),
                // Play/Pause button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
            : (videoUrl.isNotEmpty || _videoFile != null)
            ? Container(
          height: 150,  // Set container height for video selected state
          width: double.infinity,  // Full width container
          color: Colors.grey[300],
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Video selected', textAlign: TextAlign.center),
            ),
          ),
        )
            : Container(
          height: 150,  // Set container height for no video selected
          width: double.infinity,  // Full width container
          color: Colors.grey[300],
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('No video selected', textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadAudioField(String label, String audioUrl,File? file, AudioController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        _audioFile == null && audioUrl.isEmpty
            ? Container(
          height: 150, // Tinggi container untuk teks placeholder
          width: double.infinity, // Lebar penuh
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'No audio file selected',
              textAlign: TextAlign.center,
            ),
          ),
        )
            : Column(
          children: <Widget>[
            Obx(() {
              return Slider(
                min: 0.0,
                max: _audioController.duration.value.inSeconds.toDouble(),
                value: _audioController.position.value.inSeconds.toDouble(),
                onChanged: (value) {
                  _audioController.seekAudio(Duration(seconds: value.toInt()));
                },
              );
            }),
            Obx(() {
              return Text(
                '${_formatDuration(_audioController.position.value)} / ${_formatDuration(_audioController.duration.value)}',
              );
            }),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _audioController.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (_audioController.isPlaying.value) {
                        _audioController.pauseAudio();
                      } else {
                        if (_audioFile != null || audioUrl.isNotEmpty) {
                          _audioController.playAudio(
                              _audioFile?.path ?? audioUrl);
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _audioController.stopAudio,
                  ),
                ],
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        Center(child:
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.audio,
              );
              if (result != null && result.files.single.path != null) {
                setState(() {
                  _audioFile = File(result.files.single.path!);
                });
                _audioController.setAudio(_audioFile!.path);
              }
            },
            child: const Text('Pick Audio File'),
          ),
        )
      ],
    );
  }


  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

}
