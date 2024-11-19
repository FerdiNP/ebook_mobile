import 'package:get/get.dart';
import 'package:prak_mobile/app/modules/account/views/account_view.dart';
import 'package:prak_mobile/app/modules/admin/views/admin_view.dart';
import 'package:prak_mobile/app/modules/book_view/book_page.dart';
import 'package:prak_mobile/app/modules/detail_book/detail_book.dart';
import 'package:prak_mobile/app/modules/login/views/login_views.dart';
import 'package:prak_mobile/app/modules/profile/profile_view.dart';
import 'package:prak_mobile/app/modules/profile_detail/view.dart';

import '../modules/book_manage/views/book_add_view.dart';
import '../modules/book_manage/views/book_manage_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
    ),
    GetPage(
      name: _Paths.ADMIN,
      page: () => AdminPage(),
    ),
    GetPage(
      name: _Paths.MANAGE_BOOKS,
      page: () => ManageBooksPage(),
    ),
    GetPage(
      name: _Paths.ADD_BOOKS,
      page: () => AddBooksPage(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountView(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () =>  ProfileView(),
    ),
    GetPage(
      name: _Paths.BOOKLIST,
      page: () => BookListPage(),
    ),
    GetPage(
      name: _Paths.BOOK_DETAIL,
      page: () => BookDetailPage(),
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => TestView(),
    ),
  ];
}
