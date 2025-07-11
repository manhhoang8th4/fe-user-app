import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 Thêm dòng này

import '../../../../widget/carousel_slider.dart';
import '../../../../widget/page_wrapper.dart';
import '../../../../widget/horizondal_list.dart';
import '../../models/product.dart';
import '../../utility/extensions.dart';
import 'provider/product_detail_provider.dart';
import 'components/product_rating_section.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───── Product image ─────
                Container(
                  height: height * 0.42,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E6E8),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(200),
                      bottomLeft: Radius.circular(200),
                    ),
                  ),
                  child: CarouselSlider(items: product.images ?? []),
                ),
                const SizedBox(height: 20),

                // ───── Info section ─────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                      const ProductRatingSection(),
                      const SizedBox(height: 10),

                      // ───── Price + Stock ─────
                      Row(
                        children: [
                          Text(
                            product.offerPrice != null
                                ? "\$${product.offerPrice}"
                                : "\$${product.price}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(width: 3),
                          Visibility(
                            visible: product.offerPrice != product.price,
                            child: Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            product.quantity != 0
                                ? 'available_stock'.tr(args: [product.quantity.toString()])
                                : 'not_available'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // ───── Variant Type Title ─────
                      if (product.proVariantId?.isNotEmpty ?? false)
                        Text(
                          'available_variants'.tr(args: [
                            product.proVariantTypeId?.type ?? ''
                          ]),
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),

                      // ───── Variant List ─────
                      Consumer<ProductDetailProvider>(
                        builder: (context, proDetailProvider, child) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (product.proVariantId ?? [])
                                .map((variant) => ChoiceChip(
                                      label: Text(variant),
                                      selected: proDetailProvider
                                          .selectedVariants
                                          .contains(variant),
                                      onSelected: (_) {
                                        proDetailProvider.toggleVariant(variant);
                                      },
                                      selectedColor: Colors.orange,
                                    ))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // ───── Description ─────
                      Text("about".tr(),
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Text(product.description ?? ''),
                      const SizedBox(height: 40),

                      // ───── Add to Cart ─────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.quantity != 0
                              ? () =>
                                  context.proDetailProvider.addToCart(product)
                              : null,
                          child: Text(
                            'add_to_cart'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
