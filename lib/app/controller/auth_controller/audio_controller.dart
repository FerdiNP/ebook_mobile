import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variabel reaktif
  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = (state == PlayerState.playing);
    });
  }

  @override
  void onClose() {
    if (isPlaying.value) {
      _audioPlayer.stop();
    }
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playAudio(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      try {
        await _audioPlayer.play(DeviceFileSource(filePath));
        isPlaying.value = true;
      } catch (e) {
        print("Failed to play audio: $e");
      }
    } else {
      print("File does not exist: $filePath");
    }
  }

  /// Fungsi untuk menjeda audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPlaying.value = false;
  }

  /// Fungsi untuk melanjutkan pemutaran setelah dijeda
  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    isPlaying.value = true;
  }

  /// Fungsi untuk menghentikan audio
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
  }

  /// Fungsi untuk seek ke posisi tertentu
  void seekAudio(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }

  Future<void> setAudio(String path) async {
    await _audioPlayer.setSourceDeviceFile(path);
    duration.value = await _audioPlayer.getDuration() ?? Duration.zero;
  }
}
