import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ Add this

class ApplyCouponButton extends StatelessWidget {
  final Function() onPressed;

  const ApplyCouponButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text('cart_coupon.apply_coupon'.tr()), // ✅ Use translation key
    );
  }
}
