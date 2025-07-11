import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../main.dart';
import '../../utility/app_color.dart';
import '../../utility/constants.dart';
import '../../utility/extensions.dart';
import '../../utility/animation/open_container_wrapper.dart';
import '../../widget/navigation_tile.dart';
import '../change_password_screen/provider/change_password_provider.dart';
import '../login_screen/login_screen.dart';
import '../my_address_screen/my_address_screen.dart';
import '../my_order_screen/my_order_screen.dart';
import '../profile_screen/provider/profile_provider.dart';
import '../change_password_screen/change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    final user = context.userProvider.getLoginUsr();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('my_account'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ───────────── Avatar ─────────────
          Selector<ProfileProvider, int>(
            selector: (_, p) => p.hashCode,
            builder: (_, __, ___) {
              final provider = context.profileProvider;

              final imageProvider = provider.hasPickedAvatar
                  ? FileImage(provider.pickedAvatarFile!)
                  : (provider.avatarUrl?.isNotEmpty == true
                      ? NetworkImage(provider.avatarUrl!) as ImageProvider
                      : const AssetImage('assets/images/profile_pic.png'));

              return SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(radius: 80, backgroundImage: imageProvider),
                    Positioned(
                      child: GestureDetector(
                        onTap: () => _showAvatarActionSheet(context, provider),
                        child: const CircleAvatar(
                          backgroundColor: Color.fromARGB(179, 2, 2, 2),
                          radius: 12,
                          child: Icon(Icons.camera_alt,
                              color: AppColor.darkOrange),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // ───────────── User name ─────────────
          Center(
            child: Text(
              user?.name?.toString() ?? 'Guest',
              style: titleStyle,
            ),
          ),
          const SizedBox(height: 20),

          // ───────────── Dark mode toggle ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr(''),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Obx(() => FancyDarkModeSwitch(
                    value: themeController.isDarkMode.value,
                    onChanged: (_) => themeController.toggleTheme(),
                  ))
            ],
          ),
          const SizedBox(height: 20),

          // ───────────── My Orders ─────────────
          OpenContainerWrapper(
            nextScreen: const MyOrderScreen(),
            child: NavigationTile(
              icon: Icons.list,
              title: tr('my_orders'),
            ),
          ),
          const SizedBox(height: 15),

          // ───────────── My Addresses ─────────────
          OpenContainerWrapper(
            nextScreen: const MyAddressPage(),
            child: NavigationTile(
              icon: Icons.location_on,
              title: tr('my_addresses'),
            ),
          ),
          const SizedBox(height: 20),

          // ───────────── Change Password ─────────────
          OpenContainerWrapper(
            nextScreen: ChangeNotifierProvider(
              create: (_) => ChangePasswordProvider(),
              child: ChangePasswordScreen(
                userId: user?.sId ?? '',
              ),
            ),
            child: NavigationTile(
              icon: Icons.change_circle,
              title: tr('change_password'),
            ),
          ),
          const SizedBox(height: 20),

          // ───────────── Logout ─────────────
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.darkOrange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                context.userProvider.logOutUser();
                Get.offAll(() => LoginScreen());
              },
              child: Text(
                tr('logout'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarActionSheet(BuildContext ctx, ProfileProvider provider) {
    final userId = ctx.userProvider.getLoginUsr()?.sId ?? '';

    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(tr('choose_new_photo')),
            onTap: () async {
              Navigator.pop(ctx);
              await provider.pickAvatar();
              if (provider.hasPickedAvatar && userId.isNotEmpty) {
                await provider.uploadAvatar(userId);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(tr('remove_current_photo')),
            onTap: () async {
              Navigator.pop(ctx);
              if (userId.isNotEmpty) {
                await provider.removeAvatar(userId);
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
