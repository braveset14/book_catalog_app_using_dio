import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/book.dart';
import '../../services/api_service.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final ApiService _apiService = ApiService();
  List<Book> _books = [];

  BookBloc() : super(BookLoadingState()) {
    // These are event handlers for all the events that can occur.
    on<LoadBooksEvent>(_onLoadBooks);
    on<AddBookEvent>(_onAddBook);
    on<UpdateBookEvent>(_onUpdateBook);
    on<DeleteBookEvent>(_onDeleteBook);
  }

  // An event handler to handle loadbook event
  Future<void> _onLoadBooks(
      LoadBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoadingState());
    try {
      _books = await _apiService.fetchBooks();
      emit(BookLoadedState(books: _books));
    } catch (e) {
      emit(BookErrorState(message: e.toString()));
    }
  }

  // An event handler to handle addbook event
  Future<void> _onAddBook(AddBookEvent event, Emitter<BookState> emit) async {
    emit(BookLoadingState());
    try {
      final newBook = await _apiService.createBook(event.book);
      if (newBook.id != null) {
        _books.insert(0, newBook);
      } else {
        final bookWithId = Book(
          id: DateTime.now().millisecondsSinceEpoch,
          title: event.book.title,
          author: event.book.author,
          condition: event.book.condition,
          price: event.book.price,
        );
        _books.insert(0, bookWithId);
      }
      emit(BookLoadedState(books: _books));
    } catch (e) {
      emit(BookErrorState(message: 'Failed to add book: ${e.toString()}'));
    }
  }

  // An event handler to handle updatebook event
  Future<void> _onUpdateBook(
      UpdateBookEvent event, Emitter<BookState> emit) async {
    emit(BookLoadingState());
    try {
      await _apiService.updateBook(event.id, event.book);
      final index = _books.indexWhere((b) => b.id == event.id);
      if (index != -1) {
        _books[index] = event.book;
      }
      emit(BookLoadedState(books: _books));
    } catch (e) {
      emit(BookErrorState(message: 'Failed to update book: ${e.toString()}'));
    }
  }

  // An event handler to handle deletebook event
  Future<void> _onDeleteBook(
      DeleteBookEvent event, Emitter<BookState> emit) async {
    emit(BookLoadingState());

    // if (event.id == null) {
    //   print('Cannot delete: ID is null');
    //   emit(BookLoadedState(books: _books));
    //   return;
    // }

    try {
      await _apiService.deleteBook(event.id);
      // Remove from local list
      _books.removeWhere((book) => book.id == event.id);
      emit(BookLoadedState(books: _books));
    } catch (e) {
      emit(BookErrorState(message: 'Failed to add book: ${e.toString()}'));
    }
  }
}
