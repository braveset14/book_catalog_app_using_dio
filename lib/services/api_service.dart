import 'package:dio/dio.dart';
import '../models/book.dart';

class ApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String endpoint = '/posts';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  // Function to fetch books from the api.

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await _dio.get('$endpoint?_limit=15');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function to add a new book.

  Future<Book> createBook(Book book) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: book.toJson(),
      );

      if (response.statusCode == 201) {
        return Book(
          id: response.data['id'] ?? 0,
          title: book.title,
          description: book.description,
          author: book.author,
          condition: book.condition,
          price: book.price,
        );
      } else {
        throw Exception('Failed to create book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function to update a book

  Future<Book> updateBook(int id, Book book) async {
    try {
      final response = await _dio.put(
        '$endpoint/$id',
        data: book.toJson(),
      );

      if (response.statusCode == 200) {
        return Book(
          id: id,
          title: book.title,
          description: book.description,
          author: book.author,
          condition: book.condition,
          price: book.price,
        );
      } else {
        throw Exception('Failed to update book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function to delete a book.
  Future<void> deleteBook(int id) async {
    try {
      final response = await _dio.delete('$endpoint/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete book');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
