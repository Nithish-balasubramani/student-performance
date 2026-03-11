# 📱 Push Notifications Setup Guide

Firebase Cloud Messaging (FCM) has been successfully integrated into your Smart Irrigation System app!

## ✅ What's Been Implemented

- ✅ Firebase Messaging SDK integrated
- ✅ Push notifications (foreground, background, terminated)
- ✅ Local notifications for in-app alerts
- ✅ Notification permission handling (iOS & Android)
- ✅ FCM token generation and refresh
- ✅ Notification tap handling with navigation
- ✅ Android 13+ notification permissions

## 🚀 Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

When the app starts, you'll see the **FCM Token** printed in the console:
```
📱 FCM Token: fA7jH9kLmN3pQ5rT8vW0xY2zA4bC6dE8fG0hI2jK4lM6nO8pQ0rS2tU4vW6xY8zA
```

**Copy this token** - you'll need it to send notifications from your backend!

### 3. Test Local Notifications

The app already has local notification methods you can call:

```dart
// In your Dart code
NotificationService().showLowMoistureAlert(25.0);
NotificationService().showRainPredictionAlert();
NotificationService().showPumpStatusNotification(true);
NotificationService().showSystemError('Connection lost!');
```

## 🔧 Backend Setup (Send Push Notifications)

### Option A: Node.js Backend

1. **Install dependencies:**
```bash
npm install firebase-admin express
```

2. **Get Service Account Key:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Go to **Project Settings** → **Service Accounts**
   - Click **Generate New Private Key**
   - Save as `serviceAccountKey.json`

3. **Run the backend example:**
```bash
node backend_notification_example.js
```

4. **Send a test notification:**
```javascript
// In backend_notification_example.js, replace DEVICE_TOKEN with your actual token
const DEVICE_TOKEN = 'your_fcm_token_here';
sendToDevice(DEVICE_TOKEN);
```

### Option B: Python Backend

1. **Install dependencies:**
```bash
pip install firebase-admin flask
```

2. **Get Service Account Key** (same as above)

3. **Run the backend example:**
```bash
python backend_notification_example.py
```

4. **Send a test notification:**
```python
# In backend_notification_example.py
DEVICE_TOKEN = 'your_fcm_token_here'
send_to_device(DEVICE_TOKEN)
```

## 📨 Test Push Notifications (No Backend Required)

### Using Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Cloud Messaging** (left sidebar)
4. Click **Send your first message**
5. Fill in:
   - **Notification title:** "Test Notification"
   - **Notification text:** "Your irrigation system is working!"
6. Click **Next**
7. Select **Send test message**
8. **Paste your FCM token** (from app console)
9. Click **Test**

### Using curl Command

```bash
# Get your Server Key from Firebase Console > Project Settings > Cloud Messaging

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "YOUR_DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Low Moisture Alert",
      "body": "Soil moisture is at 25%. Time to water!"
    },
    "data": {
      "type": "moisture",
      "level": "25"
    }
  }'
```

## 📱 Notification Types & Usage

### 1. **Foreground Notifications**
When the app is open, notifications appear as local notifications.

### 2. **Background Notifications**
When the app is minimized, the system displays the notification.

### 3. **Terminated Notifications**
When the app is closed, tapping the notification launches the app.

### 4. **Data-Only Notifications**
Silent notifications that don't show a popup but can trigger actions.

## 🎯 Notification Scenarios

### Smart Irrigation Use Cases

```dart
// Scenario 1: Low moisture detected by sensor
NotificationService().showLowMoistureAlert(18.5);

// Scenario 2: Rain predicted - pause irrigation
NotificationService().showRainPredictionAlert();

// Scenario 3: Pump status changed
NotificationService().showPumpStatusNotification(true);

// Scenario 4: System error
NotificationService().showSystemError('Sensor connection lost');
```

### Backend Integration Examples

**Send notification when sensor detects low moisture:**
```javascript
// Node.js
const admin = require('firebase-admin');

async function notifyLowMoisture(userToken, moistureLevel) {
  const message = {
    notification: {
      title: 'Low Soil Moisture ⚠️',
      body: `Moisture at ${moistureLevel}%. Consider watering.`,
    },
    data: {
      type: 'moisture',
      level: moistureLevel.toString(),
      action: 'open_dashboard'
    },
    token: userToken,
  };
  
  await admin.messaging().send(message);
}
```

## 🔔 Notification Categories

Your app supports these notification channels:

| Channel ID | Name | Purpose |
|------------|------|---------|
| `fcm_default_channel` | Push Notifications | Firebase Cloud Messaging |
| `moisture_alerts` | Moisture Alerts | Low soil moisture warnings |
| `weather_alerts` | Weather Alerts | Rain predictions |
| `system_alerts` | System Alerts | Errors and critical issues |
| `pump_alerts` | Pump Alerts | Pump on/off notifications |

## 🔒 Permissions

### Android
- `POST_NOTIFICATIONS` - Required for Android 13+ (automatically requested)
- `INTERNET` - Required for FCM
- `VIBRATE` - Notification vibration
- `RECEIVE_BOOT_COMPLETED` - Scheduled notifications

### iOS
- Alert permission (requested on app start)
- Badge permission
- Sound permission

## 🧪 Testing Checklist

- [ ] App requests notification permission on first launch
- [ ] FCM token is printed in console
- [ ] Local notifications work (call `showLowMoistureAlert()`)
- [ ] Push notification received when app is in **foreground**
- [ ] Push notification received when app is in **background**
- [ ] Push notification received when app is **terminated**
- [ ] Tapping notification opens the app
- [ ] Token refreshes after reinstall

## 🐛 Troubleshooting

### No FCM Token Generated
- ✅ Check Firebase is initialized in `main.dart`
- ✅ Verify `google-services.json` is in `android/app/`
- ✅ Check internet connection

### Notifications Not Appearing
- ✅ Verify notification permissions are granted
- ✅ Check device notification settings
- ✅ Ensure FCM token is valid (not expired)
- ✅ Test with Firebase Console test message

### Background Notifications Not Working
- ✅ Add `@pragma('vm:entry-point')` to background handler
- ✅ Verify Android manifest permissions
- ✅ Check notification channel settings

### iOS Notifications Not Working
- ✅ Enable Push Notifications in Xcode capabilities
- ✅ Add APNs key in Firebase Console
- ✅ Test on physical device (simulator may not work)

## 📚 Next Steps

1. **Store FCM Tokens in Database**
   - Save user's FCM token when they login
   - Update token when it refreshes

2. **Topic Subscriptions**
   ```dart
   FirebaseMessaging.instance.subscribeToTopic('all_users');
   FirebaseMessaging.instance.subscribeToTopic('moisture_alerts');
   ```

3. **Custom Navigation**
   Update `_handleNotificationTap()` in notification_service.dart:
   ```dart
   void _handleNotificationTap(RemoteMessage message) {
     if (message.data['type'] == 'moisture') {
       // Navigate to dashboard
     }
   }
   ```

4. **Notification Analytics**
   - Track notification open rates
   - Monitor user engagement
   - A/B test notification content

## 📖 API Documentation

### Get FCM Token
```dart
String? token = NotificationService().fcmToken;
print('Token: $token');
```

### Send Local Notification
```dart
await NotificationService().showLowMoistureAlert(25.0);
```

### Cancel Notifications
```dart
// Cancel all
await NotificationService().cancelAll();

// Cancel specific
await NotificationService().cancelNotification(1);
```

## 🎉 You're All Set!

Your Smart Irrigation System now has **full push notification support**! 

- Users receive alerts for low moisture, rain, pump status, and errors
- Backend can send targeted notifications to specific users or groups
- Notifications work in all app states (foreground, background, terminated)

**Need help?** Check the example files:
- `backend_notification_example.js` (Node.js)
- `backend_notification_example.py` (Python)
