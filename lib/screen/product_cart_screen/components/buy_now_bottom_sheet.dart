import 'dart:ui';
import 'package:easy_localization/easy_localization.dart'; // ✅ ADD
import '../provider/cart_provider.dart';
import '../../../utility/extensions.dart';
import '../../../widget/compleate_order_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/applay_coupon_btn.dart';
import '../../../widget/custom_dropdown.dart';
import '../../../widget/custom_text_field.dart';

void showCustomBottomSheet(BuildContext context) {
  context.cartProvider.clearCouponDiscount();
  context.cartProvider.retrieveSavedAddress();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: context.cartProvider.buyNowFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle Address Fields
                ListTile(
                  title: Text('cart.enter_address'.tr()), // ✅
                  trailing: IconButton(
                    icon: Icon(context.cartProvider.isExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                    onPressed: () {
                      context.cartProvider.isExpanded =
                          !context.cartProvider.isExpanded;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Visibility(
                      visible: cartProvider.isExpanded,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            CustomTextField(
                              height: 65,
                              labelText: 'form.phone'.tr(),
                              onSave: (value) {},
                              inputType: TextInputType.number,
                              controller:
                                  context.cartProvider.phoneController,
                              validator: (value) => value!.isEmpty
                                  ? 'form.error.phone'.tr()
                                  : null,
                            ),
                            CustomTextField(
                              height: 65,
                              labelText: 'form.street'.tr(),
                              onSave: (val) {},
                              controller:
                                  context.cartProvider.streetController,
                              validator: (value) => value!.isEmpty
                                  ? 'form.error.street'.tr()
                                  : null,
                            ),
                            CustomTextField(
                              height: 65,
                              labelText: 'form.city'.tr(),
                              onSave: (value) {},
                              controller:
                                  context.cartProvider.cityController,
                              validator: (value) => value!.isEmpty
                                  ? 'form.error.city'.tr()
                                  : null,
                            ),
                            CustomTextField(
                              height: 65,
                              labelText: 'form.state'.tr(),
                              onSave: (value) {},
                              controller:
                                  context.cartProvider.stateController,
                              validator: (value) => value!.isEmpty
                                  ? 'form.error.state'.tr()
                                  : null,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    height: 65,
                                    labelText: 'form.postal_code'.tr(),
                                    onSave: (value) {},
                                    inputType: TextInputType.number,
                                    controller: context
                                        .cartProvider.postalCodeController,
                                    validator: (value) => value!.isEmpty
                                        ? 'form.error.postal_code'.tr()
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    height: 65,
                                    labelText: 'form.country'.tr(),
                                    onSave: (value) {},
                                    controller: context
                                        .cartProvider.countryController,
                                    validator: (value) => value!.isEmpty
                                        ? 'form.error.country'.tr()
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Payment Option
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return CustomDropdown<String>(
                        bgColor: Colors.white,
                        hintText:
                            'payment.${cartProvider.selectedPaymentOption}'.tr(),
                        items: const ['cod', 'prepaid'],
                        onChanged: (val) {
                          cartProvider.selectedPaymentOption =
                              val ?? 'prepaid';
                          cartProvider.updateUI();
                        },
                        displayItem: (val) => 'payment.$val'.tr());
                  },
                ),

                // Coupon Code Field
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        height: 60,
                        labelText: 'coupon.enter_code'.tr(),
                        onSave: (value) {},
                        controller: context.cartProvider.couponController,
                      ),
                    ),
                    ApplyCouponButton(onPressed: () {
                      context.cartProvider.checkCoupon();
                    })
                  ],
                ),

                // Tổng tiền
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 5, left: 6),
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${'cart.total'.tr()} : \$${cartProvider.getCartSubTotal()}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(
                              '${'cart.discount'.tr()} : \$${cartProvider.couponCodeDiscount}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(
                              '${'cart.grand_total'.tr()} : \$${cartProvider.getGrandTotal()}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(),
                // Button
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return CompleteOrderButton(
                        labelText:
                            '${'cart.complete_order'.tr()} \$${cartProvider.getGrandTotal()}',
                        onPressed: () {
                          if (!cartProvider.isExpanded) {
                            cartProvider.isExpanded = true;
                            cartProvider.updateUI();
                            return;
                          }
                          if (context.cartProvider.buyNowFormKey.currentState!
                              .validate()) {
                            context.cartProvider.buyNowFormKey.currentState!
                                .save();
                            context.cartProvider.submitOrder(context);
                          }
                        });
                  },
                )
              ],
            ),
          ),
        ),
      );
    },
    isScrollControlled: true,
  );
}
