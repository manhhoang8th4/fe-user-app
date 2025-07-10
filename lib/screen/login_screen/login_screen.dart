import 'package:e_commerce_flutter/screen/login_screen/forgot_password_screen.dart';
import 'package:e_commerce_flutter/screen/login_screen/provider/user_provider.dart';
import 'package:e_commerce_flutter/screen/login_screen/signin_screen.dart';
import 'package:e_commerce_flutter/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final loginData = LoginData(name: username, password: password);
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
        const SnackBar(content: Text('Google login failed')),
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
                const Icon(Icons.lock_outline, size: 100, color: Colors.black87),
                const SizedBox(height: 20),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Username
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 15),

                // Password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text('Quên mật khẩu?'),
                      )
                  ],
                ),
                const SizedBox(height: 25),

                // Sign In button
                MyButton(
                  text: "Sign In",
                  onTap: () => signUserIn(context),
                ),
                const SizedBox(height: 40),

                // Or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[400]),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or continue with"),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Social login
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
                      backgroundImage: AssetImage('assets/images/apple.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
