import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/voice_controller.dart';
import 'package:prak_mobile/app/data/models/book.dart';
import 'package:prak_mobile/app/data/services/http_controller.dart';
import 'book_detail_page.dart';

const _mainColor = Color(0xFFCDE7BE);
const _backgroundColor = Color(0xFF181919);
const _textColor = Colors.white;

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final GoogleBooksService _booksService = GoogleBooksService();
  final VoiceController _voiceController = Get.put(VoiceController()); // Ensure the controller is initialized
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _loading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Fetch books on load

    // Update search when voice input is recognized
    _voiceController.text.listen((recognizedText) {
      print("Voice recognized: $recognizedText");  // Debugging voice input
      _searchController.text = recognizedText;
      _filterBooks(recognizedText); // Filter results based on voice input
    });
  }

  // Fetch books from the API
// Fetch books from the API based on search query
  void _fetchBooks([String query = "Stephen King"]) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final books = await _booksService.fetchBooks(query);
      setState(() {
        _books = books;
        _filteredBooks = books; // Set the books for initial display
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load books: $error";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

// Filter books based on search query (either typed or voice input)
  void _filterBooks(String query) {
    if (query.isEmpty) {
      _fetchBooks(); // If search query is empty, fetch all books again
    } else {
      _fetchBooks(query); // Fetch books based on search query
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Books", style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textColor),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => TextField(
              controller: _searchController,
              style: const TextStyle(color: _textColor),
              decoration: InputDecoration(
                hintText: 'Search for books...',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: _textColor),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _filterBooks(_searchController.text); // Update books based on query
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _voiceController.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: _voiceController.isListening.value
                            ? Colors.red
                            : _textColor,
                      ),
                      onPressed: () {
                        if (_voiceController.isListening.value) {
                          _voiceController.stopListening();
                        } else {
                          _voiceController.startListening();
                        }
                      },
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _mainColor),
                ),
              ),
              onChanged: (value) {
                _filterBooks(value);
              },
            )),
          ),
          // Display filtered books
          Expanded(
            child: _loading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: _mainColor),
                  const SizedBox(height: 16),
                  const Text("Loading books...", style: TextStyle(color: _textColor)),
                ],
              ),
            )
                : _errorMessage != null
                ? Center(
              child: Text(_errorMessage!, style: TextStyle(color: _textColor)),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.6,
                ),
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];

                  return Card(
                    elevation: 4,
                    color: _backgroundColor,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(bookId: book.id),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Book image
                          Expanded(
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: book.thumbnail.isNotEmpty
                                    ? Image.network(
                                  book.thumbnail,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  color: _mainColor,
                                  child: const Icon(Icons.book, size: 50, color: _textColor),
                                ),
                              ),
                            ),
                          ),
                          // Book title
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _textColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Icon(Icons.arrow_forward_ios, size: 16, color: _textColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
