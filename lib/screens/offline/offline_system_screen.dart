import 'package:flutter/material.dart';
import 'dart:async';

/// Offline System Screen - Complete fallback protection status
/// Shows multi-layer offline protection, EEPROM data, pending queue, and active rules
class OfflineSystemScreen extends StatefulWidget {
  const OfflineSystemScreen({super.key});

  @override
  State<OfflineSystemScreen> createState() => _OfflineSystemScreenState();
}

class _OfflineSystemScreenState extends State<OfflineSystemScreen> {
  // System Mode: ONLINE, WIFI_OFFLINE, FB_OFFLINE, SENSOR_FAIL
  String _systemMode = 'ONLINE';
  int _offlineSeconds = 0;
  Timer? _offlineTimer;

  // Mock sensor data
  final double _moisture = 42.5;
  final double _temperature = 28.5;
  final double _rain = 35.0;

  // Thresholds stored in EEPROM
  final double _soilThreshold = 45.0;
  final double _rainThreshold = 60.0;
  final double _emergencyLevel = 30.0;

  // Pump timer (safety: max 60 minutes)
  final int _pumpRuntime = 34; // minutes

  // Pending queue for offline data
  final List<Map<String, dynamic>> _pendingQueue = [
    {'soil': 38.2, 'temp': 28.5, 'hum': 67, 'ts': '2m ago'},
    {'soil': 37.9, 'temp': 28.7, 'hum': 66, 'ts': '7m ago'},
    {'soil': 37.5, 'temp': 28.9, 'hum': 65, 'ts': '12m ago'},
  ];

  @override
  void initState() {
    super.initState();
    _startOfflineTimer();
  }

  @override
  void dispose() {
    _offlineTimer?.cancel();
    super.dispose();
  }

  void _startOfflineTimer() {
    _offlineTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_systemMode != 'ONLINE') {
        setState(() => _offlineSeconds++);
      }
    });
  }

  void _changeSystemMode(String mode) {
    setState(() {
      _systemMode = mode;
      if (mode == 'ONLINE') {
        _offlineSeconds = 0;
      }
    });
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m ${seconds % 60}s';
    return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
  }

  Color _getModeColor() {
    switch (_systemMode) {
      case 'WIFI_OFFLINE':
        return const Color(0xFFFF5252); // Red
      case 'FB_OFFLINE':
        return const Color(0xFFFFD54F); // Yellow
      case 'SENSOR_FAIL':
        return const Color(0xFFFFA040); // Orange
      default:
        return const Color(0xFF00FF7F); // Green
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModeSimulator(),
                    const SizedBox(height: 16),
                    _buildCurrentModeBanner(),
                    const SizedBox(height: 20),
                    _buildConnectivityStatus(),
                    const SizedBox(height: 20),
                    _buildFallbackLayers(),
                    const SizedBox(height: 20),
                    _buildActiveRules(),
                    const SizedBox(height: 20),
                    _buildSafetyTimer(),
                    const SizedBox(height: 20),
                    _buildEEPROMData(),
                    const SizedBox(height: 20),
                    _buildPendingQueue(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF071510), Color(0xFF050D07)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.offline_bolt,
                  color: Color(0xFF00FF7F), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔌 Offline System',
                      style: TextStyle(
                        color: Color(0xFFE8F5EC),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fallback protection status',
                      style: TextStyle(
                        color: const Color(0xFF90C4A0).withValues(alpha: 0.7),
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeSimulator() {
    final modes = [
      {'id': 'ONLINE', 'label': 'ONLINE', 'color': const Color(0xFF00FF7F)},
      {
        'id': 'WIFI_OFFLINE',
        'label': 'WIFI OFF',
        'color': const Color(0xFFFF5252)
      },
      {'id': 'FB_OFFLINE', 'label': 'FB OFF', 'color': const Color(0xFFFFD54F)},
      {
        'id': 'SENSOR_FAIL',
        'label': 'SENSOR FAIL',
        'color': const Color(0xFFFFA040)
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIMULATE MODE (FOR DEMO)',
          style: TextStyle(
            color: const Color(0xFF90C4A0).withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: modes.map((mode) {
            final isActive = _systemMode == mode['id'];
            final color = mode['color'] as Color;
            return InkWell(
              onTap: () => _changeSystemMode(mode['id'] as String),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withValues(alpha: 0.1)
                      : const Color(0xFF0C1E14),
                  border: Border.all(
                    color: isActive ? color : const Color(0xFF183522),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mode['label'] as String,
                  style: TextStyle(
                    color: isActive ? color : const Color(0xFF567060),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCurrentModeBanner() {
    final modeColor = _getModeColor();
    String modeIcon = '✅';
    String modeLabel = 'ONLINE MODE';
    String modeTitle = 'All Systems Operational';
    String modeDesc = 'WiFi ✅ · Firebase ✅ · Sensors ✅ · AI ✅';

    if (_systemMode == 'WIFI_OFFLINE') {
      modeIcon = '📵';
      modeLabel = 'WIFI OFFLINE';
      modeTitle = 'No WiFi — Local Mode Active';
      modeDesc =
          'Offline for ${_formatDuration(_offlineSeconds)}. EEPROM rules active.';
    } else if (_systemMode == 'FB_OFFLINE') {
      modeIcon = '☁️';
      modeLabel = 'FIREBASE OFFLINE';
      modeTitle = 'Firebase Down — Using Cache';
      modeDesc = 'WiFi ✅ Firebase ❌ — cached weather data in use';
    } else if (_systemMode == 'SENSOR_FAIL') {
      modeIcon = '⚠️';
      modeLabel = 'SENSOR FAILURE';
      modeTitle = 'Sensor Failure — Safe Mode';
      modeDesc = 'Sensors ❌ — 12h timed irrigation active';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: modeColor.withValues(alpha: 0.08),
        border: Border.all(color: modeColor.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(modeIcon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(
            modeLabel,
            style: TextStyle(
              color: modeColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            modeTitle,
            style: const TextStyle(
              color: Color(0xFFE8F5EC),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            modeDesc,
            style: const TextStyle(
              color: Color(0xFF90C4A0),
              fontSize: 11,
              height: 1.6,
            ),
          ),
          if (_systemMode != 'ONLINE') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                _buildStatCard(_formatDuration(_offlineSeconds),
                    'Offline Duration', modeColor),
                const SizedBox(width: 8),
                _buildStatCard('${_moisture.toStringAsFixed(1)}%', 'Last Soil',
                    const Color(0xFFE8F5EC)),
                const SizedBox(width: 8),
                _buildStatCard('${_pendingQueue.length}', 'Pending',
                    const Color(0xFFFFD54F)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          border: Border.all(color: valueColor.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: const Color(0xFF90C4A0).withValues(alpha: 0.6),
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivityStatus() {
    return _buildCard(
      title: '📡 Connectivity Status',
      child: Column(
        children: [
          _buildStatusRow('📶', 'WiFi',
              _systemMode == 'ONLINE' || _systemMode == 'FB_OFFLINE'),
          _buildStatusRow('☁️', 'Firebase', _systemMode == 'ONLINE'),
          _buildStatusRow('🌡️', 'Sensors', _systemMode != 'SENSOR_FAIL'),
          _buildStatusRow('💾', 'EEPROM', true),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String icon, String label, bool isOk) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFF183522).withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF90C4A0),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOk ? const Color(0xFF00FF7F) : const Color(0xFFFF5252),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      (isOk ? const Color(0xFF00FF7F) : const Color(0xFFFF5252))
                          .withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOk ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: isOk ? const Color(0xFF00FF7F) : const Color(0xFFFF5252),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackLayers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🛡️ Fallback Layers'),
        const SizedBox(height: 12),
        _buildLayerCard(
          '01',
          'Layer 1 — WiFi Fallback',
          'Using EEPROM saved thresholds + local sensor rules',
          const Color(0xFF00FF7F),
          _systemMode == 'WIFI_OFFLINE',
        ),
        const SizedBox(height: 10),
        _buildLayerCard(
          '02',
          'Layer 2 — Firebase Fallback',
          'WiFi ok but Firebase down — using cached weather data',
          const Color(0xFFFFD54F),
          _systemMode == 'FB_OFFLINE',
        ),
        const SizedBox(height: 10),
        _buildLayerCard(
          '03',
          'Layer 3 — Sensor Fallback',
          'Sensor invalid — timed irrigation every 12 hours',
          const Color(0xFFFFA040),
          _systemMode == 'SENSOR_FAIL',
        ),
      ],
    );
  }

  Widget _buildLayerCard(
      String num, String title, String desc, Color color, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(left: 6, top: 14, right: 14, bottom: 14),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.04) : const Color(0xFF0F251A),
        border: Border.all(
          color: isActive ? color : const Color(0xFF183522),
          width: isActive ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$num · $title',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isActive ? '🔴 Currently Active' : '⏸ On Standby',
                  style: const TextStyle(
                    color: Color(0xFFE8F5EC),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF90C4A0),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'ACTIVE' : 'STANDBY',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveRules() {
    final rules = [
      {
        'icon': _rain > _rainThreshold ? '🔒' : '✅',
        'text':
            'Rain probability (${_rain.toStringAsFixed(0)}%) checked against ${_rainThreshold.toStringAsFixed(0)}% threshold',
        'value': _rain > _rainThreshold ? 'LOCK' : 'PASS',
        'color': _rain > _rainThreshold
            ? const Color(0xFFFFD54F)
            : const Color(0xFF00FF7F),
      },
      {
        'icon': _moisture < _emergencyLevel ? '🚨' : '✅',
        'text':
            'Soil (${_moisture.toStringAsFixed(1)}%) checked against emergency level (${_emergencyLevel.toStringAsFixed(0)}%)',
        'value': _moisture < _emergencyLevel ? 'EMERGENCY' : 'PASS',
        'color': _moisture < _emergencyLevel
            ? const Color(0xFFFF5252)
            : const Color(0xFF00FF7F),
      },
      {
        'icon': _moisture < _soilThreshold ? '💧' : '✅',
        'text':
            'Soil (${_moisture.toStringAsFixed(1)}%) checked against irrigate threshold (${_soilThreshold.toStringAsFixed(0)}%)',
        'value': _moisture < _soilThreshold ? 'IRRIGATE' : 'SUFFICIENT',
        'color': _moisture < _soilThreshold
            ? const Color(0xFF00FF7F)
            : const Color(0xFF90C4A0),
      },
      {
        'icon': '⏰',
        'text': '12-hour timed irrigation safety timer tracking',
        'value': '11h 18m',
        'color': const Color(0xFF40C4FF),
      },
    ];

    return _buildCard(
      title: '⚡ Active Decision Rules',
      child: Column(
        children: rules.map((rule) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(color: const Color(0xFF183522).withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                Text(rule['icon'] as String,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rule['text'] as String,
                    style: const TextStyle(
                      color: Color(0xFF90C4A0),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
                Text(
                  rule['value'] as String,
                  style: TextStyle(
                    color: rule['color'] as Color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSafetyTimer() {
    final percentage = _pumpRuntime / 60;
    final color =
        _pumpRuntime > 50 ? const Color(0xFFFF5252) : const Color(0xFF00FF7F);

    return _buildCard(
      title: '⏱️ Safety Timer (60min max)',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pump runtime this session',
                style: TextStyle(color: Color(0xFF90C4A0), fontSize: 12),
              ),
              Text(
                '$_pumpRuntime / 60m',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '⚠️ Pump auto-stops after 60 minutes for safety',
            style: TextStyle(
              color: Color(0xFF90C4A0),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEEPROMData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('💾 EEPROM Saved Values'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            _buildEEPROMCell(
                'Soil Threshold', '${_soilThreshold.toStringAsFixed(0)}%'),
            _buildEEPROMCell(
                'Rain Threshold', '${_rainThreshold.toStringAsFixed(0)}%'),
            _buildEEPROMCell(
                'Emergency Level', '${_emergencyLevel.toStringAsFixed(0)}%'),
            _buildEEPROMCell('Last Soil', '${_moisture.toStringAsFixed(1)}%'),
            _buildEEPROMCell('Last Rain', '${_rain.toStringAsFixed(1)}%'),
            _buildEEPROMCell(
                'Last Temp', '${_temperature.toStringAsFixed(1)}°C'),
          ],
        ),
      ],
    );
  }

  Widget _buildEEPROMCell(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1E14),
        border: Border.all(color: const Color(0xFF183522)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFF90C4A0).withValues(alpha: 0.6),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE8F5EC),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingQueue() {
    return _buildCard(
      title: '📦 Pending Queue (${_pendingQueue.length}/10)',
      child: Column(
        children: [
          ..._pendingQueue.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF183522).withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF7F).withValues(alpha: 0.12),
                      border: Border.all(
                          color: const Color(0xFF00FF7F).withValues(alpha: 0.25)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF00FF7F),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '💧 ${item['soil']}% · 🌡️ ${item['temp']}°C · 💨 ${item['hum']}%',
                      style: const TextStyle(
                        color: Color(0xFF90C4A0),
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Text(
                    item['ts'],
                    style: const TextStyle(
                      color: Color(0xFF567060),
                      fontSize: 9,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _systemMode == 'ONLINE'
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ 3 records synced to Firebase'),
                        backgroundColor: Color(0xFF00FF7F),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            icon: Icon(
              _systemMode == 'ONLINE' ? Icons.cloud_upload : Icons.cloud_off,
              size: 18,
            ),
            label: Text(
              _systemMode == 'ONLINE'
                  ? 'Sync to Firebase Now'
                  : 'Will auto-sync when online',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _systemMode == 'ONLINE'
                  ? const Color(0xFF00FF7F)
                  : const Color(0xFF0C1E14),
              foregroundColor: _systemMode == 'ONLINE'
                  ? const Color(0xFF060E0A)
                  : const Color(0xFF567060),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _systemMode == 'ONLINE'
                      ? const Color(0xFF00FF7F)
                      : const Color(0xFF183522),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F251A),
            border: Border.all(color: const Color(0xFF183522)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFE8F5EC),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
