import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/user_form.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseService _service = FirebaseService();

  void _openForm({Map<String, dynamic>? user}) {
    showDialog(
      context: context,
      builder: (_) => UserForm(
        service: _service,
        user: user,
        onSaved: () => setState(() {}),
      ),
    );
  }

  Future<void> _confirmDelete(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text('Bạn có chắc chắn muốn xoá người dùng này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xoá')),
        ],
      ),
    );
    if (confirm == true) _service.deleteUser(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          'Realtime Firebase CRUD',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder(
        stream: _service.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('❌ Lỗi tải dữ liệu từ Firebase'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(
              child: Text(
                '📭 Chưa có người dùng nào',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final value = snapshot.data!.snapshot.value;
          if (value is! Map) {
            return const Center(child: Text('Dữ liệu không hợp lệ'));
          }

          final data = Map<String, dynamic>.from(value);
          final users = data.entries.map((e) {
            final user = Map<String, dynamic>.from(e.value);
            user['key'] = e.key;
            return user;
          }).toList();

          final userCount = users.length;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Thẻ thống kê tổng số người dùng
                  Row(
                    children: [
                      const Icon(Icons.people_alt, color: Colors.indigo, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tổng số người dùng',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$userCount',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 🔹 Danh sách user với khung bao quanh mỗi user
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, i) {
                        final user = users[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.indigo.shade100),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.indigo.shade50.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'] ?? 'Người dùng',
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  if (user['email'] != null)
                                    Text(
                                      user['email'],
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.indigo),
                                    onPressed: () => _openForm(user: user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(user['key']),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
