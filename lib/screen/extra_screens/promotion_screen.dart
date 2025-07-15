import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final List<String> categories = ['all', 'iphone', 'ipad', 'macbook'];
  String selectedCategory = 'all';

  final List<Map<String, dynamic>> promotions = [
    {
      "name": "iPhone 15 Pro Max",
      "image": "https://shopdunk.com/images/thumbs/0024371_iphone-15-pro-max_240.png",
      "price": 30000000,
      "discountPrice": 20050000,
      "category": "iphone",
    },
    {
      "name": "iPad Pro 2024",
      "image": "https://shopdunk.com/images/thumbs/0038080_ipad-pro-11-2024-m4-wifi-256gb_240.jpeg",
      "price": 25000000,
      "discountPrice": 19490000,
      "category": "ipad",
    },
    {
      "name": "MacBook Air M3",
      "image": "https://shopdunk.com/images/thumbs/0032184_macbook-air-m3-15-inch-2024-16gb-ram-256gb-ssd_240.jpeg",
      "price": 35000000,
      "discountPrice": 29900000,
      "category": "macbook",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPromotions = selectedCategory == 'all'
        ? promotions
        : promotions.where((item) => item['category'] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr("promotion.title")),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // 🔘 Danh mục
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((cat) {
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(tr("promotion.categories.$cat")),
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

          // 📦 Danh sách khuyến mãi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredPromotions.length,
              itemBuilder: (context, index) {
                final promo = filteredPromotions[index];
                final percent = ((1 - promo["discountPrice"] / promo["price"]) * 100).round();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                promo["image"],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(promo["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${promo["price"]}đ",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${promo["discountPrice"]}đ",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "-${percent.toInt()}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(tr("promotion.selected", namedArgs: {"product": promo["name"]})),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: Text(tr("promotion.buy_now")),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(promo["name"]),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(promo["image"]),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${tr("promotion.dialog.original_price")}: ${promo["price"]}đ\n"
                                          "${tr("promotion.dialog.discount_price")}: ${promo["discountPrice"]}đ\n"
                                          "${tr("promotion.dialog.discount", namedArgs: {"percent": percent.toString()})}",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(tr("promotion.dialog.close")),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                              label: Text(tr("promotion.details")),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
