import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/detail_book.dart';

class GoogleBooksService {
  final String _baseUrl = "https://www.googleapis.com/books/v1/volumes";
  final String apiKey = 'AIzaSyCaQ8qXg91WLETWzNXo5ZJeB8D091fFA_U'; // Tambahkan API key di sini

  // Mengambil daftar buku dan memetakan ke model Book
  Future<List<Book>> fetchBooks(String query) async {
    // Tambahkan API key ke dalam URL
    final response = await http.get(Uri.parse("$_baseUrl?q=$query&key=$apiKey"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List books = data['items'] ?? [];

      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception("Failed to load books");
    }
  }

  // Mengambil detail buku berdasarkan ID dan memetakan ke model BookDetail
  Future<BookDetail> fetchBookDetails(String bookId) async {
    // Tambahkan API key ke dalam URL
    final response = await http.get(Uri.parse("$_baseUrl/$bookId?key=$apiKey"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BookDetail.fromJson(data);
    } else {
      throw Exception("Failed to load book details");
    }
  }
}
