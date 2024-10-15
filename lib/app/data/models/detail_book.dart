class BookDetail {
  final String id;
  final String title;
  final String authors;
  final String description;
  final String thumbnail;
  final String url;

  BookDetail({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.url,
  });

  // Factory method for creating an instance from JSON
  factory BookDetail.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final previewLink = volumeInfo['previewLink'] ?? '';

    // Ensure the URL has a valid scheme (like https://)
    final completeUrl = previewLink.startsWith('http')
        ? previewLink
        : 'https://www.google.co.id/books/edition/_/$previewLink';

    return BookDetail(
      id: json['id'],
      title: volumeInfo['title'] ?? 'No title',
      authors: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown author',
      description: volumeInfo['description'] ?? 'No description available',
      thumbnail: imageLinks['thumbnail'] ?? '',
      url: completeUrl, // Use the complete URL here
    );
  }
}
