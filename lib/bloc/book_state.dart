import 'package:equatable/equatable.dart';
import '../../models/book.dart';

// Base State
abstract class BookState extends Equatable {
  const BookState();
  @override
  List<Object?> get props => [];
}

// Loading state
class BookLoadingState extends BookState {}

// Loaded state (has books)
class BookLoadedState extends BookState {
  final List<Book> books;
  const BookLoadedState({required this.books});
  @override
  List<Object?> get props => [books];
}

// Error state
class BookErrorState extends BookState {
  final String message;
  const BookErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
