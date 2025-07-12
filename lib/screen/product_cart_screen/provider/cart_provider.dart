import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_flutter/utility/utility_extention.dart';
import '../../../models/coupon.dart';
import '../../login_screen/provider/user_provider.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CartProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();
  Razorpay razorpay = Razorpay();
  final UserProvider _userProvider;
  var flutterCart = FlutterCart();
  List<CartModel> myCartItems = [];

  final GlobalKey<FormState> buyNowFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  bool isExpanded = false;

  Coupon? couponApplied;
  double couponCodeDiscount = 0;
  String selectedPaymentOption = 'prepaid';

  CartProvider(this._userProvider);

  getCartItems() {
    myCartItems = flutterCart.cartItemsList;
    notifyListeners();
  }

  void updateCart(CartModel cartItem, int quantity) {
    quantity = cartItem.quantity + quantity;
    flutterCart.updateQuantity(cartItem.productId, cartItem.variants, quantity);
    notifyListeners();
  }

  double getCartSubTotal() {
    return flutterCart.subtotal;
  }

  clearCartItems() {
    flutterCart.clearCart();
    notifyListeners();
  }

  double getGrandTotal() {
    return getCartSubTotal() - couponCodeDiscount;
  }

  checkCoupon() async {
    try {
      if (couponController.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar(tr('coupon.enter_code'));
        return;
      }
      List<String> productIds =
          myCartItems.map((cartItem) => cartItem.productId).toList();
      Map<String, dynamic> couponData = {
        "couponCode": couponController.text,
        "purchaseAmount": getCartSubTotal(),
        "productIds": productIds
      };
      final response = await service.addItem(
          endpointUrl: 'couponCodes/check-coupon', itemData: couponData);
      if (response.isOk) {
        final ApiResponse<Coupon> apiResponse = ApiResponse<Coupon>.fromJson(
            response.body,
            (json) => Coupon.fromJson(json as Map<String, dynamic>));
        if (apiResponse.success == true) {
          Coupon? coupon = apiResponse.data;
          if (coupon != null) {
            couponApplied = coupon;
            couponCodeDiscount = getCouponDiscountAmount(coupon);
          }
          SnackBarHelper.showSuccessSnackBar(tr(apiResponse.message));
          log('Coupon is valid');
        } else {
          SnackBarHelper.showErrorSnackBar(
              '${tr('coupon.failed')}: ${tr(apiResponse.message)}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${tr(response.body?['message']?.toString() ?? response.statusText ?? '')}');
      }
      notifyListeners();
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(tr('error.general', args: [e.toString()]));
      rethrow;
    }
  }

  double getCouponDiscountAmount(Coupon coupon) {
    double discountAmount = 0;
    String discountType = coupon.discountType ?? 'fixed';
    if (discountType == 'fixed') {
      discountAmount = coupon.discountAmount ?? 0;
      return discountAmount;
    } else {
      double discountPercentage = coupon.discountAmount ?? 0;
      double amountAfterDiscountPercentage =
          getCartSubTotal() * (discountPercentage / 100);
      return amountAfterDiscountPercentage;
    }
  }

  addOrder(BuildContext context) async {
    try {
      Map<String, dynamic> order = {
        "userID": _userProvider.getLoginUsr()?.sId ?? '',
        "orderStatus": "pending",
        "items": cartItemToOrderItem(myCartItems),
        "totalPrice": getCartSubTotal(),
        "shippingAddress": {
          "phone": phoneController.text,
          "street": streetController.text,
          "city": cityController.text,
          "state": stateController.text,
          "postalCode": postalCodeController.text,
          "country": countryController.text,
        },
        "paymentMethod": selectedPaymentOption,
        "couponCode": couponApplied?.sId,
        "orderTotal": {
          "subtotal": getCartSubTotal(),
          "discount": couponCodeDiscount,
          "total": getGrandTotal()
        },
      };
      final response =
          await service.addItem(endpointUrl: 'orders', itemData: order);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(tr(apiResponse.message));
          log('Order added');
          clearCouponDiscount();
          clearCartItems();
          Navigator.pop(context);
        } else {
          SnackBarHelper.showErrorSnackBar(
              '${tr('order.failed')}: ${tr(apiResponse.message)}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${tr(response.body?['message']?.toString() ?? response.statusText ?? '')}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(tr('error.general', args: [e.toString()]));
      rethrow;
    }
  }

  List<Map<String, dynamic>> cartItemToOrderItem(List<CartModel> cartItems) {
    return cartItems.map((cartItem) {
      return {
        "productID": cartItem.productId,
        "productName": cartItem.productName,
        "quantity": cartItem.quantity,
        "price": cartItem.variants.safeElementAt(0)?.price ?? 0,
        "variant": cartItem.variants.safeElementAt(0)?.color ?? 0,
      };
    }).toList();
  }

  Future<void> submitOrder(BuildContext context) async {
    try {
      if (selectedPaymentOption == 'cod') {
        await addOrder(context);
      } else {
        await stripePayment(
          operation: () => addOrder(context),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('error.general', args: [e.toString()]))),
      );
    }
  }

  clearCouponDiscount() {
    couponApplied = null;
    couponCodeDiscount = 0;
    couponController.text = '';
    notifyListeners();
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  Future<void> stripePayment({
    required VoidCallback operation,
  }) async {
    try {
      final orderMap = {
        'email': _userProvider.getLoginUsr()?.email,
        'name': _userProvider.getLoginUsr()?.name,
        'address': {
          'line1': streetController.text,
          'city': cityController.text,
          'state': stateController.text,
          'postal_code': postalCodeController.text,
          'country': 'US',
        },
        'amount': (getGrandTotal() * 100).round(),
        'currency': 'usd',
        'description': tr('order.description'),
      };
      final resp = await service.addItem(
        endpointUrl: 'payment/stripe',
        itemData: orderMap,
      );
      final Map<String, dynamic> data =
          resp.body is String ? jsonDecode(resp.body) : resp.body;

      final publishableKey = data['publishableKey'] as String;
      final paymentIntent = data['paymentIntent'] as String;
      final customerId = data['customer'] as String;
      final ephemeralKey = data['ephemeralKey'] as String;
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent,
            customerEphemeralKeySecret: ephemeralKey,
            customerId: customerId,
            merchantDisplayName: 'MOBIZATE',
            billingDetails: BillingDetails(
              email: _userProvider.getLoginUsr()?.email,
              name: _userProvider.getLoginUsr()?.name,
              phone: '1234567890',
              address: Address(
                country: 'US',
                city: cityController.text,
                line1: streetController.text,
                line2: stateController.text,
                postalCode: postalCodeController.text,
                state: stateController.text,
              ),
            ),
            style: ThemeMode.light,
          ),
        );
      } on StripeException catch (e) {
        _snack(tr('stripe.init_error', args: [e.error.localizedMessage ?? '']));
        return;
      }
      try {
        await Stripe.instance.presentPaymentSheet();
        _snack(tr('stripe.success'));
        operation();
      } on StripeException catch (e) {
        _snack(tr('stripe.present_error', args: [e.error.localizedMessage ?? '']));
      }
    } catch (e, s) {
      _snack(tr('stripe.exception', args: [e.toString()]));
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(Get.context!)
      .showSnackBar(SnackBar(content: Text(msg)));

  Future<void> razorpayPayment({required void Function() operation}) async {
    try {
      Response response =
          await service.addItem(endpointUrl: 'payment/razorpay', itemData: {});
      final data = await response.body;
      String? razorpayKey = data['key'];
      if (razorpayKey != null && razorpayKey != '') {
        var options = {
          'key': razorpayKey,
          'amount': getGrandTotal() * 100,
          'name': "user",
          "currency": 'INR',
          'description': tr('order.description'),
          'send_sms_hash': true,
          "prefill": {
            "email": _userProvider.getLoginUsr()?.email,
            "contact": ''
          },
          "theme": {'color': '#FFE64A'},
          "image":
              'https://store.rapidflutter.com/digitalAssetUpload/rapidlogo.png',
        };
        razorpay.open(options);
        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse response) {
          operation();
          return;
        });
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
            (PaymentFailureResponse response) {
          SnackBarHelper.showErrorSnackBar(
              tr('razorpay.failed', args: [response.message ?? '']));
          return;
        });
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(tr('razorpay.exception', args: [e.toString()]));
      return;
    }
  }

  void updateUI() {
    notifyListeners();
  }
}
