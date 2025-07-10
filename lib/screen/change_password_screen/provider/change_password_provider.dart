import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> changePassword({
    required String userId,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return null;
      } else {
        return data['message'] ?? "Unknown error occurred";
      }
    } catch (e) {
      return "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
