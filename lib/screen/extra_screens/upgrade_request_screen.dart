import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

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
  bool _isLoading = false;

  Future<void> submitRequest() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('http://192.168.1.10:3000/api/upgrade-request');
    try {
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

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr("upgrade.success"))),
        );
        _formKey.currentState?.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr("upgrade.error"))),
        );
      }
    } catch (_) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr("upgrade.error"))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr("upgrade.title"))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: tr("upgrade.name")),
                validator: (value) =>
                    value == null || value.isEmpty ? tr("upgrade.required", args: [tr("upgrade.name")]) : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: tr("upgrade.phone")),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? tr("upgrade.required", args: [tr("upgrade.phone")]) : null,
                onSaved: (value) => phone = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: tr("upgrade.device_old")),
                onSaved: (value) => deviceOld = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: tr("upgrade.device_new")),
                onSaved: (value) => deviceNew = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: tr("upgrade.note")),
                onSaved: (value) => note = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(tr("upgrade.submit")),
                onPressed: _isLoading
                    ? null
                    : () {
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
