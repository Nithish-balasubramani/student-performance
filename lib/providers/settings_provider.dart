import 'package:flutter/material.dart';
import '../models/irrigation_settings.dart';
import '../services/firebase_service.dart';

/// Provider for managing irrigation settings
/// Handles moisture threshold, crop type, and auto mode
class SettingsProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  IrrigationSettings _settings = IrrigationSettings();
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  IrrigationSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get moistureThreshold => _settings.moistureThreshold;
  String get cropType => _settings.cropType;
  bool get autoMode => _settings.autoMode;

  /// Load settings from Firebase
  Future<void> loadSettings(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _settings = await _firebaseService.getSettings(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading settings: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update moisture threshold
  Future<bool> updateMoistureThreshold(String userId, double threshold) async {
    try {
      _settings = _settings.copyWith(moistureThreshold: threshold);
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error updating threshold: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update crop type
  Future<bool> updateCropType(String userId, String cropType) async {
    try {
      _settings = _settings.copyWith(cropType: cropType);
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error updating crop type: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle auto mode
  Future<bool> toggleAutoMode(String userId) async {
    try {
      _settings = _settings.copyWith(autoMode: !_settings.autoMode);
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling auto mode: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update irrigation duration
  Future<bool> updateIrrigationDuration(String userId, int duration) async {
    try {
      _settings = _settings.copyWith(irrigationDuration: duration);
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error updating duration: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle rain prediction alert
  Future<bool> toggleRainAlert(String userId) async {
    try {
      _settings = _settings.copyWith(
        rainPredictionAlert: !_settings.rainPredictionAlert,
      );
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling rain alert: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggle low moisture alert
  Future<bool> toggleLowMoistureAlert(String userId) async {
    try {
      _settings = _settings.copyWith(
        lowMoistureAlert: !_settings.lowMoistureAlert,
      );
      final success = await _firebaseService.saveSettings(userId, _settings);
      
      if (success) {
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _errorMessage = 'Error toggling moisture alert: $e';
      notifyListeners();
      return false;
    }
  }

  /// Save all settings
  Future<bool> saveSettings(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _firebaseService.saveSettings(userId, _settings);
      
      _isLoading = false;
      notifyListeners();
      
      return success;
    } catch (e) {
      _errorMessage = 'Error saving settings: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
