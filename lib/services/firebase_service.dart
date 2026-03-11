import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_data.dart';
import '../models/irrigation_settings.dart';

/// Service to handle Firebase Realtime Database operations
/// Manages sensor data fetching and pump control
class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sensorDataSubscription;

  /// Stream for real-time sensor data updates
  Stream<SensorData> getSensorDataStream(String userId) {
    return _database.child('users/$userId/sensorData').onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return SensorData.fromJson(data);
      } else {
        // Return default data if no data exists
        return _getDefaultSensorData();
      }
    });
  }

  /// Get sensor data once (not a stream)
  Future<SensorData> getSensorData(String userId) async {
    try {
      final snapshot = await _database.child('users/$userId/sensorData').get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return SensorData.fromJson(data);
      } else {
        return _getDefaultSensorData();
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      return _getDefaultSensorData();
    }
  }

  /// Update pump status in Firebase
  Future<bool> updatePumpStatus(String userId, bool status) async {
    try {
      await _database.child('users/$userId/sensorData/pumpStatus').set(status);

      // Also update timestamp
      await _database
          .child('users/$userId/sensorData/timestamp')
          .set(DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      print('Error updating pump status: $e');
      return false;
    }
  }

  /// Save irrigation settings to Firebase
  Future<bool> saveSettings(String userId, IrrigationSettings settings) async {
    try {
      await _database.child('users/$userId/settings').set(settings.toJson());
      return true;
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  /// Get irrigation settings from Firebase
  Future<IrrigationSettings> getSettings(String userId) async {
    try {
      final snapshot = await _database.child('users/$userId/settings').get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return IrrigationSettings.fromJson(data);
      } else {
        return IrrigationSettings();
      }
    } catch (e) {
      print('Error fetching settings: $e');
      return IrrigationSettings();
    }
  }

  /// Get water usage statistics for a date range
  Future<List<Map<String, dynamic>>> getWaterUsageStats(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _database
          .child('users/$userId/waterUsageHistory')
          .orderByChild('timestamp')
          .startAt(startDate.toIso8601String())
          .endAt(endDate.toIso8601String())
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        return data.entries.map((entry) {
          return Map<String, dynamic>.from(entry.value as Map);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching water usage stats: $e');
      return [];
    }
  }

  /// Log water usage to history
  Future<void> logWaterUsage(String userId, double amount) async {
    try {
      await _database.child('users/$userId/waterUsageHistory').push().set({
        'amount': amount,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error logging water usage: $e');
    }
  }

  /// Default sensor data for testing or when no data exists
  SensorData _getDefaultSensorData() {
    return SensorData(
      moistureLevel: 45.0,
      temperature: 28.5,
      humidity: 65.0,
      pumpStatus: false,
      waterUsage: 0.0,
      timestamp: DateTime.now(),
      status: 'normal',
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FIRESTORE METHODS - Weather API Configuration
  // ═══════════════════════════════════════════════════════════

  /// Store weather API key in Firestore
  Future<bool> storeWeatherApiKey(String apiKey) async {
    try {
      await _firestore.collection('config').doc('weatherApi').set({
        'apiKey': apiKey,
        'provider': 'OpenWeatherMap',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Weather API key stored successfully');
      return true;
    } catch (e) {
      print('Error storing weather API key: $e');
      return false;
    }
  }

  /// Get weather API key from Firestore
  Future<String?> getWeatherApiKey() async {
    try {
      final doc = await _firestore.collection('config').doc('weatherApi').get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['apiKey'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching weather API key: $e');
      return null;
    }
  }

  /// Get complete weather API configuration from Firestore
  Future<Map<String, dynamic>?> getWeatherApiConfig() async {
    try {
      final doc = await _firestore.collection('config').doc('weatherApi').get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error fetching weather API config: $e');
      return null;
    }
  }

  /// Update weather API key in Firestore
  Future<bool> updateWeatherApiKey(String apiKey) async {
    try {
      await _firestore.collection('config').doc('weatherApi').update({
        'apiKey': apiKey,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Weather API key updated successfully');
      return true;
    } catch (e) {
      print('Error updating weather API key: $e');
      return false;
    }
  }

  /// Clean up subscriptions
  void dispose() {
    _sensorDataSubscription?.cancel();
  }
}
