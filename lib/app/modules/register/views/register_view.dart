import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordPage = false;

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
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer,
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          !_isPasswordPage ? "Register" : "Set Your Password",
                          style: theme.textTheme.headlineMedium,
                        ),
                        SizedBox(height: 20),
                        if (!_isPasswordPage) ...[
                          _buildEmailInput(),
                          SizedBox(height: 16),
                          _buildContinueButton(),
                        ] else ...[
                          _buildPasswordInput(),
                          SizedBox(height: 16),
                          _buildRegisterButton(),
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
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hello, Please create your password."),
        SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Obx(() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _authController.isLoading.value
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isPasswordPage = true; // Move to the password page
            });
          }
        },
        child: _authController.isLoading.value
            ? CircularProgressIndicator()
            : Text('Continue', style: TextStyle(fontSize: 16)),
      );
    });
  }

  Widget _buildRegisterButton() {
    return Obx(() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
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
            : Text('Register', style: TextStyle(fontSize: 16)),
      );
    });
  }
}
