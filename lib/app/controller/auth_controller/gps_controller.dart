import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GPSController extends GetxController {
  var currentPosition = Rxn<Position>();
  var locationMessage = "".obs;
  RxBool isLoading = false.obs;
  RxList<Marker> mapMarkers = <Marker>[].obs;
  RxList<Map<String, dynamic>> nearbyBookstores = <Map<String, dynamic>>[].obs;

  static const double searchRadius = 20000; // 2km dalam meter

  Future<void> searchNearbyBookstores() async {
    if (currentPosition.value == null) return;

    try {
      isLoading.value = true;

      // Membuat bounding box untuk area pencarian 2km
      final lat = currentPosition.value!.latitude;
      final lon = currentPosition.value!.longitude;
      final double radiusInDegrees = searchRadius / 111320.0;

      final query = '''
        [out:json][timeout:25];
        (
          node["shop"="books"](${lat - radiusInDegrees},${lon - radiusInDegrees},${lat + radiusInDegrees},${lon + radiusInDegrees});
          way["shop"="books"](${lat - radiusInDegrees},${lon - radiusInDegrees},${lat + radiusInDegrees},${lon + radiusInDegrees});
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        nearbyBookstores.clear();
        mapMarkers.clear();

        mapMarkers.add(
          Marker(
            point: LatLng(lat, lon),
            width: 80.0,
            height: 80.0,
            child: Column(
              children: [
                const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40.0,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Lokasi Anda',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );

        // Tambahkan circle untuk radius pencarian
        mapMarkers.add(
          Marker(
            point: LatLng(lat, lon),
            width: searchRadius * 2,
            height: searchRadius * 2,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        );

        for (var element in elements) {
          if (element['type'] == 'node') {
            double distance = Geolocator.distanceBetween(
              lat,
              lon,
              element['lat'],
              element['lon'],
            );

            if (distance <= searchRadius) {
              final store = {
                'name': element['tags']['name'] ?? 'Toko Buku',
                'latitude': element['lat'],
                'longitude': element['lon'],
                'distance': distance,
                'address': element['tags']['addr:street'] ?? '',
              };

              nearbyBookstores.add(store);

              // Tambahkan marker toko buku
              mapMarkers.add(
                Marker(
                  point: LatLng(store['latitude'], store['longitude']),
                  width: 160.0,
                  height: 80.0,
                  child: GestureDetector(
                    onTap: () => _showBookstoreDetails(store),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.book,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                store['name'],
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${(distance / 1000).toStringAsFixed(1)} km',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        }

        // Sort bookstores by distance
        nearbyBookstores.sort((a, b) =>
            (a['distance'] as double).compareTo(b['distance'] as double)
        );
      }
    } catch (e) {
      print('Error searching bookstores: $e');
      Get.snackbar(
        'Error',
        'Gagal mencari toko buku: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showBookstoreDetails(Map<String, dynamic> store) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              store['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (store['address'].isNotEmpty) ...[
              Text('Alamat: ${store['address']}'),
              const SizedBox(height: 8),
            ],
            Text(
              'Jarak: ${(store['distance'] / 1000).toStringAsFixed(1)} km',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => openDirectionsToBookstore(store),
                child: const Text('Petunjuk Arah'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    isLoading.value = true;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location service not enabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      currentPosition.value = position;
      locationMessage.value = "Lokasi ditemukan";

      // Cari toko buku di sekitar
      await searchNearbyBookstores();

    } catch (e) {
      locationMessage.value = 'Gagal mendapatkan lokasi: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

    void openGoogleMapsForBookstores() async {
      if (currentPosition.value == null) {
        Get.snackbar('Error', 'Lokasi belum ditemukan');
        return;
      }

      final url = Uri.parse(
          'https://www.google.com/maps/search/toko+buku/@${currentPosition.value!.latitude},${currentPosition.value!.longitude},15z'
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Tidak dapat membuka Google Maps');
      }
    }

    void openDirectionsToBookstore(Map<String, dynamic> store) async {
      if (currentPosition.value == null) {
        Get.snackbar('Error', 'Lokasi awal belum ditemukan');
        return;
      }

      final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=${currentPosition.value!.latitude},${currentPosition.value!.longitude}&destination=${store['latitude']},${store['longitude']}&travelmode=driving'
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Tidak dapat membuka navigasi');
      }
    }

    double calculateDistance(Map<String, dynamic> store) {
      if (currentPosition.value == null) return 0.0;

      return Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        store['latitude'],
        store['longitude'],
      );
    }
 }