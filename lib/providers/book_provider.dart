import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Book {
  final String id;
  final String title;
  final String author;
  final String year;
  final int? coverId;

  Book({required this.id, required this.title, required this.author, required this.year, this.coverId});
}

class BookProvider extends ChangeNotifier {
  List<Book> books = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchBooks({String query = 'flutter'}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        books = (data['docs'] as List).map((doc) {
          return Book(
            id: doc['key'] ?? '',
            title: doc['title'] ?? '-',
            author: (doc['author_name'] != null && doc['author_name'].isNotEmpty) ? doc['author_name'][0] : '-',
            year: doc['first_publish_year']?.toString() ?? '-',
            coverId: doc['cover_i'],
          );
        }).toList();
      } else {
        errorMessage = 'Gagal mengambil data buku.';
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan.';
    }
    isLoading = false;
    notifyListeners();
  }
} 