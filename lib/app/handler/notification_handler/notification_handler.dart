import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Handler untuk menangani pesan saat aplikasi berada di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Pesan diterima di background: ${message.notification?.title}');
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Inisialisasi kanal notifikasi untuk Android
  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'channel_notification',
    'High Importance Notification',
    description: 'Used For Notification',
    importance: Importance.high, // Ubah ke Importance.high
  );

  // Inisialisasi plugin notifikasi lokal
  final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotification() async {
    // Minta izin untuk menampilkan notifikasi
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Izin yang diberikan pengguna: ${settings.authorizationStatus}');

    // Mendapatkan token FCM
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Saat aplikasi dalam keadaan terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Pesan saat aplikasi terminated: ${message.notification?.title}");
      }
    });

    // Saat aplikasi dalam keadaan background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Mendengarkan pesan saat aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      // Tampilkan notifikasi lokal
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );

      print('Pesan diterima saat aplikasi di foreground: ${message.notification?.title}');
    });

    // Handler ketika pesan dibuka dari notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Pesan dibuka dari notifikasi: ${message.notification?.title}');
    });
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await _localNotification.initialize(settings);
  }
}
