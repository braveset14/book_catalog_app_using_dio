import 'package:equatable/equatable.dart';
import '../../models/book.dart';

// This is the base event class.
abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

// Event to load all books.
class LoadBooksEvent extends BookEvent {}

// Event to add a new book.

class AddBookEvent extends BookEvent {
  final Book book;
  const AddBookEvent({required this.book});
  @override
  List<Object?> get props => [book];
}

// Event to update a book

class UpdateBookEvent extends BookEvent {
  final int id;
  final Book book;
  const UpdateBookEvent({required this.id, required this.book});
  @override
  List<Object?> get props => [id, book];
}

// Event to delete a book

class DeleteBookEvent extends BookEvent {
  final int id;
  const DeleteBookEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
