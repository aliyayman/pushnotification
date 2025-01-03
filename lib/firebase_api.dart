// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  Future<bool> addUser(String name, String token) async {
    try {
      // Firestore koleksiyonuna yeni kullanıcıyı ekliyoruz
      await _db.collection(_collectionName).add({
        'name': name,
        'fcmToken': token,
      });
      print('User added successfully');
      return true;
    } catch (e) {
      print('Error adding user: $e');
      throw Exception('Failed to add user');
    }
  }
}
