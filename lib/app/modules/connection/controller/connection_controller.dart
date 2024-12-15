import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/modules/connection/views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final Set<String> excludedRoutes = {'/add-books'};
  bool _wasOffline = false;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final connectivityResult = connectivityResults.first;

    if (connectivityResult == ConnectivityResult.none) {
      _wasOffline = true;

      if (excludedRoutes.contains(Get.currentRoute)) {
        Get.snackbar(
          'No Internet',
          'Your internet connection is lost.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        if (Get.currentRoute != '/NoConnectionView') {
          Get.to(() => const NoConnectionView());
        }
      }
    } else {
      if (_wasOffline) {
        _wasOffline = false;
        Get.snackbar(
          'Connected',
          'You are back online.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      if (Get.currentRoute == '/NoConnectionView') {
        Get.back();
      }
    }
  }
}
