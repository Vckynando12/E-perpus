import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'providers/auth_provider.dart';
import 'pages/home_page.dart';
import 'providers/book_provider.dart';
import 'providers/borrow_provider.dart';
import 'pages/borrow_history_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'providers/user_provider.dart';
// Import halaman dan provider (nanti dibuat)
// import 'pages/home_page.dart';
// import 'pages/admin_dashboard_page.dart';
// import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => BorrowProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Tambahkan provider lain jika sudah dibuat
      ],
      child: MaterialApp(
        title: 'E-Perpustakaan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/history': (context) => const BorrowHistoryPage(),
          '/admin': (context) => const AdminDashboardPage(),
          // '/admin': (context) => AdminDashboardPage(),
        },
      ),
    );
  }
}
