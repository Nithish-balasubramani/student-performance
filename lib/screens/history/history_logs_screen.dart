import 'package:flutter/material.dart';

class HistoryLogsScreen extends StatelessWidget {
  const HistoryLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                const SizedBox(width: 8),
                _buildFilterChip('Auto', false),
                const SizedBox(width: 8),
                _buildFilterChip('Manual', false),
                const SizedBox(width: 8),
                _buildFilterChip('Alerts', false),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Today
          Text(
            'Today',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.power_settings_new,
            title: 'Irrigation Stopped',
            subtitle: 'Auto mode - Moisture level reached 50%',
            time: '14:30',
            type: LogType.auto,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.warning_amber,
            title: 'Low Moisture Alert',
            subtitle: 'Soil moisture dropped to 28%',
            time: '12:45',
            type: LogType.alert,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.power_settings_new,
            title: 'Irrigation Started',
            subtitle: 'Auto mode - Moisture threshold reached',
            time: '12:00',
            type: LogType.auto,
          ),

          const SizedBox(height: 24),

          // Yesterday
          Text(
            'Yesterday',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.touch_app,
            title: 'Manual Control',
            subtitle: 'User manually stopped Section A valve',
            time: '18:15',
            type: LogType.manual,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.power_settings_new,
            title: 'Irrigation Stopped',
            subtitle: 'Auto mode - Duration limit reached (45 min)',
            time: '17:30',
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.cloud,
            title: 'Rain Detected',
            subtitle: 'Scheduled irrigation cancelled',
            time: '14:00',
            type: LogType.alert,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.power_settings_new,
            title: 'Irrigation Started',
            subtitle: 'Scheduled start time: 14:00',
            time: '14:00',
            type: LogType.auto,
          ),

          const SizedBox(height: 24),

          // This Week
          Text(
            'This Week',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.settings,
            title: 'Settings Changed',
            subtitle: 'Moisture threshold updated to 30%',
            time: 'Mar 15, 16:20',
            type: LogType.settings,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.error_outline,
            title: 'Sensor Anomaly',
            subtitle: 'Temperature sensor reading out of range',
            time: 'Mar 14, 11:30',
            type: LogType.alert,
          ),
          const SizedBox(height: 12),
          _buildLogCard(
            icon: Icons.touch_app,
            title: 'Emergency Stop',
            subtitle: 'User activated emergency stop',
            time: 'Mar 13, 09:45',
            type: LogType.manual,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (value) {},
      selectedColor: const Color(0xFF1976D2).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFF1976D2),
    );
  }

  Widget _buildLogCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    LogType type = LogType.auto,
  }) {
    Color iconColor;
    Color bgColor;

    switch (type) {
      case LogType.auto:
        iconColor = const Color(0xFF4CAF50);
        bgColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
        break;
      case LogType.manual:
        iconColor = const Color(0xFF2196F3);
        bgColor = const Color(0xFF2196F3).withValues(alpha: 0.1);
        break;
      case LogType.alert:
        iconColor = const Color(0xFFFF9800);
        bgColor = const Color(0xFFFF9800).withValues(alpha: 0.1);
        break;
      case LogType.settings:
        iconColor = const Color(0xFF9C27B0);
        bgColor = const Color(0xFF9C27B0).withValues(alpha: 0.1);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

enum LogType {
  auto,
  manual,
  alert,
  settings,
}
