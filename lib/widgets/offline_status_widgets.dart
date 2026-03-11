import 'package:flutter/material.dart';
import '../services/offline_mode_service.dart';

/// Example Widget: Offline Status Banner
/// Shows a banner at the top when system is offline
/// Add this to any screen where you want to show offline status
class OfflineStatusBanner extends StatefulWidget {
  const OfflineStatusBanner({super.key});

  @override
  State<OfflineStatusBanner> createState() => _OfflineStatusBannerState();
}

class _OfflineStatusBannerState extends State<OfflineStatusBanner> {
  String _currentMode = 'ONLINE';

  @override
  void initState() {
    super.initState();
    _currentMode = OfflineModeService().currentMode;

    // Listen to mode changes
    OfflineModeService().modeStream.listen((mode) {
      if (mounted) {
        setState(() => _currentMode = mode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMode == 'ONLINE') {
      return const SizedBox.shrink(); // Hide when online
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor().withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _getBackgroundColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getBannerText(),
              style: TextStyle(
                color: _getBackgroundColor(),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            _getModeLabel(),
            style: TextStyle(
              color: _getBackgroundColor(),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (_currentMode) {
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

  String _getBannerText() {
    switch (_currentMode) {
      case 'WIFI_OFFLINE':
        return '📵 No WiFi — Local mode active';
      case 'FB_OFFLINE':
        return '☁️ Firebase down — Using cached data';
      case 'SENSOR_FAIL':
        return '⚠️ Sensor failure — Safe mode active';
      default:
        return '✅ All systems operational';
    }
  }

  String _getModeLabel() {
    switch (_currentMode) {
      case 'WIFI_OFFLINE':
        return 'OFFLINE';
      case 'FB_OFFLINE':
        return 'FB DOWN';
      case 'SENSOR_FAIL':
        return 'SAFE MODE';
      default:
        return 'ONLINE';
    }
  }
}

/// Example: How to use in your existing screens
///
/// In your HomeScreen or Dashboard:
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Column(
///       children: [
///         const OfflineStatusBanner(), // Add this at top
///         Expanded(
///           child: YourExistingContent(),
///         ),
///       ],
///     ),
///   );
/// }
/// ```

/// Example Widget: Offline Indicator Badge
/// Shows a small badge in the corner of any widget
class OfflineIndicatorBadge extends StatefulWidget {
  final Widget child;

  const OfflineIndicatorBadge({
    super.key,
    required this.child,
  });

  @override
  State<OfflineIndicatorBadge> createState() => _OfflineIndicatorBadgeState();
}

class _OfflineIndicatorBadgeState extends State<OfflineIndicatorBadge> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _isOnline = OfflineModeService().isOnline;

    OfflineModeService().modeStream.listen((mode) {
      if (mounted) {
        setState(() => _isOnline = mode == 'ONLINE');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isOnline)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Example: Connection Status Widget
/// Shows detailed connection status
class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({super.key});

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  Map<String, bool> _status = {'wifi': true, 'firebase': true, 'sensor': true};

  @override
  void initState() {
    super.initState();
    _updateStatus();

    OfflineModeService().modeStream.listen((_) => _updateStatus());
  }

  void _updateStatus() {
    if (mounted) {
      setState(() {
        _status = OfflineModeService().getConnectivityStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F251A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF183522)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connection Status',
            style: TextStyle(
              color: Color(0xFFE8F5EC),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusRow('WiFi', _status['wifi'] ?? false, Icons.wifi),
          _buildStatusRow(
              'Firebase', _status['firebase'] ?? false, Icons.cloud),
          _buildStatusRow('Sensors', _status['sensor'] ?? false, Icons.sensors),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isConnected, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                isConnected ? const Color(0xFF00FF7F) : const Color(0xFFFF5252),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF90C4A0),
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(0xFF00FF7F).withValues(alpha: 0.1)
                  : const Color(0xFFFF5252).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isConnected
                    ? const Color(0xFF00FF7F).withValues(alpha: 0.3)
                    : const Color(0xFFFF5252).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              isConnected ? 'ONLINE' : 'OFFLINE',
              style: TextStyle(
                color: isConnected
                    ? const Color(0xFF00FF7F)
                    : const Color(0xFFFF5252),
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
}

/// Example: How to check sensor health and update service
/// 
/// ```dart
/// void checkSensorData(double moisture, double temp) {
///   // Validate sensor readings
///   bool isValid = moisture >= 0 && moisture <= 100 &&
///                  temp >= -10 && temp <= 50;
///   
///   // Update offline service
///   OfflineModeService().setSensorHealth(isValid);
///   
///   if (!isValid) {
///     print('⚠️ Invalid sensor data detected!');
///   }
/// }
/// ```

/// Example: Sync pending data when back online
/// 
/// ```dart
/// void syncPendingData() async {
///   if (OfflineModeService().isOnline) {
///     // Sync your queued data to Firebase
///     await FirebaseDatabase.instance
///         .ref('sensor_data')
///         .push()
///         .set(yourPendingData);
///     
///     print('✅ Data synced successfully');
///   } else {
///     print('📵 Still offline - data queued for later');
///   }
/// }
/// ```
