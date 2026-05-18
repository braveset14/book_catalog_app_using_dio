import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';
import '../widgets/book_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(LoadBooksEvent());
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookBloc>().add(DeleteBookEvent(id: id));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Catalog'),
        centerTitle: true,
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          // Loading state
          if (state is BookLoadingState) {
            return const LoadingWidget();
          }

          // Error state
          if (state is BookErrorState) {
            return ErrorMessageWidget(
              message: state.message,
              onRetry: () {
                context.read<BookBloc>().add(LoadBooksEvent());
              },
            );
          }

          // Loaded state
          if (state is BookLoadedState) {
            if (state.books.isEmpty) {
              return const Center(
                child: Text('No books. Tap + to add'),
              );
            }

            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return BookCard(
                  book: book,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditScreen(book: book),
                      ),
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(context, book.id);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add your book'),
      ),
    );
  }
}
