import 'dart:convert'; // Added for utf8 and base64 encoding
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/book.dart';

class OpdsService {
  // Added optional username and password parameters
  Future<List<Book>> fetchCatalog(String urlString, {String? username, String? password}) async {
    try {
      final url = Uri.parse(urlString);
      
      // Build headers map
      final Map<String, String> headers = {};
      
      // If credentials are provided, inject the Basic Auth header
      if (username != null && password != null) {
        final bytes = utf8.encode('$username:$password');
        final base64Credentials = base64.encode(bytes);
        headers['Authorization'] = 'Basic $base64Credentials';
      }

      // Pass the headers along with the GET request
      final response = await http.get(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Server returned status ${response.statusCode}');
      }

      final document = XmlDocument.parse(response.body);
      final List<Book> books = [];

      for (var entry in document.findAllElements('entry')) {
        String id = entry.findElements('id').firstOrNull?.innerText ?? '';
        String title = entry.findElements('title').firstOrNull?.innerText ?? 'Unknown Title';
        String author = entry.findAllElements('name').firstOrNull?.innerText ?? 'Unknown Author';
        String description = entry.findElements('summary').firstOrNull?.innerText ?? 
                             entry.findElements('content').firstOrNull?.innerText ?? 
                             'No description available.';

        String coverUrl = '';
        String? downloadUrl;

        for (var link in entry.findElements('link')) {
          final rel = link.getAttribute('rel');
          final href = link.getAttribute('href') ?? '';

          if (rel != null && (rel.contains('image') || rel == 'http://opds-spec.org/image')) {
            coverUrl = href;
          } else if (rel == 'http://opds-spec.org/acquisition') {
            downloadUrl = href;
          }
        }

        books.add(Book.fromXml({
          'id': id,
          'title': title,
          'author': author,
          'description': description,
          'coverUrl': coverUrl,
          'downloadUrl': downloadUrl ?? '',
        }));
      }

      return books;
    } catch (e) {
      throw Exception('Failed to parse Grimmory feed: $e');
    }
  }
}