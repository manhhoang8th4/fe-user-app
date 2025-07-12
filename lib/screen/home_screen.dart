import 'package:e_commerce_flutter/screen/extra_screens/apple_warranty_screen.dart';
import 'package:e_commerce_flutter/screen/extra_screens/exchange_old_new_screen.dart';
import 'package:e_commerce_flutter/screen/extra_screens/installment_screen.dart';
import 'package:e_commerce_flutter/screen/extra_screens/promotion_screen.dart';
import 'package:e_commerce_flutter/screen/extra_screens/technology_news_screen.dart';
import 'package:e_commerce_flutter/screen/product_cart_screen/cart_screen.dart';
import 'package:e_commerce_flutter/screen/product_favorite_screen/favorite_screen.dart';
import 'package:e_commerce_flutter/screen/product_list_screen/product_list_screen.dart';
import 'package:e_commerce_flutter/screen/profile_screen/language_selector_screen.dart.dart';
import 'package:e_commerce_flutter/screen/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widget/page_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Widget> screens = [
    ProductListScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Scaffold(
        drawer: const AppDrawer(),
        bottomNavigationBar: BottomNavyBar(
          itemCornerRadius: 10,
          selectedIndex: newIndex,
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: Text('home.title'.tr()),
              activeColor: Colors.deepOrange,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.favorite),
              title: Text('favorite.title'.tr()),
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.shopping_cart),
              title: Text('cart_bottom.title'.tr()),
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: Text('profile.title'.tr()),
              activeColor: Colors.deepOrange,
              inactiveColor: Colors.grey,
            ),
          ],
          onItemSelected: (currentIndex) {
            setState(() {
              newIndex = currentIndex;
            });
          },
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: HomeScreen.screens[newIndex],
        ),
      ),
    );
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  bool showServices = false;
  bool showNewsfeed = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildExpandableTile(
              title: 'services.title'.tr(),
              icon: Icons.build_rounded,
              expanded: showServices,
              onTap: () => setState(() => showServices = !showServices),
              children: [
                _drawerSubItem(
                  'apple_warranty.title'.tr(),
                  Icons.verified_user_outlined,
                  () => _navigateTo(const AppleWarrantyScreen()),
                ),
                _drawerSubItem(
                  'exchange_old_new.title'.tr(),
                  Icons.sync_alt,
                  () => _navigateTo(const ExchangeOldNewScreen()),
                ),
                _drawerSubItem(
                  'installment.title'.tr(),
                  Icons.payments_outlined,
                  () => _navigateTo(const InstallmentScreen()),
                ),
              ],
            ),
            const Divider(thickness: 1, indent: 20, endIndent: 20),
            _buildExpandableTile(
              title: 'newsfeed.title'.tr(),
              icon: Icons.newspaper_outlined,
              expanded: showNewsfeed,
              onTap: () => setState(() => showNewsfeed = !showNewsfeed),
              children: [
                _drawerSubItem(
                  'technology_news.title'.tr(),
                  Icons.memory_outlined,
                  () => _navigateTo(const TechnologyNewsScreen()),
                ),
                _drawerSubItem(
                  'promotion.title'.tr(), // ✅ SỬA Ở ĐÂY
                  Icons.local_offer_outlined,
                  () => _navigateTo(const PromotionScreen()),
                ),
              ],
            ),
            const Divider(thickness: 1, indent: 20, endIndent: 20),
            _buildSimpleItem(
              icon: Icons.language_outlined,
              text: 'language.title'.tr(),
              onTap: () => _navigateTo(const LanguageSelectorScreen()),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFFF3E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrangeAccent.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Row(
          children: [
            Hero(
              tag: 'profile-avatar',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFCC80), Color(0xFFFFE0B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: Colors.deepOrange[400],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'home_drawer.greeting'.tr(), // 👈 Sử dụng key thay vì text cố định
      style: TextStyle(
        color: Colors.black.withOpacity(0.85),
        fontSize: 14,
      ),
    ),
    Text(
      'home_drawer.welcome'.tr(), // 👈 Sử dụng key thay vì text cố định
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
Widget _buildExpandableTile({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      initiallyExpanded: expanded,
      onExpansionChanged: (_) => onTap(),
      children: children,
    );
  }

  Widget _drawerSubItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrangeAccent),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop(); // Đóng drawer
        onTap();
      },
    );
  }

  Widget _buildSimpleItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(text),
      onTap: () {
        Navigator.of(context).pop(); // Đóng drawer
        onTap();
      },
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
