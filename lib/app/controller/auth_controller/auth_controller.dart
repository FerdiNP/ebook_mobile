import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/modules/login/views/login_views.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn.value = _prefs.containsKey('user_token');
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);
      Get.off(LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _prefs.setString('user_token', _auth.currentUser!.uid); // Simpan
      Get.snackbar('Success', 'Login berhasil',
          backgroundColor: Colors.green);
      isLoggedIn.value = true;
      Get.offAllNamed(Routes.HOME);
    } catch (error) {
      Get.snackbar('Error', 'Login gagal: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
  void logout() {
    _prefs.remove('user_token');
    isLoggedIn.value = false;
    _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
