import 'package:e_commerce_flutter/models/product.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:e_commerce_flutter/utility/utility_extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';

import '../../../core/data/data_provider.dart';

class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  var flutterCart = FlutterCart();

  Set<String> selectedVariants = {};

  ProductDetailProvider(this._dataProvider);

  void toggleVariant(String variant) {
    if (selectedVariants.contains(variant)) {
      selectedVariants.remove(variant);
    } else if (selectedVariants.length < 2) {
      selectedVariants.add(variant);
    } else {
      SnackBarHelper.showErrorSnackBar('You can select up to 2 variants');
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    if (product.proVariantId!.isNotEmpty && selectedVariants.isEmpty) {
      SnackBarHelper.showErrorSnackBar('Please select a variant');
      return;
    }

    // Gộp các variant lại thành một chuỗi duy nhất
    String variantString = selectedVariants.join(' - ');

    double? price = product.offerPrice != product.price
        ? product.offerPrice
        : product.price;

    flutterCart.addToCart(
      cartModel: CartModel(
        productId: '${product.sId}',
        productName: '${product.name} - $variantString',
        productImages: ['${product.images.safeElementAt(0)?.url}'],
        variants: [ProductVariant(price: price ?? 0, color: variantString)],
        productDetails: '${product.description}',
      ),
    );

    selectedVariants.clear(); // reset sau khi thêm
    SnackBarHelper.showSuccessSnackBar('Item Added');
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }
}
