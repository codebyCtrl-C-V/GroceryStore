import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Handler cho notification đến khi app đang ở background/terminated.
/// PHẢI là top-level function (ngoài class) vì chạy trên isolate riêng.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Không cần làm gì nhiều ở đây — hệ điều hành tự hiện notification
  // khi app ở background nếu payload có "notification" field.
  debugPrint('Background message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Callback khi user bấm vào notification (app đang mở, background, hoặc terminated)
  /// Truyền route/data để LoginScreen hoặc màn hình gọi hàm này tự điều hướng.
  void Function(Map<String, dynamic> data)? onNotificationTap;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Gọi 1 lần khi app khởi động, SAU KHI Firebase.initializeApp() đã chạy.
  Future<void> init() async {
    // Xin quyền hiện notification (bắt buộc trên iOS, Android 13+ cũng cần)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus}');

    // Khởi tạo local notifications để hiện popup khi app đang FOREGROUND
    // (mặc định FCM không tự hiện notification khi app đang mở)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;
          onNotificationTap?.call(data);
        }
      },
    );

    // Tạo notification channel cho Android (bắt buộc từ Android 8+)
    const channel = AndroidNotificationChannel(
      'order_updates', // id — phải khớp với channel_id gửi từ backend
      'Cập nhật đơn hàng',
      description: 'Thông báo trạng thái đơn hàng: xác nhận, đang giao...',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Lấy FCM token — token này gửi lên backend để backend biết gửi noti tới đâu
    _fcmToken = await _fcm.getToken();
    debugPrint('FCM Token: $_fcmToken');

    // Token có thể đổi (reinstall app, clear data...) — lắng nghe để cập nhật lại backend
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      onTokenRefresh?.call(newToken);
    });

    // App đang mở (foreground) — tự hiện local notification vì FCM không tự hiện
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // User bấm vào notification khi app đang background (chưa bị kill)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTap?.call(message.data);
    });

    // App bị kill hẳn, user bấm notification để mở lại app
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      onNotificationTap?.call(initialMessage.data);
    }
  }

  /// Callback báo cho UserProvider biết token vừa đổi, để gọi API cập nhật lên backend
  void Function(String newToken)? onTokenRefresh;

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'order_updates',
          'Cập nhật đơn hàng',
          channelDescription: 'Thông báo trạng thái đơn hàng',
          icon: 'ic_notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
