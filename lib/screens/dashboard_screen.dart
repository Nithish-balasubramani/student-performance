import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_data_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/pump_control_widget.dart';

/// Dashboard screen showing real-time sensor data and system status
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  /// Initialize dashboard data
  void _initializeDashboard() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sensorProvider = Provider.of<SensorDataProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if (authProvider.user != null) {
      // Load settings first
      settingsProvider.loadSettings(authProvider.user!.id).then((_) {
        // Then start listening to sensor data with the correct threshold
        sensorProvider.startListening(
          authProvider.user!.id,
          settingsProvider.moistureThreshold,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Hi, ${authProvider.user?.name ?? "User"}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final sensorProvider = Provider.of<SensorDataProvider>(context, listen: false);
          if (authProvider.user != null) {
            await sensorProvider.fetchSensorData(authProvider.user!.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Consumer<SensorDataProvider>(
            builder: (context, sensorProvider, child) {
              final sensorData = sensorProvider.sensorData;

              if (sensorProvider.isLoading && sensorData == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (sensorData == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No sensor data available'),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner
                  _buildStatusBanner(sensorData.moistureLevel, sensorData.status),
                  const SizedBox(height: 24),

                  // Moisture Level Card (Primary)
                  SensorCard(
                    title: 'Soil Moisture',
                    value: sensorData.moistureLevel.toStringAsFixed(1),
                    unit: '%',
                    icon: Icons.water_drop,
                    color: _getMoistureColor(sensorData.moistureLevel),
                  ),
                  const SizedBox(height: 16),

                  // Temperature and Humidity Row
                  Row(
                    children: [
                      Expanded(
                        child: CompactSensorCard(
                          title: 'Temperature',
                          value: '${sensorData.temperature.toStringAsFixed(1)}°C',
                          icon: Icons.thermostat,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CompactSensorCard(
                          title: 'Humidity',
                          value: '${sensorData.humidity.toStringAsFixed(1)}%',
                          icon: Icons.cloud,
                          color: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Pump Status Section
                  const Text(
                    'Pump Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      PumpStatusIndicator(isPumpOn: sensorData.pumpStatus),
                      const SizedBox(width: 12),
                      Text(
                        sensorData.pumpStatus ? 'Currently running' : 'Currently stopped',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Water Usage Statistics
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.purple.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Water Usage Today',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${sensorData.waterUsage.toStringAsFixed(1)} L',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.bar_chart,
                          size: 48,
                          color: Colors.purple.shade300,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last Update Time
                  Center(
                    child: Text(
                      'Last updated: ${_formatTime(sensorData.timestamp)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build status banner
  Widget _buildStatusBanner(double moistureLevel, String status) {
    Color bannerColor;
    String message;
    IconData icon;

    if (moistureLevel < 20) {
      bannerColor = Colors.red;
      message = 'Critical: Soil moisture is very low!';
      icon = Icons.warning;
    } else if (moistureLevel < 30) {
      bannerColor = Colors.orange;
      message = 'Warning: Soil moisture is low';
      icon = Icons.warning_amber;
    } else {
      bannerColor = Colors.green;
      message = 'Soil moisture is optimal';
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: bannerColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: bannerColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get color based on moisture level
  Color _getMoistureColor(double moisture) {
    if (moisture < 20) return Colors.red;
    if (moisture < 30) return Colors.orange;
    if (moisture < 50) return Colors.blue;
    return Colors.green;
  }

  /// Format timestamp
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}';
    }
  }
}
