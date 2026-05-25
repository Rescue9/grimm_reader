import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'views/book_grid_view.dart'; // Added import for the grid view

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Grimm Reader',
          debugShowCheckedModeBanner: false,
          
          theme: ThemeData(
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(
              seedColor: Colors.teal, 
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          
          // Swapped out the old placeholder Center text for our modern grid view
          home: const BookGridView(), 
        );
      },
    );
  }
}