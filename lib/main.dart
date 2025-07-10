import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import './screen/change_password_screen/provider/change_password_provider.dart';
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
  await EasyLocalization.ensureInitialized(); // localization init
  await GetStorage.init();
  await FlutterCart().initializeCart(isPersistenceSupportEnabled: true);

  OneSignal.initialize('53e9a724-3405-47e3-8e5d-180da7d4ee2f');
  OneSignal.Notifications.requestPermission(true);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataProvider()),
          ChangeNotifierProvider(create: (c) => UserProvider(c.dataProvider)),
          ChangeNotifierProvider(
              create: (c) => ProfileProvider(c.dataProvider)),
          ChangeNotifierProvider(
              create: (c) => ProductByCategoryProvider(c.dataProvider)),
          ChangeNotifierProvider(
              create: (c) => ProductDetailProvider(c.dataProvider)),
          ChangeNotifierProvider(create: (c) => CartProvider(c.userProvider)),
          ChangeNotifierProvider(
              create: (c) => FavoriteProvider(c.dataProvider)),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ],
        child: const MyApp(),
      ),
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
    if (!mounted) return;

    final user = context.userProvider.getLoginUsr();
    if (user == null) return;

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

          // ✅ Localization
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          home: loginUser?.sId == null ? LoginScreen() : const HomeScreen(),   
        ));
  }
}

class FancyDarkModeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FancyDarkModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600), // Tăng thời gian
        curve: Curves.easeInOutCubic, // Thêm hiệu ứng mượt
        width: 80,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: value
              ? const LinearGradient(
                  colors: [Color(0xFF232526), Color(0xFF414345)])
              : const LinearGradient(
                  colors: [Color(0xFFFFE000), Color(0xFF799F0C)]),
          boxShadow: [
            if (value)
              const BoxShadow(
                  color: Colors.black45, blurRadius: 6, offset: Offset(0, 3))
            else
              const BoxShadow(
                  color: Colors.orangeAccent,
                  blurRadius: 6,
                  offset: Offset(0, 3))
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 600),
              curve: Curves
                  .easeInOutCubic, // Thêm curve chuyển động cho vị trí icon
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic, // Mượt khi co giãn
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    value ? Icons.nightlight_round : Icons.wb_sunny,
                    color: value ? Colors.black : Colors.orange,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
