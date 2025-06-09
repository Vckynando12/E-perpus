import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/borrow_provider.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      if (!mounted) return;
      context.read<UserProvider>().fetchAllUsers();
      context.read<BorrowProvider>().getAllBorrowLogs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'User List'),
            Tab(text: 'Log Peminjaman'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // User List
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              if (userProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userProvider.errorMessage != null) {
                return Center(child: Text(userProvider.errorMessage!));
              }
              return ListView.builder(
                itemCount: userProvider.users.length,
                itemBuilder: (context, index) {
                  final user = userProvider.users[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.email),
                    subtitle: Text('Role: ${user.role}'),
                  );
                },
              );
            },
          ),
          // Log Peminjaman
          Consumer<BorrowProvider>(
            builder: (context, borrowProvider, _) {
              if (borrowProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (borrowProvider.errorMessage != null) {
                return Center(child: Text(borrowProvider.errorMessage!));
              }
              if (borrowProvider.borrowLogs.isEmpty) {
                return const Center(child: Text('Belum ada log peminjaman.'));
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
        ],
      ),
    );
  }
} 