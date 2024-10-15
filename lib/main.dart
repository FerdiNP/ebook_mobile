import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/profile/profile_view.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
      GetMaterialApp(
        title: 'Book App',
        initialRoute: '/home',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          scaffoldBackgroundColor: Color(0xFF0f0f0f),
        ),
        getPages: AppPages.routes,
      )
  );
}