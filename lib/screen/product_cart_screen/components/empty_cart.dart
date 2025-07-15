import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ thêm dòng này

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/images/empty_cart.png'),
            ),
          ),
          Text(
            "cart_emty.empty".tr(), // ✅ chỉ thêm tr() vào
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
