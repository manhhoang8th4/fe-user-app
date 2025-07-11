import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:e_commerce_flutter/models/order.dart';
import '../../utility/app_color.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColor.darkOrange),
        title: Text(
          'order_details'.tr(),
          style: const TextStyle(
            color: AppColor.darkOrange,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            context,
            icon: Icons.receipt_long,
            title: 'order_info'.tr(),
            children: [
              _infoRow('order_id'.tr(), order.sId ?? 'N/A'),
              _infoRow('status'.tr(), order.orderStatus ?? 'N/A'),
              _infoRow('order_date'.tr(), order.orderDate ?? 'N/A'),
            ],
          ),
          _buildSectionCard(
            context,
            icon: Icons.shopping_bag,
            title: 'purchased_products'.tr(),
            children: [
              ...?order.items?.map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.productName ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${'quantity'.tr()}: ${item.quantity}',
                          style: const TextStyle(fontSize: 16)),
                      Text('${'price'.tr()}: ${item.price?.toStringAsFixed(0)}₫',
                          style: const TextStyle(fontSize: 16)),
                      Text('${'variant'.tr()}: ${item.variant ?? 'None'}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildSectionCard(
            context,
            icon: Icons.payment,
            title: 'payment'.tr(),
            children: [
              _infoRow('method'.tr(), order.paymentMethod ?? 'N/A'),
              _infoRow('subtotal'.tr(),
                  '${order.orderTotal?.subtotal?.toStringAsFixed(0) ?? '0'}₫'),
              _infoRow('discount'.tr(),
                  '-${order.orderTotal?.discount?.toStringAsFixed(0) ?? '0'}₫'),
              _infoRowBold('total'.tr(),
                  '${order.orderTotal?.total?.toStringAsFixed(0) ?? '0'}₫',
                  color: Colors.redAccent),
              if (order.couponCode != null)
                _infoRow('coupon_code'.tr(),
                    '${order.couponCode!.couponCode} (${order.couponCode!.discountAmount}% ${order.couponCode!.discountType})'),
            ],
          ),
          _buildSectionCard(
            context,
            icon: Icons.location_on,
            title: 'shipping_address'.tr(),
            children: [
              Text(
                '${order.shippingAddress?.street}, ${order.shippingAddress?.city}, ${order.shippingAddress?.state}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                '${order.shippingAddress?.country}, ${order.shippingAddress?.postalCode}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text('${'phone'.tr()}: ${order.shippingAddress?.phone}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRowBold(String label, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColor.darkOrange),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ),
          Expanded(
            flex: 6,
            child: Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
