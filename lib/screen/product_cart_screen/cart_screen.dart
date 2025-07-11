import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 Thêm dòng này

import '../../utility/extensions.dart';
import 'provider/cart_provider.dart';
import '../../utility/animation/animated_switcher_wrapper.dart';
import '../../utility/app_color.dart';
import 'components/buy_now_bottom_sheet.dart';
import 'components/cart_list_section.dart';
import 'components/empty_cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      context.cartProvider.getCartItems();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my_cart'.tr(), // ✅ dùng key từ en/vi.json
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cartProvider.myCartItems.isEmpty
                  ? const EmptyCart()
                  : CartListSection(cartProducts: cartProvider.myCartItems),

              // ───── Tổng tiền ─────
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total'.tr(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AnimatedSwitcherWrapper(
                      child: Text(
                        "\$${context.cartProvider.getCartSubTotal()}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFEC6813),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ───── Nút Mua ngay ─────
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                    onPressed: cartProvider.myCartItems.isEmpty
                        ? null
                        : () {
                            showCustomBottomSheet(context);
                          },
                    child: Text(
                      'buy_now'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
