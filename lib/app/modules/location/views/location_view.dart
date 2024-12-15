import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/gps_controller.dart';
import 'package:prak_mobile/app/routes/app_pages.dart';

class LocationView extends StatelessWidget {
  final GPSController controller = Get.put(GPSController());
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toko Buku Terdekat',
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
            Get.offNamed(Routes.HOME);
          },
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.currentPosition.value != null
                    ? LatLng(
                  controller.currentPosition.value!.latitude,
                  controller.currentPosition.value!.longitude,
                )
                    : const LatLng(-7.250445, 112.768845),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: controller.mapMarkers,
                ),
              ],
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await controller.getCurrentLocation();
              if (controller.currentPosition.value != null) {
                mapController.move(
                  LatLng(
                    controller.currentPosition.value!.latitude,
                    controller.currentPosition.value!.longitude,
                  ),
                  15.0,
                );
              }
            },
            heroTag: 'getLocation',
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: controller.openGoogleMapsForBookstores,
            heroTag: 'openMap',
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            child: const Icon(Icons.map),
          ),
        ],
      ),
    );
  }
}
