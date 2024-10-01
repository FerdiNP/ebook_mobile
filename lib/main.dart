import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/profile/profile_view.dart';

void main() {
  runApp(
      GetMaterialApp(
        title: 'Book App',
        initialRoute: '/',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          scaffoldBackgroundColor: Color(0xFF0f0f0f),
        ),
        getPages: [
          GetPage(name: '/', page: () => HomeView()),
          GetPage(name: '/profile', page: () => ProfileView()),
        ],
      )
  );
}