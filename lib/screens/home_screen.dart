import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_data_provider.dart';
import '../providers/auth_provider.dart';
import 'control_screen.dart';
import 'settings/automation_settings_screen.dart';
import 'water_budget/water_budget_screen.dart';
import 'analytics/analytics_screen.dart';
import 'history/history_logs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sensorProvider =
        Provider.of<SensorDataProvider>(context, listen: false);

    if (authProvider.user != null) {
      sensorProvider.startListening(authProvider.user!.id, 30.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _selectedIndex == 0
          ? _buildDashboard()
          : _getSelectedScreen(_selectedIndex),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 1:
        return const ControlScreen();
      case 2:
        return const AutomationSettingsScreen();
      case 3:
        return const WaterBudgetScreen();
      case 4:
        return const Center(child: Text('Alerts'));
      case 5:
        return const AnalyticsScreen();
      case 6:
        return const HistoryLogsScreen();
      case 7:
        return const Center(child: Text('Profile'));
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildWelcomeSection(),
                const SizedBox(height: 16),
                _buildQuickStatusCards(),
                const SizedBox(height: 16),
                _buildSoilMoistureCard(),
                const SizedBox(height: 16),
                _buildTempHumidityRow(),
                const SizedBox(height: 16),
                _buildSystemStatusCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Icon(Icons.water_drop, color: Colors.blue[700], size: 24),
          const SizedBox(width: 8),
          const Text(
            'Smart Irrigation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Last updated: ${_getFormattedTime()}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStatusCards() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final data = provider.sensorData;
        return Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                icon: Icons.power_settings_new,
                label: 'Motor',
                value: data?.pumpStatus == true ? 'ON' : 'OFF',
                color: data?.pumpStatus == true
                    ? Colors.green[700]!
                    : Colors.grey[600]!,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                icon: Icons.cloud,
                label: 'Rain',
                value: 'No Rain',
                color: Colors.blue[700]!,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilMoistureCard() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final moisture = provider.sensorData?.moistureLevel ?? 0.0;
        final isLow = moisture < 30;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isLow ? Colors.orange[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLow ? Colors.orange[300]! : Colors.blue[300]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: isLow ? Colors.orange[700] : Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Soil Moisture',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isLow ? Colors.orange[700] : Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.trending_down,
                    color: isLow ? Colors.orange[700] : Colors.blue[700],
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isLow ? 'Low' : 'Normal',
                style: TextStyle(
                  fontSize: 12,
                  color: isLow ? Colors.orange[600] : Colors.blue[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    moisture.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isLow ? Colors.orange[700] : Colors.blue[700],
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isLow ? Colors.orange[700] : Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: moisture / 100,
                  backgroundColor:
                      isLow ? Colors.orange[200] : Colors.blue[200],
                  valueColor: AlwaysStoppedAnimation(
                    isLow ? Colors.orange[700]! : Colors.blue[700]!,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTempHumidityRow() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final data = provider.sensorData;
        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: data?.temperature.toStringAsFixed(1) ?? '--',
                unit: '°C',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: data?.humidity.toStringAsFixed(1) ?? '--',
                unit: '%',
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final pumpStatus = provider.sensorData?.pumpStatus ?? false;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assessment, size: 18, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  const Text(
                    'System Status',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatusRow(
                'Valve Status',
                pumpStatus ? 'OPEN' : 'CLOSED',
                pumpStatus ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 12),
              _buildStatusRow('Auto Mode', 'ENABLED', Colors.green),
              const SizedBox(height: 12),
              _buildStatusRow('Connection', 'Online', Colors.green,
                  showDot: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(String label, String value, Color color,
      {bool showDot = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Row(
          children: [
            if (showDot) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 24),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote, size: 24),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 24),
            label: 'Automation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop, size: 24),
            label: 'Water',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 24),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 24),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 24),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}';
  }
}
