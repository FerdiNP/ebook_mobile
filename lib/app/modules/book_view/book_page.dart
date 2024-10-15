import 'package:flutter/material.dart';
import 'package:prak_mobile/app/data/models/book.dart';
import 'package:prak_mobile/app/data/services/http_controller.dart';
import '../../data/models/detail_book.dart';
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
  List<Book> _books = [];
  bool _loading = false;
  String? _errorMessage; // Menyimpan pesan kesalahan

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() async {
    setState(() {
      _loading = true;
      _errorMessage = null; // Reset pesan kesalahan
    });

    try {
      final books = await _booksService.fetchBooks("Light Novel");
      setState(() {
        _books = books;
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load books: $error"; // Simpan pesan kesalahan
      });
    } finally {
      setState(() {
        _loading = false;
      });
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
      body: _loading
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
          : _errorMessage != null // Tampilkan pesan kesalahan jika ada
          ? Center(child: Text(_errorMessage!, style: TextStyle(color: _textColor)))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6, // Rasio tinggi dan lebar
          ),
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];

            return Card(
              elevation: 4,
              color: _backgroundColor,
              child: GestureDetector( // Menggunakan GestureDetector
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
                    // Gambar buku di tengah
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
                    // Judul buku di bawah gambar
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
                        textAlign: TextAlign.center, // Pusatkan judul
                      ),
                    ),
                    // Ikon panah
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
    );
  }
}
