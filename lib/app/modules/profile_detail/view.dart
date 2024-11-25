import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prak_mobile/app/controller/auth_controller/voice_controller.dart';


class TestView extends GetView<VoiceController> {
  final VoiceController controller = Get.put(VoiceController()); // Ensure the controller is initialized
  TestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text Example"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: [
              Obx(() => Text(
          controller.text.value,
          style: const TextStyle(fontSize: 24),
    )),
    const SizedBox(height: 20),
    Obx(() => controller.isListening.value
    ? ElevatedButton(
    onPressed: controller.stopListening,
    child: const Text("Stop Listening"),
    )
        : ElevatedButton(
    onPressed: controller.startListening,
    child: const Text("Start Listening"),
    )),
    ],
    ),
    ),
    );
    }
}
