import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      // Show a snackbar or dialog for empty email
      Get.snackbar('Error', 'Please enter an email address.');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email sent to $email.',
        backgroundColor: Colors.green, // Set the background color to green
        colorText: Colors.white, // Set the text color to white for contrast
      );
      Get.offNamed(Routes.LOGIN); // Navigate back to login after sending email
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red, // Set the background color to red
        colorText: Colors.white, // Set the text color to white for contrast
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offNamed(Routes.LOGIN);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('Back To Login Page', style: TextStyle(color: Colors.white)),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer,
            image: const DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
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
                    "Recover Password",
                    style: theme.textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      'Forgot your password? Don’t worry, enter your email to reset your current password.',
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
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 326,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffeaf4f4),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                            child: TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  color: const Color(0xff929999),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffcde7be),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: TextButton(
                                                  onPressed: resetPassword,
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color: const Color(0xff303333),
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,  // Align children to the start
                              children: [
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.REGISTER);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Don’t have an account?",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w100),
                                          ),
                                          TextSpan(
                                            text: " Sign up!",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                color: Color(0xFFCDE7BE),
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .start, // Align "Don’t have an account?" to the start
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
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
}
