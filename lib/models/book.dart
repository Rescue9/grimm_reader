class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String? downloadUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    this.downloadUrl,
  });

  factory Book.fromXml(Map<String, String> data) {
    return Book(
      id: data['id'] ?? '',
      title: data['title'] ?? 'Unknown Title',
      author: data['author'] ?? 'Unknown Author',
      description: data['description'] ?? 'No description available.',
      coverUrl: data['coverUrl'] ?? '',
      downloadUrl: data['downloadUrl'],
    );
  }
}