import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppleWarrantyScreen extends StatelessWidget {
  const AppleWarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const phoneNumber = '0868004667'; // Hotline
    const zaloNumber = '0868004667'; // SĐT có Zalo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảo hành Apple'),
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
            const Text(
              'Chính sách bảo hành Apple tại ShopDunk',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sản phẩm Apple được bảo hành theo chính sách chính hãng toàn cầu. '
              'ShopDunk hỗ trợ kiểm tra bảo hành và gửi bảo hành cho khách hàng với quy trình nhanh chóng, minh bạch.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // ✅ Dịch vụ hỗ trợ
            const Text(
              'Các dịch vụ hỗ trợ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: 'Kiểm tra tình trạng bảo hành Apple'),
            const BulletPoint(text: 'Hướng dẫn gửi bảo hành chính hãng'),
            const BulletPoint(text: 'Thay pin, sửa chữa thiết bị Apple'),
            const BulletPoint(text: 'Tư vấn bảo hành 24/7'),

            const SizedBox(height: 30),

            // 📞 Liên hệ hỗ trợ
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.phone),
                  label: const Text('Gọi ngay'),
                  onPressed: () async {
                    final uri = Uri.parse('tel:$phoneNumber');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.sms),
                  label: const Text('Gửi SMS'),
                  onPressed: () async {
                    final uri = Uri.parse('sms:$phoneNumber');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat Zalo'),
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
