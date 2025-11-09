import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('users');

  // 🔹 Lấy stream realtime
  Stream<DatabaseEvent> getUserStream() => _dbRef.onValue;

  // 🔹 Thêm user
  Future<void> addUser(Map<String, dynamic> userData) async {
    await _dbRef.push().set(userData);
  }

  // 🔹 Cập nhật user
  Future<void> updateUser(String key, Map<String, dynamic> userData) async {
    await _dbRef.child(key).update(userData);
  }

  // 🔹 Xóa user
  Future<void> deleteUser(String key) async {
    await _dbRef.child(key).remove();
  }
}
