import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/gps_controller.dart';

class MapView extends StatelessWidget {
  final GPSController gpsController = Get.put(GPSController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Lokasi Saya"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (gpsController.currentPosition.value == null) {
          return const Center(
            child: Text(
              "Lokasi belum ditemukan. Silakan cari lokasi terlebih dahulu.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              gpsController.currentPosition.value!.latitude,
              gpsController.currentPosition.value!.longitude,
            ),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("current_location"),
              position: LatLng(
                gpsController.currentPosition.value!.latitude,
                gpsController.currentPosition.value!.longitude,
              ),
              infoWindow: const InfoWindow(title: "Lokasi Saya"),
            ),
          },
        );
      }),
    );
  }
}
