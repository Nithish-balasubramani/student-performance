import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_data_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/pump_control_widget.dart';

/// Control screen for managing irrigation manually or automatically
class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool _isTogglingPump = false;

  /// Handle pump toggle
  Future<void> _handlePumpToggle(bool newStatus) async {
    if (_isTogglingPump) return;

    setState(() {
      _isTogglingPump = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sensorProvider = Provider.of<SensorDataProvider>(context, listen: false);

    if (authProvider.user != null) {
      final success = await sensorProvider.togglePump(authProvider.user!.id);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus ? 'Pump turned ON' : 'Pump turned OFF',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update pump status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isTogglingPump = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Control'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manual Control Section
            const Text(
              'Manual Control',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Directly control the water pump',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Pump Control Widget
            Consumer<SensorDataProvider>(
              builder: (context, sensorProvider, child) {
                return PumpControlWidget(
                  isPumpOn: sensorProvider.isPumpOn,
                  onToggle: _handlePumpToggle,
                  isLoading: _isTogglingPump,
                );
              },
            ),
            const SizedBox(height: 32),

            // Auto Mode Section
            const Text(
              'Automatic Irrigation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Let the system automatically water based on moisture threshold',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Auto Mode Card
            Consumer2<SettingsProvider, AuthProvider>(
              builder: (context, settingsProvider, authProvider, child) {
                final isAutoMode = settingsProvider.autoMode;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAutoMode
                          ? [Colors.green.shade300, Colors.green.shade600]
                          : [Colors.grey.shade300, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isAutoMode
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Auto Mode',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isAutoMode ? 'Enabled' : 'Disabled',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isAutoMode,
                            onChanged: (value) async {
                              if (authProvider.user != null) {
                                await settingsProvider.toggleAutoMode(
                                  authProvider.user!.id,
                                );
                              }
                            },
                            activeThumbColor: Colors.white,
                            activeTrackColor: Colors.green.shade800,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Threshold: ${settingsProvider.moistureThreshold}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Current Status Card
            const Text(
              'System Status',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Consumer<SensorDataProvider>(
              builder: (context, sensorProvider, child) {
                final sensorData = sensorProvider.sensorData;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        'Moisture Level',
                        sensorData != null
                            ? '${sensorData.moistureLevel.toStringAsFixed(1)}%'
                            : 'N/A',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Pump Status',
                        sensorData != null
                            ? (sensorData.pumpStatus ? 'ON' : 'OFF')
                            : 'N/A',
                        Icons.power,
                        sensorData?.pumpStatus ?? false
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Temperature',
                        sensorData != null
                            ? '${sensorData.temperature.toStringAsFixed(1)}°C'
                            : 'N/A',
                        Icons.thermostat,
                        Colors.orange,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build status row widget
  Widget _buildStatusRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
