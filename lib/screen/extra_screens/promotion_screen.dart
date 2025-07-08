import 'package:flutter/material.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  final List<String> categories = ['Tất cả', 'iPhone', 'iPad', 'MacBook'];
  String selectedCategory = 'Tất cả';

  final List<Map<String, dynamic>> promotions = [
    {
      "name": "iPhone 15 Pro Max",
      "image":
          "https://cdn.tgdd.vn/Products/Images/42/305659/iphone-15-pro-max-1-2-3.jpg",
      "price": 30000000,
      "discountPrice": 20050000,
      "category": "iPhone",
    },
    {
      "name": "iPad Pro 2024",
      "image":
          "https://cdn.tgdd.vn/Products/Images/522/305660/ipad-pro-m4.jpg",
      "price": 25000000,
      "discountPrice": 19490000,
      "category": "iPad",
    },
    {
      "name": "MacBook Air M3",
      "image":
          "https://cdn.tgdd.vn/Products/Images/44/315525/macbook-air-m3.jpg",
      "price": 35000000,
      "discountPrice": 29900000,
      "category": "MacBook",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredPromotions =
        selectedCategory == 'Tất cả'
            ? promotions
            : promotions
                .where((item) => item['category'] == selectedCategory)
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ưu đãi mới"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // Bộ lọc danh mục
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
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() {
                      selectedCategory = cat;
                    }),
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
              padding: const EdgeInsets.all(12),
              itemCount: filteredPromotions.length,
              itemBuilder: (context, index) {
                final promo = filteredPromotions[index];
                final double percent = ((1 -
                            promo["discountPrice"] / promo["price"]) *
                        100)
                    .roundToDouble();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Image
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

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promo["name"],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),

                            // Tag giảm giá
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
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

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Bạn đã chọn mua: ${promo["name"]}")),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text("Mua ngay"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
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
                                            "Giá gốc: ${promo["price"]}đ\nƯu đãi: ${promo["discountPrice"]}đ\nGiảm ${percent.toInt()}%"),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text("Đóng"),
                                        onPressed: () =>
                                            Navigator.pop(context),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                              label: const Text("Chi tiết"),
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
