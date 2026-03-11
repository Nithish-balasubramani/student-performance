/// Model class for Sensor Data
/// Represents real-time data from IoT sensors
class SensorData {
  final double moistureLevel; // Percentage (0-100)
  final double temperature; // Celsius
  final double humidity; // Percentage
  final bool pumpStatus; // ON = true, OFF = false
  final double waterUsage; // Liters
  final DateTime timestamp;
  final String status; // 'normal', 'low', 'critical'

  SensorData({
    required this.moistureLevel,
    required this.temperature,
    required this.humidity,
    required this.pumpStatus,
    required this.waterUsage,
    required this.timestamp,
    required this.status,
  });

  /// Create SensorData from JSON (Firebase/API response)
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      moistureLevel: (json['moistureLevel'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      pumpStatus: json['pumpStatus'] ?? false,
      waterUsage: (json['waterUsage'] ?? 0).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: json['status'] ?? 'normal',
    );
  }

  /// Convert SensorData to JSON
  Map<String, dynamic> toJson() {
    return {
      'moistureLevel': moistureLevel,
      'temperature': temperature,
      'humidity': humidity,
      'pumpStatus': pumpStatus,
      'waterUsage': waterUsage,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  /// Create a copy with some fields updated
  SensorData copyWith({
    double? moistureLevel,
    double? temperature,
    double? humidity,
    bool? pumpStatus,
    double? waterUsage,
    DateTime? timestamp,
    String? status,
  }) {
    return SensorData(
      moistureLevel: moistureLevel ?? this.moistureLevel,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pumpStatus: pumpStatus ?? this.pumpStatus,
      waterUsage: waterUsage ?? this.waterUsage,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
