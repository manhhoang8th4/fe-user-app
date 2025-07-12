import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class InstallmentScreen extends StatelessWidget {
  const InstallmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const hotline = '0868004667';

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('installment.title')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Mô tả tổng quát
            Text(
              tr('installment.description_title'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              tr('installment.description'),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // 💳 Hình thức trả góp
            Text(
              tr('installment.method_title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            BulletPoint(text: tr('installment.methods.card')),
            BulletPoint(text: tr('installment.methods.finance')),
            BulletPoint(text: tr('installment.methods.terms')),

            const SizedBox(height: 24),

            // 📊 Bảng mô phỏng
            Text(
              tr('installment.example_title'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(tr('installment.columns.term'))),
                  DataColumn(label: Text(tr('installment.columns.monthly'))),
                  DataColumn(label: Text(tr('installment.columns.total'))),
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

            // ☎️ Nút đăng ký
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: Text(tr('installment.button')),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(tr('installment.dialog.title')),
                      content: Text(tr('installment.dialog.content')),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(tr('installment.dialog.cancel')),
                        ),
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse('tel:$hotline');
                            Navigator.pop(context);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          child: Text(tr('installment.dialog.call')),
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
