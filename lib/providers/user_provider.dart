import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String role;

  AppUser({required this.id, required this.email, required this.role});
}

class UserProvider extends ChangeNotifier {
  List<AppUser> users = [];
  bool isLoading = false;
  String? errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAllUsers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final query = await _firestore.collection('users').get();
      users = query.docs.map((doc) {
        final data = doc.data();
        return AppUser(
          id: doc.id,
          email: data['email'] ?? '-',
          role: data['role'] ?? '-',
        );
      }).toList();
    } catch (e) {
      errorMessage = 'Gagal mengambil data user.';
    }
    isLoading = false;
    notifyListeners();
  }
} 