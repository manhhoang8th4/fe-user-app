import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpgradeRequestScreen extends StatefulWidget {
  const UpgradeRequestScreen({super.key});

  @override
  State<UpgradeRequestScreen> createState() => _UpgradeRequestScreenState();
}

class _UpgradeRequestScreenState extends State<UpgradeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String deviceOld = '';
  String deviceNew = '';
  String note = '';

  Future<void> submitRequest() async {
    final url = Uri.parse('http://192.168.1.10:3000/api/upgrade-request'); // Thay bằng IP backend
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'phone': phone,
        'device_old': deviceOld,
        'device_new': deviceNew,
        'note': note,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thành công!")),
      );
      _formKey.currentState?.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gửi thất bại. Vui lòng thử lại.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký lên đời")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Họ tên"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập tên" : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Số điện thoại"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập SĐT" : null,
                onSaved: (value) => phone = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Thiết bị cũ"),
                onSaved: (value) => deviceOld = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Thiết bị muốn lên đời"),
                onSaved: (value) => deviceNew = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ghi chú"),
                onSaved: (value) => note = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.send),
                label: Text("Gửi đăng ký"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    submitRequest();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
