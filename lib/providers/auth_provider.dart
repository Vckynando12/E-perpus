import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  // User data
  String? userId;
  String? userEmail;
  String? userRole;
  bool isLoading = false;
  String? errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (email == 'admin@admin.com' && password == 'admin123') {
        // Login admin
        UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
        userId = cred.user?.uid;
        userEmail = email;
        userRole = 'admin';
        // Pastikan data admin ada di Firestore
        await _firestore.collection('users').doc(userId).set({
          'email': email,
          'role': 'admin',
        }, SetOptions(merge: true));
      } else {
        // Login user biasa
        UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
        userId = cred.user?.uid;
        userEmail = email;
        // Ambil role dari Firestore
        final doc = await _firestore.collection('users').doc(userId).get();
        userRole = doc.data()?['role'] ?? 'user';
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan.';
    }
    isLoading = false;
    notifyListeners();
  }

  // Register
  Future<void> register(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      userId = cred.user?.uid;
      userEmail = email;
      userRole = 'user';
      // Simpan ke Firestore
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'role': 'user',
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan.';
    }
    isLoading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    userId = null;
    userEmail = null;
    userRole = null;
    notifyListeners();
  }
} 