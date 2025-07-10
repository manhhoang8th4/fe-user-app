import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<String?> sendForgotPassword(String email) async {
    try {
      setLoading(true);

      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3000/users/forgot-password'), // 👈 Cập nhật đúng URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return null; // ✅ Thành công, không có lỗi
      } else {
        return data['message'] ?? 'Unknown error';
      }
    } catch (e) {
      return 'An error occurred: $e';
    } finally {
      setLoading(false);
    }
  }
}
