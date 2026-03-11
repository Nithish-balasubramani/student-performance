/// Model for Irrigation System Settings
class IrrigationSettings {
  final double moistureThreshold; // Percentage - trigger irrigation below this
  final String cropType; // Type of crop being grown
  final bool autoMode; // Auto irrigation enabled/disabled
  final int irrigationDuration; // Minutes
  final bool rainPredictionAlert; // Enable rain alerts
  final bool lowMoistureAlert; // Enable low moisture alerts

  IrrigationSettings({
    this.moistureThreshold = 30.0,
    this.cropType = 'General',
    this.autoMode = false,
    this.irrigationDuration = 15,
    this.rainPredictionAlert = true,
    this.lowMoistureAlert = true,
  });

  /// Create from JSON
  factory IrrigationSettings.fromJson(Map<String, dynamic> json) {
    return IrrigationSettings(
      moistureThreshold: (json['moistureThreshold'] ?? 30.0).toDouble(),
      cropType: json['cropType'] ?? 'General',
      autoMode: json['autoMode'] ?? false,
      irrigationDuration: json['irrigationDuration'] ?? 15,
      rainPredictionAlert: json['rainPredictionAlert'] ?? true,
      lowMoistureAlert: json['lowMoistureAlert'] ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'moistureThreshold': moistureThreshold,
      'cropType': cropType,
      'autoMode': autoMode,
      'irrigationDuration': irrigationDuration,
      'rainPredictionAlert': rainPredictionAlert,
      'lowMoistureAlert': lowMoistureAlert,
    };
  }

  /// Copy with updated fields
  IrrigationSettings copyWith({
    double? moistureThreshold,
    String? cropType,
    bool? autoMode,
    int? irrigationDuration,
    bool? rainPredictionAlert,
    bool? lowMoistureAlert,
  }) {
    return IrrigationSettings(
      moistureThreshold: moistureThreshold ?? this.moistureThreshold,
      cropType: cropType ?? this.cropType,
      autoMode: autoMode ?? this.autoMode,
      irrigationDuration: irrigationDuration ?? this.irrigationDuration,
      rainPredictionAlert: rainPredictionAlert ?? this.rainPredictionAlert,
      lowMoistureAlert: lowMoistureAlert ?? this.lowMoistureAlert,
    );
  }

  /// Get list of available crops
  static List<String> get availableCrops => [
        'General',
        'Rice',
        'Wheat',
        'Corn',
        'Cotton',
        'Sugarcane',
        'Vegetables',
        'Fruits',
      ];
}
