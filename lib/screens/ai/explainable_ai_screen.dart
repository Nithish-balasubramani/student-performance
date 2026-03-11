import 'package:flutter/material.dart';

class ExplainableAIScreen extends StatelessWidget {
  const ExplainableAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Decision Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Decision Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Current Decision',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Motor Status',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'OFF',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Decision made 2 minutes ago',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Decision Reasoning
            Text(
              'Why Motor is OFF',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 12),
            _buildReasonCard(
              icon: Icons.water_drop,
              title: 'Soil Moisture Sufficient',
              description:
                  'Current moisture is 45%, above the threshold of 30%',
              confidence: 95,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            _buildReasonCard(
              icon: Icons.cloud,
              title: 'Recent Rainfall Detected',
              description: 'Rain sensor detected 15mm of rainfall 3 hours ago',
              confidence: 88,
              color: const Color(0xFF2196F3),
            ),
            const SizedBox(height: 12),
            _buildReasonCard(
              icon: Icons.schedule,
              title: 'Outside Scheduled Window',
              description:
                  'Current time (14:30) is outside irrigation schedule (06:00-08:00)',
              confidence: 92,
              color: const Color(0xFFFF9800),
            ),
            const SizedBox(height: 12),
            _buildReasonCard(
              icon: Icons.energy_savings_leaf,
              title: 'Water Budget Conserved',
              description:
                  'Daily usage at 49% (245L of 500L). Conserving remaining budget.',
              confidence: 75,
              color: const Color(0xFF4CAF50),
            ),

            const SizedBox(height: 24),

            // Sensor Data Snapshot
            Text(
              'Sensor Data Snapshot',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  _buildSensorRow('Soil Moisture', '45%', Icons.water_drop,
                      const Color(0xFF2196F3)),
                  const Divider(height: 24),
                  _buildSensorRow('Temperature', '28°C', Icons.thermostat,
                      const Color(0xFFFF9800)),
                  const Divider(height: 24),
                  _buildSensorRow('Humidity', '65%', Icons.opacity,
                      const Color(0xFF4CAF50)),
                  const Divider(height: 24),
                  _buildSensorRow('Water Level', 'Normal', Icons.waves,
                      const Color(0xFF2196F3)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Prediction
            Text(
              'Next Action Prediction',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology,
                          color: Color(0xFF9C27B0), size: 24),
                      SizedBox(width: 12),
                      Text(
                        'AI Prediction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Motor will likely turn ON in approximately 18 hours (tomorrow at 06:00) when:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _buildPredictionPoint('Scheduled irrigation window begins'),
                  _buildPredictionPoint('Moisture expected to drop to 32%'),
                  _buildPredictionPoint('No rain forecast for next 24 hours'),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Confidence: 87%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonCard({
    required IconData icon,
    required String title,
    required String description,
    required int confidence,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$confidence%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
