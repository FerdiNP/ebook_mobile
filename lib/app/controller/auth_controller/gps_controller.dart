import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GPSController extends GetxController {
  var currentPosition = Rxn<Position>();
  var locationMessage = "Sedang Mencari Lat dan Long...".obs;
  RxBool isLoading = false.obs;

  Future <void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    isLoading.value = true;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled) {
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
      locationMessage.value =
      "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      locationMessage.value = 'Gagal mendapatkan lokasi';
    }
  }

  void openGoogleMaps() {
    if (currentPosition != null) {
      final url =
          'https://www.google.com/maps?q=${currentPosition.value!.latitude},${currentPosition.value!.longitude}';
      launchURL(url);
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}