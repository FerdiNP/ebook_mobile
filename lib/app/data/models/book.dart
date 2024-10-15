class Book {
  final String id;
  final String title;
  final String thumbnail;
  final String url; // Properti untuk URL eBook

  Book({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.url, // Tambahkan parameter URL
  });

  // Factory method untuk membuat instance Book dari JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final previewLink = volumeInfo['previewLink'] ?? ''; // Mendapatkan URL dari previewLink

    // Validasi URL untuk memastikan format yang benar
    final completeUrl = previewLink.startsWith('http')
        ? previewLink
        : 'https://www.google.co.id/books/edition/_/$previewLink';

    return Book(
      id: json['id'] ?? 'Unknown ID', // Berikan nilai default jika tidak ada ID
      title: volumeInfo['title'] ?? 'No title', // Berikan nilai default
      thumbnail: imageLinks['thumbnail'] ?? '', // Berikan nilai default
      url: completeUrl, // Inisialisasi URL untuk eBook Viewer
    );
  }
}
