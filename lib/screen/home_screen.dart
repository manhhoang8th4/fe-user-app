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
              title: Text('home'.tr()),
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.favorite),
              title: Text('favorite'.tr()),
              activeColor: Colors.red,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.shopping_cart),
              title: Text('cart'.tr()),
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: Text('profile'.tr()),
              activeColor: Colors.orange,
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

class _AppDrawerState extends State<AppDrawer> {
  bool showServices = false;
  bool showNewsfeed = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
        children: [
          _buildExpandableTile(
            title: 'services'.tr(),
            expanded: showServices,
            onTap: () => setState(() => showServices = !showServices),
            children: [
              _drawerSubItem('apple_warranty'.tr(), () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AppleWarrantyScreen()));
              }),
              _drawerSubItem('exchange_old_new'.tr(), () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ExchangeOldNewScreen()));
              }),
              _drawerSubItem('installment.title'.tr(), () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const InstallmentScreen()));
              }),
            ],
          ),
          const Divider(),
          _buildExpandableTile(
            title: 'newsfeed'.tr(),
            expanded: showNewsfeed,
            onTap: () => setState(() => showNewsfeed = !showNewsfeed),
            children: [
              _drawerSubItem('technology_news'.tr(), () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TechnologyNewsScreen()));
              }),
              _drawerSubItem('promotion.title'.tr(), () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PromotionScreen()));
              }),
            ],
          ),
          const Divider(),
          _drawerSubItem('language'.tr(), () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LanguageSelectorScreen(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _drawerSubItem(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 6, bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
      ],
    );
  }
}
