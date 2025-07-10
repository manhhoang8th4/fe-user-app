import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_language'.tr()), // ✅ Dùng tr()
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('vietnamese'.tr()), // ✅ Dùng tr()
            onTap: () async {
              await context.setLocale(const Locale('vi'));
              GetStorage().write('languageSelected', true);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('english'.tr()), // ✅ Dùng tr()
            onTap: () async {
              await context.setLocale(const Locale('en'));
              GetStorage().write('languageSelected', true);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
