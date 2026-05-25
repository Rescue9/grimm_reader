import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/books_provider.dart';
import 'book_card.dart';

class BookGridView extends ConsumerWidget {
  const BookGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the grimmoryBooksProvider. Riverpod handles caching automatically.
    final booksAsync = ref.watch(grimmoryBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grimm Library'),
        centerTitle: false,
        actions: [
          // Refresh button allowing users to manually force-reload the OPDS feed
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(grimmoryBooksProvider),
          ),
        ],
      ),
      // .when cleanly pattern-matches all 3 essential network states
      body: booksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error connecting to Grimmory:\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(grimmoryBooksProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Connection'),
                ),
              ],
            ),
          ),
        ),
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text('No books found in this Grimmory feed.'),
            );
          }

          // Renders a responsive grid layout
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180, // Sets maximum item width before creating a new column
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65, // Balances out the book aspect height ratio beautifully
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(book: book);
            },
          );
        },
      ),
    );
  }
}