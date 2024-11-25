import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // Untuk koordinat OpenStreetMap
import 'package:flutter_map/flutter_map.dart'; // Plugin untuk OpenStreetMap
import 'package:prak_mobile/app/controller/auth_controller/gps_controller.dart';

class LocationView extends StatelessWidget {
  final GPSController gpsController = Get.put(GPSController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Location",
          style: TextStyle(
            fontFamily: 'Gotham',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Temukan Lokasi Anda",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() => Center(
                    child: Text(
                      gpsController.locationMessage.value,
                      textAlign: TextAlign.center,  // Mengatur teks agar rata tengah
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Row untuk menampilkan tombol berdampingan
                Obx(() => gpsController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => gpsController.getCurrentLocation(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        child: const Text("Dapatkan Lokasi",
                          style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => gpsController.openGoogleMaps(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("Buka di Google Maps",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (gpsController.currentPosition.value == null) {
                return Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: const LatLng(-6.2088, 106.8456), // Default koordinat
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.prak_mobile',
                        ),
                      ],
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Lokasi belum ditemukan\nSilakan cari lokasi terlebih dahulu",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    gpsController.currentPosition.value!.latitude,
                    gpsController.currentPosition.value!.longitude,
                  ),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.prak_mobile',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          gpsController.currentPosition.value!.latitude,
                          gpsController.currentPosition.value!.longitude,
                        ),
                        width: 80.0,
                        height: 80.0,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
