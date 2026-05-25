import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'opds_service.dart';
import '../models/book.dart';

// 1. Instantiates a single instance of our service to reuse across the app
final opdsServiceProvider = Provider<OpdsService>((ref) {
  return OpdsService();
});

// 2. A FutureProvider specifically designed to manage asynchronous data streams.
// Change 'http://YOUR_SERVER_IP:6060/opds' to match your actual Grimmory instance address!
final grimmoryBooksProvider = FutureProvider<List<Book>>((ref) async {
  final service = ref.watch(opdsServiceProvider);
  
  const grimmoryUrl = 'https://library.buskov.me/api/v1/opds'; 
  
  // Pass your credentials here!
  return service.fetchCatalog(
    grimmoryUrl,
    username: 'test',
    password: 'test',
  );
});