import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../screen/change_password_screen/provider/change_password_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;

  const ChangePasswordScreen({super.key, required this.userId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _showForm = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;
  late final AnimationController _exitController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.03, 0))
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _showForm = true);
    });

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _exitController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChange() async {
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward(from: 0);
      return;
    }

    final provider = Provider.of<ChangePasswordProvider>(context, listen: false);
    final error = await provider.changePassword(
      userId: widget.userId,
      newPassword: newPasswordController.text,
    );

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr("change_password.success"))),
      );
      await _exitController.forward();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${tr("change_password.failed")}: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ChangePasswordProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr("change_password.title"),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(
            CurvedAnimation(parent: _exitController, curve: Curves.easeOut)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _showForm ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: AnimatedSlide(
                  offset: _showForm ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 500),
                  child: SlideTransition(
                    position: _shakeAnimation,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tr("change_password.heading"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: newPasswordController,
                                obscureText: !_showNewPassword,
                                decoration: InputDecoration(
                                  labelText: tr("change_password.new_password"),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_showNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() =>
                                          _showNewPassword = !_showNewPassword);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return tr("change_password.error_length");
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: !_showConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: tr("change_password.confirm_password"),
                                  prefixIcon: const Icon(Icons.lock_reset),
                                  suffixIcon: IconButton(
                                    icon: Icon(_showConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() => _showConfirmPassword =
                                          !_showConfirmPassword);
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) =>
                                    value != newPasswordController.text
                                        ? tr("change_password.error_mismatch")
                                        : null,
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          key: ValueKey("loading"),
                                        )
                                      : ElevatedButton.icon(
                                          key: const ValueKey("button"),
                                          icon: const Icon(Icons.save),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: _submitChange,
                                          label: Text(
                                            tr("change_password.button"),
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
