import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'core/data/data_provider.dart';
import 'models/user.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen/login_screen.dart';
import 'screen/login_screen/provider/user_provider.dart';
import 'screen/product_by_category_screen/provider/product_by_category_provider.dart';
import 'screen/product_cart_screen/provider/cart_provider.dart';
import 'screen/product_details_screen/provider/product_detail_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';
import 'utility/app_theme.dart';
import 'utility/extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await FlutterCart().initializeCart(isPersistenceSupportEnabled: true);

  // OneSignal init
  OneSignal.initialize('53e9a724-3405-47e3-8e5d-180da7d4ee2f');
  OneSignal.Notifications.requestPermission(true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (c) => UserProvider(c.dataProvider)),
        ChangeNotifierProvider(create: (c) => ProfileProvider(c.dataProvider)),
        ChangeNotifierProvider(
            create: (c) => ProductByCategoryProvider(c.dataProvider)),
        ChangeNotifierProvider(
            create: (c) => ProductDetailProvider(c.dataProvider)),
        ChangeNotifierProvider(create: (c) => CartProvider(c.userProvider)),
        ChangeNotifierProvider(create: (c) => FavoriteProvider(c.dataProvider)),
      ],
      child: const MyApp(),
    ),
  );
}

/* ---------------- dark‑mode controller ---------------- */
class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    isDarkMode.value = _box.read(_key) ?? false;
    super.onInit();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write(_key, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}

final ThemeController themeController = Get.put(ThemeController());

/* ---------------- main app ---------------- */
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:3000',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPlayerId());
  }

  Future<void> _syncPlayerId() async {
    /// đảm bảo widget còn mounted
    if (!mounted) return;

    final user = context.userProvider.getLoginUsr();
    if (user == null) return;

    // lấy playerId, thử tối đa 5 lần
    const int maxRetry = 5;
    const delay = Duration(seconds: 1);
    String? playerId;

    for (int i = 0; i < maxRetry; i++) {
      playerId = OneSignal.User.pushSubscription.id;
      if (playerId != null) break;
      debugPrint('⏳ OneSignal chưa sẵn sàng... (${i + 1}/$maxRetry)');
      await Future.delayed(delay);
    }

    if (playerId == null) {
      debugPrint('❌ playerId vẫn null sau $maxRetry lần thử');
      return;
    }

    if (playerId == user.playerId) {
      debugPrint('✅ playerId không đổi – bỏ qua cập nhật');
      return;
    }

    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/users/${user.sId}/player-id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'playerId': playerId}),
      );

      if (res.statusCode == 200) {
        debugPrint('✅ playerId cập nhật thành công: $playerId');
      } else {
        debugPrint('⚠️ PUT trả về ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      debugPrint('❌ Lỗi khi cập nhật playerId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginUser = context.userProvider.getLoginUsr();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          theme: AppTheme.lightAppTheme,
          darkTheme: AppTheme.darkAppTheme,
          themeMode: themeController.theme,
          home:
              loginUser?.sId == null ? const LoginScreen() : const HomeScreen(),
        ));
  }
}
