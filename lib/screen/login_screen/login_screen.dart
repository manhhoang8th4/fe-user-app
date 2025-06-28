import 'package:e_commerce_flutter/utility/extensions.dart';
import '../../utility/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterLogin(
            loginAfterSignUp: false,
            logo: const AssetImage('assets/images/logo.png'),
            onLogin: (LoginData logindata) {
              return context.userProvider.login(logindata);
            },
            onSignup: (SignupData data) {
              return context.userProvider.register(data);
            },
            onSubmitAnimationCompleted: () {
              if (context.userProvider.getLoginUsr()?.sId != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              }
            },
            onRecoverPassword: (_) => null,
            hideForgotPasswordButton: true,
            theme: LoginTheme(
              primaryColor: AppColor.darkGrey,
              accentColor: AppColor.darkOrange,
              buttonTheme: const LoginButtonTheme(
                backgroundColor: AppColor.darkOrange,
              ),
              cardTheme: const CardTheme(
                color: Colors.white,
                surfaceTintColor: Colors.white,
              ),
              titleStyle: const TextStyle(color: Colors.black),
            ),
          ),

          // 👇 Google Login Button
          Positioned(
            bottom: 270,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                  height: 24,
                ),
                label: const Text("Đăng nhập với Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  elevation: 4,
                ),
                onPressed: () async {
                  await context.userProvider.loginWithGoogle();
                  if (context.userProvider.getLoginUsr()?.sId != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
