import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 Thêm dòng này

import '../../core/data/data_provider.dart';
import 'components/custom_app_bar.dart';
import '../../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "greeting".tr(), // 👈 dùng key thay vì text cứng
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "get_something".tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const PosterSection(),
                  Text(
                    "top_categories".tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return CategorySelector(
                        categories: dataProvider.categories,
                      );
                    },
                  ),
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return ProductGridView(
                        items: dataProvider.products,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
