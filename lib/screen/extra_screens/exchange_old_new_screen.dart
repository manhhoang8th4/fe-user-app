import 'package:e_commerce_flutter/screen/extra_screens/upgrade_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExchangeOldNewScreen extends StatefulWidget {
  const ExchangeOldNewScreen({super.key});

  @override
  State<ExchangeOldNewScreen> createState() => _ExchangeOldNewScreenState();
}

class _ExchangeOldNewScreenState extends State<ExchangeOldNewScreen> {
  String selectedCategory = 'iPhone';

  final List<String> categories = ['iPhone', 'iPad', 'Macbook'];

  // Giả lập dữ liệu – sau này thay bằng Firebase
  final List<Map<String, String>> products = [
    {
      'name': 'iPhone 15 Pro Max',
      'image': 'https://cdn.tgdd.vn/Products/Images/42/305659/iphone-15-pro-max-1-2-3.jpg',
      'price': '20.050.000đ',
      'old_price': '13.000.000đ',
      'category': 'iPhone',
    },
    {
      'name': 'iPhone 15 Pro',
      'image': 'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-1-2-3.jpg',
      'price': '16.950.000đ',
      'old_price': '11.000.000đ',
      'category': 'iPhone',
    },
    {
      'name': 'iPhone 14 Pro',
      'image': 'https://cdn.tgdd.vn/Products/Images/42/303891/iphone-14-pro.jpg',
      'price': '12.550.000đ',
      'old_price': '8.000.000đ',
      'category': 'iPhone',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((item) => item['category'] == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Thu cũ đổi mới"),
        backgroundColor: Colors.pinkAccent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          launchUrl(Uri.parse("tel:19001234")); // Gọi hotline
        },
        label: Text("Hotline"),
        icon: Icon(Icons.phone),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // Banner
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Image.network(
                  'https://cdn.mobilecity.vn/mobilecity-vn/images/2023/09/banner-iphone-15-pro-max.jpg',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  "Lên đời iPhone 16 series",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Danh mục
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedCategory = cat);
                    },
                    selectedColor: Colors.pinkAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Danh sách sản phẩm
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.network(product['image']!, width: 60),
                    title: Text(product['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Giá mới: ${product['price']}"),
                        Text("Giá thu cũ: ${product['old_price']!}",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Button Đăng ký
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Điều hướng tới form đăng ký (sau này)
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UpgradeRequestScreen()),
                      );
                },
                icon: Icon(Icons.upgrade),
                label: Text("Đăng ký lên đời ngay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
