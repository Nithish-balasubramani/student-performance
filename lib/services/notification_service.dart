import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
  // Handle background message
}

/// Service for handling local and push notifications
/// Shows alerts for low moisture, rain prediction, and system errors
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _initialized = false;
  String? _fcmToken;

  /// Get FCM token for this device
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Initialize Firebase Messaging
    await _initializeFirebaseMessaging();

    _initialized = true;
  }

  /// Initialize Firebase Cloud Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted notification permission');
    } else {
      print('❌ User declined notification permission');
      return;
    }

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $_fcmToken');
    // TODO: Send this token to your backend server to send notifications

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('🔄 FCM Token refreshed: $newToken');
      // TODO: Update token on your backend
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a notification
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      // Show local notification when app is in foreground
      await _showNotificationFromRemoteMessage(message);
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 Notification tapped: ${message.data}');
    // Navigate to specific screen based on message data
    if (message.data['type'] == 'moisture') {
      // Navigate to dashboard or moisture screen
    } else if (message.data['type'] == 'pump') {
      // Navigate to control screen
    }
  }

  /// Show notification from remote message
  Future<void> _showNotificationFromRemoteMessage(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fcm_default_channel',
      'Push Notifications',
      channelDescription: 'Firebase Cloud Messaging notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      details,
      payload: message.data['payload'],
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to specific screen if needed
    print('Notification tapped: ${response.payload}');
  }

  /// Show low moisture alert
  Future<void> showLowMoistureAlert(double moistureLevel) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'moisture_alerts',
      'Moisture Alerts',
      channelDescription: 'Notifications for low soil moisture levels',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      'Low Soil Moisture ⚠️',
      'Moisture level is at ${moistureLevel.toStringAsFixed(1)}%. Consider watering your plants.',
      details,
      payload: 'low_moisture',
    );
  }

  /// Show rain prediction alert
  Future<void> showRainPredictionAlert() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'weather_alerts',
      'Weather Alerts',
      channelDescription: 'Rain and weather notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      'Rain Expected 🌧️',
      'Rain is predicted in your area. Irrigation may not be needed.',
      details,
      payload: 'rain_prediction',
    );
  }

  /// Show system error notification
  Future<void> showSystemError(String errorMessage) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'system_alerts',
      'System Alerts',
      channelDescription: 'Critical system errors and warnings',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      3,
      'System Error ❌',
      errorMessage,
      details,
      payload: 'system_error',
    );
  }

  /// Show pump status notification
  Future<void> showPumpStatusNotification(bool isOn) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pump_alerts',
      'Pump Alerts',
      channelDescription: 'Pump on/off notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      4,
      isOn ? 'Pump Activated 💧' : 'Pump Deactivated',
      isOn
          ? 'Water pump is now running'
          : 'Water pump has been turned off',
      details,
      payload: 'pump_status',
    );
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
