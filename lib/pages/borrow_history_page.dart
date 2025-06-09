import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/borrow_provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({Key? key}) : super(key: key);

  @override
  State<BorrowHistoryPage> createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      Future.microtask(() => context.read<BorrowProvider>().getBorrowHistory(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: Consumer<BorrowProvider>(
        builder: (context, borrowProvider, _) {
          if (borrowProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (borrowProvider.errorMessage != null) {
            return Center(child: Text(borrowProvider.errorMessage!));
          }
          if (borrowProvider.borrowLogs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat peminjaman.'));
          }
          return ListView.builder(
            itemCount: borrowProvider.borrowLogs.length,
            itemBuilder: (context, index) {
              final log = borrowProvider.borrowLogs[index];
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(log.bookTitle),
                subtitle: Text(
                  'Dipinjam: ${log.borrowedAt != null ? DateFormat('dd MMM yyyy, HH:mm').format(log.borrowedAt!) : '-'}',
                ),
                trailing: Text(
                  log.returned ? 'Dikembalikan' : 'Belum',
                  style: TextStyle(color: log.returned ? Colors.green : Colors.orange),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 