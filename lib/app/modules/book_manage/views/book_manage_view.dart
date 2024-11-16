import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class ManageBooksPage extends StatefulWidget {
  @override
  _ManageBooksPageState createState() => _ManageBooksPageState();
}

class _ManageBooksPageState extends State<ManageBooksPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _booksCollection = FirebaseFirestore.instance.collection('books');

  Future<void> _deleteBook(String bookId) async {
    try {
      await _booksCollection.doc(bookId).delete();
      setState(() {}); // Refresh list after deleting the
      Get.snackbar(
        'Success',
        'Book deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete book: $e',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Books',
          style: TextStyle(
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.offAllNamed(Routes.ACCOUNT);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed(Routes.ADD_BOOKS);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _booksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading books',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final bookId = book.id; // Accessing the document ID correctly

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                color: const Color(0xFF272828),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Displaying the book cover image
                      if (book['coverImageUrl'] != null &&
                          book['coverImageUrl'].isNotEmpty)
                        Image.network(
                          book['coverImageUrl'],
                          height: 100, // Set the height as per your design
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 8.0),
                      // Space between image and title
                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Author: ${book['author']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Description: ${book['description']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        maxLines: 2, // Limit to 2 lines
                        overflow: TextOverflow
                            .ellipsis, // Show ellipsis (...) if the text is too long
                      ),
                      Text(
                        'Genre: ${book['genre']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Pages: ${book['pages']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Language: ${book['language']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Publication Date: ${DateFormat('dd-MM-yyyy').format((book['publicationDate'] as Timestamp).toDate())}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.greenAccent),
                          onPressed: () {
                            // Pass the entire book object to the edit page
                            Get.toNamed(Routes.ADD_BOOKS, arguments: {
                              'id': bookId,
                              // Use the document ID correctly here
                              'title': book['title'],
                              'author': book['author'],
                              'description': book['description'],
                              'genre': book['genre'],
                              'coverImageUrl': book['coverImageUrl'],
                              'fileUrl': book['fileUrl'],
                              'pages': book['pages'],
                              'language': book['language'],
                              'publicationDate':
                                  (book['publicationDate'] as Timestamp)
                                      .toDate(),
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Confirm before deletion
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Buku'),
                                content: const Text(
                                    'Apakah Anda yakin ingin menghapus buku ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteBook(bookId);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Uncomment the code below to enable detail navigation
                    // Get.toNamed(Routes.BOOK_DETAIL, arguments: bookId);
                  },
                ),
              );
            },
          );
        },
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    );
  }
}
