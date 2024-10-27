import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/detail_book.dart';
import '../../data/services/http_controller.dart';
import 'book_webview.dart';

const _mainColor = Color(0xFFCDE7BE);
const _backgroundColor = Color(0xFF181919);
const _textColor = Colors.white;

class BookDetailPage extends StatelessWidget {
  final String bookId;
  final GoogleBooksService _booksService = GoogleBooksService();

  BookDetailPage({required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details", style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: FutureBuilder<BookDetail>(
        future: _booksService.fetchBookDetails(bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _mainColor));
          }

          if (snapshot.hasError) {
            return Center(  child: Text("Error loading book details", style: TextStyle(color: _textColor)));
          }

          final book = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.thumbnail.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.thumbnail,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "By: ${book.authors}",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[400],
                  ),
                ),
                Divider(height: 30, color: Colors.grey),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  book.description,
                  style: TextStyle(fontSize: 16, color: _textColor),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => BookDetailWebView(bookId: book.id)); // Valid URL
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _mainColor,
                    ),
                    child: Text("Read eBook"),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
