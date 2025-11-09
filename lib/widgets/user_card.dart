import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.userData,
    required this.onEdit,
    required this.onDelete,
  });

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thông tin người dùng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên: ${userData['name'] ?? ''}'),
            Text('Email: ${userData['email'] ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent, size: 32),
        title: Text(userData['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(userData['email'] ?? ''),
        onTap: () => _showInfo(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.indigo),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
