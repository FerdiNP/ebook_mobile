import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/auth_controller.dart';
import 'package:prak_mobile/app/modules/register/views/register_view.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPasswordInput = false; // State variable to toggle input screen

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer,
            image: const DecorationImage(
              image: AssetImage('assets/images/login_bg.png'), // Replace with the correct image path
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _showPasswordInput ? "Enter Password" : "Log in",
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 20),
                          _showPasswordInput ? _buildPasswordInput() : _buildEmailInput(),
                          const SizedBox(height: 16),
                          _showPasswordInput ? _buildLoginButton() : _buildContinueButton(),
                          if (!_showPasswordInput) ...[
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {}, // Define forgot password action
                              child: Text(
                                "Forgot password?",
                                style: theme.textTheme.bodyMedium!.copyWith(color: Colors.green),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildAlternativeLoginOptions(),
                            const SizedBox(height: 32),
                            _buildFacebookLoginButton(),
                            const SizedBox(height: 16),
                            _buildGoogleLoginButton(),
                            const SizedBox(height: 16),
                            _buildAppleLoginButton(),
                            const SizedBox(height: 32),
                            InkWell(
                              onTap: () {
                                // Tambahkan logika untuk berpindah halaman di sini
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()), // Ganti dengan halaman yang ingin dituju
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don’t have an account?",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    TextSpan(
                                      text: " Sign up",
                                      style: theme.textTheme.bodyMedium!.copyWith(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: const Color(0xFFEAF4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: const Color(0xFFEAF4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Switch to password input screen
          setState(() {
            _showPasswordInput = true;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCDE7BE),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Continue",
        style: TextStyle(color: Color(0xFF313333)),
      ),
    );
  }

  Widget _buildLoginButton() => Obx(() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCDE7BE),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _authController.isLoading.value
          ? null
          : () {
        _authController.loginUser(
          _emailController.text,
          _passwordController.text,
        );
      },
      child: _authController.isLoading.value
          ? CircularProgressIndicator()
          : Text('Login'),
    );
  });

  Widget _buildAlternativeLoginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: Color(0xFF313333))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or log in with:',
            style: TextStyle(color: const Color(0xFF939999)),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF313333))),
      ],
    );
  }

  Widget _buildFacebookLoginButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.facebook, color: Color(0xFF313333)),
      onPressed: () {},
      label: const Text(
        "Facebook",
        style: TextStyle(color: Color(0xFF313333)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEAF4F4),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.g_mobiledata, color: Color(0xFF313333)),
      onPressed: () {},
      label: const Text(
        "Google",
        style: TextStyle(color: Color(0xFF313333)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEAF4F4),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAppleLoginButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.apple, color: Color(0xFF313333)),
      onPressed: () {},
      label: const Text(
        "Apple",
        style: TextStyle(color: Color(0xFF313333)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEAF4F4),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
