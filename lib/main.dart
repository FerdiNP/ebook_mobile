import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prak_mobile/app/controller/auth_controller/auth_controller.dart';
import 'package:prak_mobile/app/handler/notification_handler/notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  await FirebaseMessagingHandler().initLocalNotification();
  final AuthController _authController = Get.put(AuthController());

  runApp(
      GetMaterialApp(
        title: 'Book App',
        initialRoute: _authController.isLoggedIn.value ? Routes.HOME : Routes.LOGIN,
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          scaffoldBackgroundColor: Color(0xFF0f0f0f),
        ),
        getPages: AppPages.routes,
      )
  );
}