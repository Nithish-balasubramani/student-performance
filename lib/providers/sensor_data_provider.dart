import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

/// Provider for managing sensor data and pump control
/// Handles real-time updates from Firebase and pump operations
class SensorDataProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final NotificationService _notificationService = NotificationService();

  SensorData? _sensorData;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _sensorDataSubscription;
  double _moistureThreshold = 30.0;

  // Getters
  SensorData? get sensorData => _sensorData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPumpOn => _sensorData?.pumpStatus ?? false;

  /// Start listening to sensor data stream
  void startListening(String userId, double moistureThreshold) {
    _moistureThreshold = moistureThreshold;
    _sensorDataSubscription?.cancel();

    _sensorDataSubscription = _firebaseService
        .getSensorDataStream(userId)
        .listen(
      (data) {
        _sensorData = data;
        _checkAlerts(data);
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error fetching sensor data: $error';
        notifyListeners();
      },
    );
  }

  /// Stop listening to sensor data
  void stopListening() {
    _sensorDataSubscription?.cancel();
  }

  /// Fetch sensor data once
  Future<void> fetchSensorData(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _sensorData = await _firebaseService.getSensorData(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching sensor data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle pump status
  Future<bool> togglePump(String userId) async {
    try {
      final newStatus = !isPumpOn;
      final success = await _firebaseService.updatePumpStatus(userId, newStatus);
      
      if (success) {
        // Show notification
        await _notificationService.showPumpStatusNotification(newStatus);
        
        // Update local state immediately for better UX
        if (_sensorData != null) {
          _sensorData = _sensorData!.copyWith(pumpStatus: newStatus);
          notifyListeners();
        }
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling pump: $e';
      notifyListeners();
      return false;
    }
  }

  /// Turn pump ON
  Future<bool> turnPumpOn(String userId) async {
    if (isPumpOn) return true;
    return await togglePump(userId);
  }

  /// Turn pump OFF
  Future<bool> turnPumpOff(String userId) async {
    if (!isPumpOn) return true;
    return await togglePump(userId);
  }

  /// Check for alerts based on sensor data
  void _checkAlerts(SensorData data) {
    // Low moisture alert
    if (data.moistureLevel < _moistureThreshold) {
      _notificationService.showLowMoistureAlert(data.moistureLevel);
    }

    // System error alert (example: sensor not responding)
    if (data.status == 'error') {
      _notificationService.showSystemError(
        'Sensor communication error detected',
      );
    }
  }

  /// Simulate sensor data update (for testing without Firebase)
  void updateSimulatedData(SensorData data) {
    _sensorData = data;
    notifyListeners();
  }

  @override
  void dispose() {
    _sensorDataSubscription?.cancel();
    _firebaseService.dispose();
    super.dispose();
  }
}
