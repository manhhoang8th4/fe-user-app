import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class AppleWarrantyScreen extends StatelessWidget {
  const AppleWarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const phoneNumber = '0868004667';
    const zaloNumber = '0868004667';

    final services = [
      tr('check_apple_warranty'),
      tr('guide_official_warranty'),
      tr('repair_apple_device'),
      tr('warranty_consultation'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('apple_warranty_policy_title')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📷 Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/apple_warranty_banner.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // 📝 Mô tả
            Text(
              tr('apple_warranty_policy_description'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // ✅ Dịch vụ hỗ trợ
            Text(
              tr('apple_warranty_services'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...services.map((text) => BulletPoint(text: text)).toList(),

            const SizedBox(height: 30),

            // 📞 Liên hệ hỗ trợ
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: Text(tr('call_now')),
                  onPressed: () async {
                    final uri = Uri.parse('tel:$phoneNumber');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.sms),
                  label: Text(tr('send_sms')),
                  onPressed: () async {
                    final uri = Uri.parse('sms:$phoneNumber');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: Text(tr('chat_zalo')),
                  onPressed: () async {
                    final uri = Uri.parse('https://zalo.me/$zaloNumber');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
