import 'package:get/get.dart';
import 'package:prak_mobile/app/modules/book_view/book_page.dart';
import 'package:prak_mobile/app/modules/profile/profile_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () =>  ProfileView(),
    ),
    GetPage(
      name: _Paths.BOOKLIST,
      page: () => BookListPage(),
    ),
  ];
}
