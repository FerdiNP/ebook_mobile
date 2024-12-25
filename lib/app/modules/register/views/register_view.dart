import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/auth_controller.dart';

import '../../../routes/app_pages.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Register",
                    style: theme.textTheme.headlineMedium!.copyWith(
                      color: Colors.white,fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFF313333).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,  // Align children to the start
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Looks like you don’t have an account. Let’s create a new account for you.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: const Color(0xffeaf4f4),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildEmailInput(),
                              const SizedBox(height: 16),
                              _buildPasswordInput(),
                              const SizedBox(height: 16),
                              _buildRegisterButton(),
                              const SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.LOGIN);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Alredy have an account?",
                                          style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.w100),
                                        ),
                                        TextSpan(
                                          text: " Log In!",
                                          style: theme.textTheme.bodyMedium!.copyWith(color: Color(0xFFCDE7BE), fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,  // Align "Don’t have an account?" to the start
                                  ),
                                )
                              ],
                          ),
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
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: const Color(0xFFEAF4F4),
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
    bool _isPasswordVisible = false; // Local state for password visibility

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible, // Use the visibility state
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: const Color(0xFFEAF4F4),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                });
              },
              child: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return Obx(() {
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
          _authController.registerUser(
            _emailController.text,
            _passwordController.text,
          );
        },
        child: _authController.isLoading.value
            ? CircularProgressIndicator()
            : Text('Register',
          style: TextStyle(color: Colors.black),
        ),
      );
    });
  }
}
