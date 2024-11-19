import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/auth_controller.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class AccountView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Get.offNamed(Routes.HOME); // Fungsi kembali ke halaman Home
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 358),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Color(0xFFEAF4F4),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gotham',
                  ),
                ),
                SizedBox(height: 4), // Jarak kecil antara teks dan garis
                Container(
                  width: 130, // Sesuaikan dengan panjang teks
                  height: 2, // Ketebalan garis
                  color: Colors.greenAccent, // Warna garis
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/profile-picture.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ferdi Naufal",
                              style: const TextStyle(
                                color: Color(0xFFEAF4F4),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Gotham',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "ferdinp@gmail.com",
                              style: const TextStyle(
                                color: Color(0xFFC4CCCC),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Gotham',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.greenAccent,
                        size: 48,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildMenuItems(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        const Divider(
          height: 32,
          thickness: 1,
          color: Color(0xFF313333),
        ),
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Profile details',
          onTap: () {
          },
          showArrow: true,
        ),
        _buildMenuItem(
          icon: Icons.payment,
          title: 'Payment',
          onTap: () {
            Get.toNamed(Routes.TEST);
          },
          showArrow: true,
        ),
        _buildMenuItem(
          icon: Icons.subscriptions_outlined,
          title: 'Subscription',
          onTap: () {
          },
          showArrow: true,
        ),
        const Divider(
          height: 32,
          thickness: 1,
          color: Color(0xFF313333),
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'FAQs',
          onTap: () {
          },
          showArrow: true,
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            _authController.logout();
          },
          showArrow: false,
        ),
        _buildMenuItem(
          icon: Icons.book,
          title: 'Manage Book',
          onTap: () {
            Get.toNamed(Routes.MANAGE_BOOKS);
          },
          showArrow: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showArrow,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF272828),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFEAF4F4),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFEAF4F4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gotham',
                ),
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFEAF4F4),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
