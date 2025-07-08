import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstallmentScreen extends StatelessWidget {
  const InstallmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const hotline = '0868004667'; // Hotline ShopDunk

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trả góp'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Mô tả tổng quát
            const Text(
              'Chương trình Trả góp tại ShopDunk',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'ShopDunk hỗ trợ trả góp lãi suất 0% cho tất cả sản phẩm Apple chính hãng. '
              'Hình thức linh hoạt, duyệt nhanh, không cần chứng minh thu nhập.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // 🔁 Hình thức trả góp
            const Text(
              'Hình thức trả góp:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: 'Trả góp qua thẻ tín dụng (Visa/Master/JCB)'),
            const BulletPoint(text: 'Trả góp qua công ty tài chính (HD Saison, FE Credit...)'),
            const BulletPoint(text: 'Thời hạn linh hoạt: 3 - 12 tháng'),

            const SizedBox(height: 24),

            // 📊 Mô phỏng bảng
            const Text(
              'Ví dụ trả góp iPhone 15 (giá 25.000.000đ):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // ✅ FIX overflow bằng SingleChildScrollView
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Kỳ hạn')),
                  DataColumn(label: Text('Số tiền/tháng')),
                  DataColumn(label: Text('Tổng')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('3 tháng')),
                    DataCell(Text('8.333.000đ')),
                    DataCell(Text('25.000.000đ')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('6 tháng')),
                    DataCell(Text('4.167.000đ')),
                    DataCell(Text('25.000.000đ')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('12 tháng')),
                    DataCell(Text('2.084.000đ')),
                    DataCell(Text('25.000.000đ')),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📞 Đăng ký trả góp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Đăng ký trả góp'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận gọi'),
                      content: const Text(
                          'Bạn có muốn gọi đến tổng đài 18006675 để đăng ký trả góp không?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse('tel:$hotline');
                            Navigator.pop(context);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          child: const Text('Gọi ngay'),
                        ),
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
