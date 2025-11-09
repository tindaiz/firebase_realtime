import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class UserForm extends StatefulWidget {
  final FirebaseService service;
  final Map<String, dynamic>? user; // null = thêm mới, có giá trị = sửa
  final VoidCallback onSaved;

  const UserForm({
    super.key,
    required this.service,
    this.user,
    required this.onSaved,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameCtrl.text = widget.user!['name'] ?? '';
      _emailCtrl.text = widget.user!['email'] ?? '';
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (widget.user == null) {
      // Thêm mới
      await widget.service.addUser({'name': name, 'email': email});
    } else {
      // Cập nhật
      await widget.service.updateUser(widget.user!['key'], {'name': name, 'email': email});
    }

    widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'Thêm người dùng' : 'Cập nhật người dùng'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên'),
              validator: (v) => v!.isEmpty ? 'Nhập tên' : null,
            ),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => v!.isEmpty ? 'Nhập email' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _saveUser,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
