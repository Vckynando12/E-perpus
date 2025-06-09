import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/borrow_provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<BookProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Buku')),
      body: Consumer3<BookProvider, BorrowProvider, AuthProvider>(
        builder: (context, bookProvider, borrowProvider, authProvider, _) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (bookProvider.errorMessage != null) {
            return Center(child: Text(bookProvider.errorMessage!));
          }
          return ListView.builder(
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: book.coverId != null
                      ? Image.network(
                          'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
                          width: 50,
                          errorBuilder: (c, e, s) => const Icon(Icons.book),
                        )
                      : const Icon(Icons.book),
                  title: Text(book.title),
                  subtitle: Text('${book.author} • ${book.year}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: Navigasi ke detail buku
                        },
                        child: const Text('Baca Buku'),
                      ),
                      ElevatedButton(
                        onPressed: borrowProvider.isLoading
                            ? null
                            : () async {
                                await borrowProvider.pinjamBuku(
                                  userId: authProvider.userId ?? '',
                                  userEmail: authProvider.userEmail ?? '',
                                  bookId: book.id,
                                  bookTitle: book.title,
                                );
                                if (!mounted) return;
                                if (borrowProvider.successMessage != null) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(borrowProvider.successMessage!)),
                                  );
                                } else if (borrowProvider.errorMessage != null) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(borrowProvider.errorMessage!), backgroundColor: Colors.red),
                                  );
                                }
                              },
                        child: borrowProvider.isLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Pinjam'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 