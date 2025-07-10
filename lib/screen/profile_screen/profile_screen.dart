import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ───────────── Avatar + Action Sheet ─────────────
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
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(179, 2, 2, 2),
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

          // ───────────── Tên người dùng ─────────────
          Center(
            child: Text(
              user?.name ?? '',
              style: titleStyle,
            ),
          ),
          const SizedBox(height: 20),

          // ───────────── Chuyển theme ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
<<<<<<< HEAD
            
            Obx(() => FancyDarkModeSwitch(
  value: themeController.isDarkMode.value,
  onChanged: (_) => themeController.toggleTheme(),
))

=======
              Obx(() => FancyDarkModeSwitch(
                    value: themeController.isDarkMode.value,
                    onChanged: (_) => themeController.toggleTheme(),
                  ))
>>>>>>> dfe800f5937e0fa3896eb626cb9b5dd29100a054
            ],
          ),
          const SizedBox(height: 20),

          // ───────────── Navigation Items ─────────────
          const OpenContainerWrapper(
            nextScreen: MyOrderScreen(),
            child: NavigationTile(icon: Icons.list, title: 'My Orders'),
          ),
          const SizedBox(height: 15),
          const OpenContainerWrapper(
            nextScreen: MyAddressPage(),
            child:
                NavigationTile(icon: Icons.location_on, title: 'My Addresses'),
          ),
          const SizedBox(height: 20),

          // 👇 ĐÃ TRUYỀN userId vào ChangePasswordScreen
          OpenContainerWrapper(
            nextScreen: ChangeNotifierProvider(
              create: (_) => ChangePasswordProvider(),
              child: ChangePasswordScreen(
                userId: user?.sId ?? '',
              ),
            ),
            child: const NavigationTile(
              icon: Icons.change_circle,
              title: 'Change Password',
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
                Get.offAll(LoginScreen());
              },
              child: const Text('Logout', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── Bottom Sheet Action ─────────────
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
            title: const Text('Choose new photo'),
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
            title: const Text('Remove current photo'),
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
