import 'package:e_commerce_flutter/screen/login_screen/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import '../../../models/auth_data.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser(BuildContext context) async {
    final email = emailController.text.trim();
    final username = usernameController.text;
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('passwords_not_match'.tr())),
      );
      return;
    }

    final signupData = CustomSignupData(
      name: username,
      email: email,
      password: password,
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final error = await userProvider.register(signupData);

    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Icon(Icons.person_add_alt_1,
                    size: 100, color: Colors.black87),
                const SizedBox(height: 20),
                Text(
                  'create_account_title'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                MyTextField(
                  controller: emailController,
                  hintText: 'email'.tr(),
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Username
                MyTextField(
                  controller: usernameController,
                  hintText: 'username'.tr(),
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'password'.tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'confirm_password'.tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                MyButton(
                  text: "sign_up".tr(),
                  onTap: () => registerUser(context),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("already_have_account".tr(),
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("login_now".tr(),
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
