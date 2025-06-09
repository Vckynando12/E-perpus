import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowLog {
  final String id;
  final String bookTitle;
  final DateTime? borrowedAt;
  final bool returned;

  BorrowLog({required this.id, required this.bookTitle, this.borrowedAt, required this.returned});
}

class BorrowProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<BorrowLog> borrowLogs = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> pinjamBuku({
    required String userId,
    required String userEmail,
    required String bookId,
    required String bookTitle,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
    try {
      await _firestore.collection('borrow_logs').add({
        'userId': userId,
        'userEmail': userEmail,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'borrowedAt': FieldValue.serverTimestamp(),
        'returned': false,
      });
      successMessage = 'Berhasil meminjam buku!';
    } catch (e) {
      errorMessage = 'Gagal meminjam buku.';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getBorrowHistory(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final query = await _firestore
          .collection('borrow_logs')
          .where('userId', isEqualTo: userId)
          .orderBy('borrowedAt', descending: true)
          .get();
      borrowLogs = query.docs.map((doc) {
        final data = doc.data();
        return BorrowLog(
          id: doc.id,
          bookTitle: data['bookTitle'] ?? '-',
          borrowedAt: (data['borrowedAt'] != null && data['borrowedAt'] is Timestamp)
              ? (data['borrowedAt'] as Timestamp).toDate()
              : null,
          returned: data['returned'] ?? false,
        );
      }).toList();
    } catch (e) {
      errorMessage = 'Gagal mengambil riwayat.';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllBorrowLogs() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final query = await _firestore
          .collection('borrow_logs')
          .orderBy('borrowedAt', descending: true)
          .get();
      borrowLogs = query.docs.map((doc) {
        final data = doc.data();
        return BorrowLog(
          id: doc.id,
          bookTitle: data['bookTitle'] ?? '-',
          borrowedAt: (data['borrowedAt'] != null && data['borrowedAt'] is Timestamp)
              ? (data['borrowedAt'] as Timestamp).toDate()
              : null,
          returned: data['returned'] ?? false,
        );
      }).toList();
    } catch (e) {
      errorMessage = 'Gagal mengambil log peminjaman.';
    }
    isLoading = false;
    notifyListeners();
  }
} 