import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 THÊM

import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';
import 'provider/favorite_provider.dart';
import 'package:e_commerce_flutter/utility/extensions.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load danh sách sản phẩm yêu thích
    Future.delayed(Duration.zero, () {
      context.favoriteProvider.loadFavoriteItems();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorites_title'.tr(), // 👈 Dùng key để dịch
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            return ProductGridView(
              items: favoriteProvider.favoriteProduct,
            );
          },
        ),
      ),
    );
  }
}
