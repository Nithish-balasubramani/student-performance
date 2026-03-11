import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/sensor_data_provider.dart';

class ManualControlScreen extends StatefulWidget {
  const ManualControlScreen({super.key});

  @override
  State<ManualControlScreen> createState() => _ManualControlScreenState();
}

class _ManualControlScreenState extends State<ManualControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Control'),
      ),
      body: Consumer<SensorDataProvider>(
        builder: (context, provider, child) {
          final pumpStatus = provider.sensorData?.pumpStatus ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Emergency Stop Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEF5350)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 48,
                        color: Color(0xFFD32F2F),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Emergency Stop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Immediately stops all motor operations',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF757575)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: pumpStatus
                              ? () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  if (authProvider.user != null) {
                                    provider.togglePump(authProvider.user!.id);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Emergency stop activated'),
                                      backgroundColor: Color(0xFFD32F2F),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.stop),
                          label: const Text('EMERGENCY STOP'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            disabledBackgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Motor Control Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Motor Control',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 18,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: pumpStatus
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: pumpStatus
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFF9E9E9E),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  pumpStatus ? 'ON' : 'OFF',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: pumpStatus
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: pumpStatus
                                    ? null
                                    : () {
                                        final authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);
                                        if (authProvider.user != null) {
                                          provider.togglePump(
                                              authProvider.user!.id);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Motor started'),
                                            backgroundColor: Color(0xFF4CAF50),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Start Motor'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  disabledBackgroundColor: Colors.grey[300],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: pumpStatus
                                    ? () {
                                        final authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);
                                        if (authProvider.user != null) {
                                          provider.togglePump(
                                              authProvider.user!.id);
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Motor stopped'),
                                          ),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.stop),
                                label: const Text('Stop Motor'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: pumpStatus
                                        ? const Color(0xFFD32F2F)
                                        : Colors.grey[300]!,
                                  ),
                                  foregroundColor: const Color(0xFFD32F2F),
                                  disabledForegroundColor: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Valve Control Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valve Control',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildValveControl('Main Valve', true),
                      const SizedBox(height: 12),
                      _buildValveControl('Section A', false),
                      const SizedBox(height: 12),
                      _buildValveControl('Section B', false),
                      const SizedBox(height: 12),
                      _buildValveControl('Section C', false),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Manual Duration Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Duration',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration (minutes)',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  initialValue: '15',
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    suffixText: 'min',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Duration set successfully'),
                                  ),
                                );
                              },
                              child: const Text('Set'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildValveControl(String name, bool isOpen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isOpen ? Icons.check_circle : Icons.cancel,
              color: isOpen ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Switch(
          value: isOpen,
          onChanged: (value) {
            // Handle valve control
          },
          activeThumbColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }
}
