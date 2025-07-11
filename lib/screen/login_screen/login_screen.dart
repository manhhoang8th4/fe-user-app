import 'package:e_commerce_flutter/screen/login_screen/forgot_password_screen.dart';
import 'package:e_commerce_flutter/screen/login_screen/provider/user_provider.dart';
import 'package:e_commerce_flutter/screen/login_screen/signin_screen.dart';
import 'package:e_commerce_flutter/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import '../../../models/auth_data.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final loginData = CustomLoginData(email: email, password: password);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final error = await userProvider.login(loginData);

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  void signInWithGoogle(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loginWithGoogle();
    if (userProvider.getLoginUsr()?.sId != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('google_login_failed'.tr())),
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
                const Icon(Icons.lock_outline,
                    size: 100, color: Colors.black87),
                const SizedBox(height: 20),
                Text(
                  'welcome_back'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                MyTextField(
                  controller: emailController,
                  hintText: 'email'.tr(),
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                MyTextField(
                  controller: passwordController,
                  hintText: 'password'.tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: Text('forgot_password'.tr()),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                MyButton(
                  text: "sign_in".tr(),
                  onTap: () => signUserIn(context),
                ),
                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or_continue_with".tr()),
                    ),
                    Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => signInWithGoogle(context),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/google.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/fb.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('not_a_member'.tr(),
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignInScreen()),
                        );
                      },
                      child: Text(
                        'register_now'.tr(),
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
