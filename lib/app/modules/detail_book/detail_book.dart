import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Get.arguments as DocumentSnapshot;
    final title = book['title'] ?? 'No Title';
    final imageUrl = book['coverImageUrl'] ?? 'default_image_url';
    final author = book['author'] ?? 'Unknown Author';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offNamed(Routes.HOME);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Blur Background
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 350,
                  color: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                      ],
                    ),
                  ),
                ),
                // Book Cover Image
                Positioned(
                  top: 50,
                  left: MediaQuery.of(context).size.width / 2 - 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      width: 200,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Buttons
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50), // Add horizontal padding
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.book, color: Colors.white),
                            label: const Text('Read', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF232538),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.play_circle, color: Colors.white),
                            label: const Text('Play', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF232538),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Book Description and Other Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Chips and Chapter List
                  Row(
                    children: [
                      Chip(
                        label: Text('Personal growth'),
                        backgroundColor: Colors.grey.shade800,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Culture & Society'),
                        backgroundColor: Colors.grey.shade800,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Fiction'),
                        backgroundColor: Colors.grey.shade800,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '56 Chapters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ChapterTile(number: '01', title: 'Introduction', isLocked: true),
                  ChapterTile(number: '02', title: 'Creating the Vision', isLocked: true),
                  ChapterTile(number: '03', title: 'End', isLocked: true),
                  const SizedBox(height: 20),
                  // Author Summary
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile-picture.png'),
                    ),
                    title: Text(
                      author,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'A FranklinCovey Title\nManagers who want to create positive work environments.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Similar Books
                  Text(
                    'Similar Books',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SimilarBookCard(
                          imageUrl: 'assets/images/cover.png',
                          title: 'Explore your Creative Side',
                        ),
                        SimilarBookCard(
                          imageUrl: 'assets/images/cover.png',
                          title: 'Futurama',
                        ),
                        SimilarBookCard(
                          imageUrl: 'assets/images/cover.png',
                          title: 'The Good Guy',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chapter Tile Widget
class ChapterTile extends StatelessWidget {
  final String number;
  final String title;
  final bool isLocked;

  const ChapterTile({
    required this.number,
    required this.title,
    required this.isLocked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(
        number,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(
        isLocked ? Icons.lock : Icons.play_arrow,
        color: isLocked ? Colors.grey : Colors.green,
      ),
    );
  }
}

// Similar Book Card Widget
class SimilarBookCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const SimilarBookCard({
    required this.imageUrl,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imageUrl,
            width: 100,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
