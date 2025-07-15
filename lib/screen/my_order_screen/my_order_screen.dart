import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;

import 'order_detail_screen.dart';


import '../../core/data/data_provider.dart';
import '../tracking_screen/tracking_screen.dart';
import '../../utility/app_color.dart';
import '../../utility/extensions.dart';
import '../../utility/utility_extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../widget/order_tile.dart';




class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.dataProvider.getAllOrderByUser(context.userProvider.getLoginUsr());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          easy_localization.tr('my_orders.title'), // Sử dụng easy_localization rõ ràng
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: context.dataProvider.orders.length,
            itemBuilder: (context, index) {
              final order = context.dataProvider.orders[index];
              return GestureDetector(
                onTap: () {
                  Get.to(OrderDetailScreen(order: order));
                },
                onDoubleTap: () {
                  if (order.orderStatus == 'shipped.title') {
                    Get.to(TrackingScreen(url: order.trackingUrl ?? ''));
                  }
                },
                child: OrderTile(
                  paymentMethod: order.paymentMethod ?? '',
                  items:
                      '${(order.items.safeElementAt(0)?.productName ?? '')} & ${order.items!.length - 1} ${easy_localization.tr("items")}',
                  date: order.orderDate ?? '',
                  status: order.orderStatus ?? 'pending_order.title',
                  onTap: null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
