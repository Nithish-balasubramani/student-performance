import 'package:flutter/material.dart';

/// Widget for controlling pump with toggle and status display
class PumpControlWidget extends StatelessWidget {
  final bool isPumpOn;
  final Function(bool) onToggle;
  final bool isLoading;

  const PumpControlWidget({
    super.key,
    required this.isPumpOn,
    required this.onToggle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPumpOn
              ? [Colors.blue.shade400, Colors.blue.shade700]
              : [Colors.grey.shade300, Colors.grey.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPumpOn
                ? Colors.blue.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pump Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPumpOn ? Icons.water_drop : Icons.water_drop_outlined,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Status Text
          const Text(
            'Water Pump',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPumpOn ? 'Running' : 'Stopped',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 24),

          // Toggle Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => onToggle(!isPumpOn),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isPumpOn ? Colors.blue : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      isPumpOn ? 'Turn OFF' : 'Turn ON',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact pump status indicator
class PumpStatusIndicator extends StatelessWidget {
  final bool isPumpOn;

  const PumpStatusIndicator({
    super.key,
    required this.isPumpOn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPumpOn ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPumpOn ? Colors.blue : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isPumpOn ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isPumpOn ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPumpOn ? Colors.blue.shade800 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
