import 'package:e_commerce_flutter/screen/extra_screens/upgrade_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ExchangeOldNewScreen extends StatefulWidget {
  const ExchangeOldNewScreen({super.key});

  @override
  State<ExchangeOldNewScreen> createState() => _ExchangeOldNewScreenState();
}

class _ExchangeOldNewScreenState extends State<ExchangeOldNewScreen> {
  String selectedCategory = 'iphone';

  final List<String> categories = ['iphone', 'ipad', 'macbook'];

  final List<Map<String, String>> products = [
    {
      'name': 'iPhone 15 Pro Max',
      'image': 'https://shopdunk.com/images/thumbs/0024371_iphone-15-pro-max_240.png',
      'price': '20.050.000đ',
      'old_price': '13.000.000đ',
      'category': 'iphone',
    },
    {
      'name': 'iPhone 15 Pro',
      'image': 'https://shopdunk.com/images/thumbs/0029976_iphone-15-pro_240.png',
      'price': '16.950.000đ',
      'old_price': '11.000.000đ',
      'category': 'iphone',
    },
    {
      'name': 'iPhone 14 Pro',
      'image': 'https://shopdunk.com/images/thumbs/0018589_iphone-14-pro_240.webp',
      'price': '12.550.000đ',
      'old_price': '8.000.000đ',
      'category': 'iphone',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        products.where((item) => item['category'] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr("exchange.title")),
        backgroundColor: Colors.pinkAccent,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => launchUrl(Uri.parse("tel:19001234")),
      //   label: Text(tr("exchange.hotline")),
      //   icon: const Icon(Icons.phone),
      //   backgroundColor: Colors.pinkAccent,
      // ),
      body: Column(
        children: [
          // 📷 Banner
          Column(
            children: [
              Image.network(
                'https://shopdunk.com/images/uploaded/banner/Banner%202025/thang2/T2_1/Danh%20mu%CC%A3c.jpg',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                tr("exchange.banner"),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // 🔘 Danh mục
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(tr("exchange.categories.$cat")),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = cat),
                    selectedColor: Colors.pinkAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 📦 Danh sách sản phẩm
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.network(product['image']!, width: 60),
                    title: Text(product['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${tr("exchange.new_price")}: ${product['price']}"),
                        Text(
                          "${tr("exchange.old_price")}: ${product['old_price']}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 📤 Nút đăng ký nâng cấp
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UpgradeRequestScreen()),
                  );
                },
                icon: const Icon(Icons.upgrade),
                label: Text(tr("exchange.register")),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
