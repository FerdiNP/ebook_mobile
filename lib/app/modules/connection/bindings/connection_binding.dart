import 'package:get/get.dart';
import 'package:prak_mobile/app/modules/connection/controller/connection_controller.dart';

class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionController>(ConnectionController(),permanent: true
    );
  }
}