# Quick Start Guide - Smart Irrigation System

## 🚀 Fast Setup (5 minutes)

### Step 1: Create Flutter Project
```bash
flutter create smart_irrigation_system
cd smart_irrigation_system
```

### Step 2: Replace pubspec.yaml
Copy the provided `pubspec.yaml` and run:
```bash
flutter pub get
```

### Step 3: Copy All Source Files
Copy the entire `lib/` folder structure with all Dart files.

### Step 4: Firebase Setup

#### Option A: Quick Test (No Firebase)
The app has default test data built-in. Just run:
```bash
flutter run
```

#### Option B: Full Firebase Setup
1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Configure Firebase:
   ```bash
   flutterfire configure
   ```

4. Enable services in Firebase Console:
   - Authentication (Email/Password)
   - Realtime Database

5. Copy security rules from `firebase_rules.json` to Firebase Console

### Step 5: Run the App
```bash
flutter run
```

## 📱 Test Accounts

For testing, create an account in the app:
- Email: test@example.com
- Password: test123456

## 🔧 Manual Testing Without IoT Hardware

### Method 1: Firebase Console
1. Open Firebase Console → Realtime Database
2. Navigate to: `users/{userId}/sensorData`
3. Manually edit values:
   ```json
   {
     "moistureLevel": 25.5,
     "temperature": 30.2,
     "humidity": 65.8,
     "pumpStatus": false,
     "waterUsage": 150.0,
     "timestamp": "2026-02-23T12:00:00Z",
     "status": "normal"
   }
   ```
4. Watch the app update in real-time!

### Method 2: REST API
Use Postman or curl to update Firebase:
```bash
curl -X PUT \
  https://your-project.firebaseio.com/users/userId/sensorData.json?auth=YOUR_TOKEN \
  -d '{
    "moistureLevel": 45.0,
    "temperature": 28.5,
    "humidity": 65.0,
    "pumpStatus": false,
    "waterUsage": 0.0,
    "timestamp": "2026-02-23T10:30:00Z",
    "status": "normal"
  }'
```

## 🎯 Quick Feature Tests

### Test Authentication
1. Open app → Sign Up
2. Create account
3. Login
4. See Dashboard

### Test Dashboard
1. View sensor cards
2. Check moisture level color coding:
   - Red: < 20% (Critical)
   - Orange: 20-30% (Low)
   - Blue: 30-50% (Normal)
   - Green: > 50% (Optimal)

### Test Pump Control
1. Go to Control tab
2. Toggle pump ON/OFF
3. Check Firebase updates
4. Verify notification appears

### Test Settings
1. Go to Settings tab
2. Adjust moisture threshold slider
3. Change crop type
4. Toggle auto mode
5. Configure alerts

## 🐛 Common Issues & Fixes

### Firebase Not Connecting
```bash
# Reconfigure Firebase
flutterfire configure --force
```

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

### iOS Notification Issues
Add to `ios/Runner/Info.plist`:
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

### Android Build Issues
Ensure `android/app/build.gradle` has:
```gradle
minSdkVersion 21
compileSdkVersion 34
```

## 📊 Testing Scenarios

### Scenario 1: Low Moisture Alert
1. Set threshold to 40% in Settings
2. Update Firebase moisture to 35%
3. Expect: Alert notification

### Scenario 2: Auto Irrigation
1. Enable Auto Mode in Control
2. Set threshold to 30%
3. Update Firebase moisture to 25%
4. Expect: Pump automatically turns ON

### Scenario 3: Manual Override
1. Turn pump ON manually
2. Check Firebase updates
3. Turn OFF
4. Verify status changes

## 🔌 Connect IoT Hardware

### Quick IoT Setup
1. Flash provided Arduino code to ESP32
2. Update WiFi credentials
3. Update Firebase credentials
4. Update User ID
5. Connect sensors (see wiring guide in arduino_example.cpp)
6. Power on and monitor Serial output

### Sensor Calibration
Adjust moisture sensor mapping in Arduino code:
```cpp
float moisture = map(sensorValue, DRY_VALUE, WET_VALUE, 0, 100);
```

Test in dry soil and water to get values.

## 📈 Next Steps

### Enhance the App
1. Add charts for historical data
2. Integrate weather API for rain prediction
3. Add schedule-based irrigation
4. Support multiple zones
5. Add weather widgets

### Hardware Improvements
1. Add flow sensor for usage tracking
2. Add water level sensor
3. Add rain sensor
4. Solar power integration
5. Multi-zone control

## 💡 Tips

- Use Firebase Emulator for local testing
- Enable Firebase debug logging
- Check Flutter doctor regularly
- Test on physical devices for notifications
- Monitor Firebase usage quotas

## 🆘 Get Help

### Check Logs
```bash
flutter logs
```

### Debug Mode
```bash
flutter run --verbose
```

### Firebase Debug
Enable in `main.dart`:
```dart
FirebaseDatabase.instance.setLoggingEnabled(true);
```

---

**Ready to grow smart! 🌱💧**
