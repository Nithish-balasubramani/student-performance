import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../theme/aquaflow_theme.dart';
import '../providers/sensor_data_provider.dart';
import '../providers/auth_provider.dart';

class AquaFlowDashboard extends StatefulWidget {
  const AquaFlowDashboard({super.key});

  @override
  State<AquaFlowDashboard> createState() => _AquaFlowDashboardState();
}

class _AquaFlowDashboardState extends State<AquaFlowDashboard>
    with TickerProviderStateMixin {
  int _selectedNavIndex = 0;
  bool _aiCardVisible = true;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaFlowColors.soil,
      body: Stack(
        children: [
          _buildBackground(),
          Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _buildMainContent(),
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

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.6),
            radius: 1.5,
            colors: [
              AquaFlowColors.leaf.withValues(alpha: 0.25),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.8, 0.6),
              radius: 1.5,
              colors: [
                AquaFlowColors.water.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xF0120C04),
        border: Border(
          right: BorderSide(
            color: AquaFlowColors.mint.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildLogo(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavSection('OVERVIEW', [
                    {'icon': 'âŠž', 'label': 'Dashboard'},
                    {'icon': 'ðŸ—º', 'label': 'Zone Map'},
                    {'icon': 'ðŸ“Š', 'label': 'Analytics'},
                  ]),
                  _buildNavSection('CONTROL', [
                    {'icon': 'ðŸ•', 'label': 'Schedules', 'badge': '4'},
                    {'icon': 'ðŸ’§', 'label': 'Zones'},
                    {'icon': 'ðŸŒ¡', 'label': 'Sensors'},
                  ]),
                  _buildNavSection('SYSTEM', [
                    {'icon': 'ðŸ¤–', 'label': 'AI Insights', 'badge': '2'},
                    {'icon': 'âš™', 'label': 'Settings'},
                  ]),
                ],
              ),
            ),
          ),
          _buildUserCard(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AquaFlowColors.leafGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AquaFlowColors.water.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Text('ðŸŒ¿', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AquaFlow',
                style: AquaFlowTextStyles.serifDisplay.copyWith(
                  fontSize: 20,
                  color: AquaFlowColors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'SMART IRRIGATION',
                style: AquaFlowTextStyles.monoLabel.copyWith(
                  color: AquaFlowColors.textDim,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Text(
            title,
            style: AquaFlowTextStyles.monoLabel.copyWith(
              color: AquaFlowColors.textDim,
            ),
          ),
        ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isActive = _selectedNavIndex == index && title == 'OVERVIEW';
          return _buildNavItem(
            icon: item['icon']!,
            label: item['label']!,
            badge: item['badge'],
            isActive: isActive,
            onTap: () => setState(() => _selectedNavIndex = index),
          );
        }),
      ],
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    String? badge,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AquaFlowColors.mint.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: isActive ? AquaFlowColors.mint : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isActive ? AquaFlowColors.mint : AquaFlowColors.textDim,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            if (badge != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AquaFlowColors.ember,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final name = auth.user?.name ?? 'User';
        final initials = name
            .split(' ')
            .take(2)
            .map((e) => e.isNotEmpty ? e[0] : '')
            .join()
            .toUpperCase();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    gradient: AquaFlowColors.leafGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AquaFlowColors.textMain,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Farm Manager',
                        style: TextStyle(
                          fontSize: 11,
                          color: AquaFlowColors.textDim,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'â‹¯',
                  style: TextStyle(
                    fontSize: 13,
                    color: AquaFlowColors.textDim,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0x99120C04),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning ðŸŒ¾',
                  style: AquaFlowTextStyles.pageTitle,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Monday, Feb 23 Â· 3 zones active Â· Last sync 2 min ago',
                  style: TextStyle(
                    fontSize: 13,
                    color: AquaFlowColors.textDim,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AquaFlowColors.sky.withValues(alpha: 0.1),
              border: Border.all(
                color: AquaFlowColors.sky.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('â˜ï¸', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Consumer<SensorDataProvider>(
                  builder: (context, provider, _) {
                    final temp =
                        provider.sensorData?.temperature.toStringAsFixed(0) ??
                            '24';
                    final humidity =
                        provider.sensorData?.humidity.toStringAsFixed(0) ??
                            '72';
                    return Text(
                      '$tempÂ°C  Â·  Humidity $humidity%',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AquaFlowColors.sky,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildHeaderButton(
            'ðŸ”” Alerts',
            badge: '3',
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          _buildHeaderButton(
            'â–¶ Manual Water',
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text,
      {bool isPrimary = false, String? badge}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            gradient: isPrimary ? AquaFlowColors.leafGradient : null,
            color: isPrimary ? null : Colors.white.withValues(alpha: 0.06),
            border: isPrimary
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AquaFlowColors.leaf.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isPrimary ? Colors.white : AquaFlowColors.textMain,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 4),
                Text(
                  badge,
                  style: const TextStyle(
                    color: AquaFlowColors.ember,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          _buildStatCards(),
          const SizedBox(height: 24),
          if (_aiCardVisible) ...[
            _buildAICard(),
            const SizedBox(height: 24),
          ],
          _buildDashboardGrid(),
          const SizedBox(height: 20),
          _buildWaterUsageChart(),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final moisture =
            provider.sensorData?.moistureLevel.toStringAsFixed(0) ?? '62';
        final pumpStatus = provider.sensorData?.pumpStatus ?? false;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'WATER SAVED TODAY',
                value: '1,240',
                unit: 'L',
                change: 'â–² 18% vs yesterday',
                color: AquaFlowColors.mint,
                isPositive: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                label: 'TOTAL FLOW',
                value: '4.8',
                unit: 'mÂ³',
                change: 'Today Â· target 5.2 mÂ³',
                color: AquaFlowColors.sky,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                label: 'SOIL MOISTURE AVG',
                value: moisture,
                unit: '%',
                change: 'â–² Optimal range',
                color: AquaFlowColors.sun,
                isPositive: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                label: 'ACTIVE ZONES',
                value: pumpStatus ? '3' : '0',
                unit: '/8',
                change: '2 need attention',
                color: AquaFlowColors.ember,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    String? unit,
    String? change,
    required Color color,
    bool isPositive = false,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, double opacity, child) {
        return Transform.translate(
          offset: Offset(0, 12 * (1 - opacity)),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AquaFlowColors.panel,
          border: Border.all(color: AquaFlowColors.panelBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AquaFlowTextStyles.monoLabel.copyWith(
                    color: AquaFlowColors.textDim,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: AquaFlowTextStyles.statValue.copyWith(
                        color: color,
                      ),
                    ),
                    if (unit != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 2),
                        child: Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AquaFlowColors.textDim,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                if (change != null)
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPositive
                          ? AquaFlowColors.mint
                          : AquaFlowColors.textDim,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAICard() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AquaFlowColors.water.withValues(alpha: 0.1),
              AquaFlowColors.leaf.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(
            color: AquaFlowColors.sky.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AquaFlowColors.waterGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('ðŸ¤–', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI RECOMMENDATION',
                    style: AquaFlowTextStyles.monoLabel.copyWith(
                      color: AquaFlowColors.sky,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rain forecast detected. I suggest reducing irrigation by 30% for the next 24 hours to save water. Soil moisture levels are currently optimal.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFFd4cfc7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildAIButton(
                        'âœ“ Apply suggestion',
                        true,
                        () {
                          setState(() => _aiCardVisible = false);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAIButton(
                        'Dismiss',
                        false,
                        () {
                          setState(() => _aiCardVisible = false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIButton(String text, bool isAccept, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isAccept
                ? AquaFlowColors.mint.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: isAccept
                  ? AquaFlowColors.mint.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isAccept ? AquaFlowColors.mint : AquaFlowColors.textDim,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildZonePanel()),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: _buildScheduleColumn()),
        const SizedBox(width: 20),
        Expanded(flex: 1, child: _buildRightColumn()),
      ],
    );
  }

  Widget _buildZonePanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AquaFlowColors.panel,
        border: Border.all(color: AquaFlowColors.panelBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Zone Overview', style: AquaFlowTextStyles.panelTitle),
              const Text(
                'Manage Zones â†’',
                style: TextStyle(
                  fontSize: 12,
                  color: AquaFlowColors.mint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AquaFlowColors.moss.withValues(alpha: 0.4),
              border: Border.all(
                color: AquaFlowColors.mint.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: AquaFlowColors.mint.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Zone Map View',
                    style: TextStyle(
                      color: AquaFlowColors.textDim,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '6 zones configured',
                    style: TextStyle(
                      color: AquaFlowColors.textDim.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildZoneTag('Zone A', true),
              _buildZoneTag('Zone B', false),
              _buildZoneTag('Zone C', true),
              _buildZoneTag('Zone D âš ', false, isWarning: true),
              _buildZoneTag('Zone E', false),
              _buildZoneTag('Zone F', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneTag(String label, bool isActive, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive
            ? AquaFlowColors.mint.withValues(alpha: 0.15)
            : isWarning
                ? AquaFlowColors.sun.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: isActive
              ? AquaFlowColors.mint.withValues(alpha: 0.3)
              : isWarning
                  ? AquaFlowColors.sun.withValues(alpha: 0.3)
                  : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final opacity = isActive
                  ? 0.6 + 0.4 * math.sin(_pulseController.value * 2 * math.pi)
                  : 1.0;
              return Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive
                      ? AquaFlowColors.mint
                      : isWarning
                          ? AquaFlowColors.sun
                          : AquaFlowColors.textDim,
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AquaFlowColors.mint.withValues(alpha: opacity),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? AquaFlowColors.mint
                  : isWarning
                      ? AquaFlowColors.sun
                      : AquaFlowColors.textDim,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleColumn() {
    return Column(
      children: [
        _buildActiveZoneCard(),
        const SizedBox(height: 16),
        _buildSchedulePanel(),
      ],
    );
  }

  Widget _buildActiveZoneCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AquaFlowColors.leaf.withValues(alpha: 0.3),
            AquaFlowColors.water.withValues(alpha: 0.2),
          ],
        ),
        border: Border.all(
          color: AquaFlowColors.mint.withValues(alpha: 0.25),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AquaFlowColors.mint,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AquaFlowColors.mint.withValues(alpha: 
                            0.6 +
                                0.4 *
                                    math.sin(
                                        _pulseController.value * 2 * math.pi),
                          ),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              Text(
                'NOW RUNNING',
                style: AquaFlowTextStyles.monoLabel.copyWith(
                  color: AquaFlowColors.mint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Zone A â€” Front Lawn',
            style: AquaFlowTextStyles.serifDisplay.copyWith(
              fontSize: 20,
              color: AquaFlowColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Drip Â· 3 L/min Â· Started 14:22',
            style: TextStyle(
              fontSize: 12,
              color: AquaFlowColors.textDim,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.68,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AquaFlowColors.flowGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildMetricMini('Elapsed', '18:34', AquaFlowColors.sky),
              ),
              const SizedBox(width: 10),
              Expanded(
                child:
                    _buildMetricMini('Remaining', '11:26', AquaFlowColors.mint),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricMini(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AquaFlowColors.textDim,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulePanel() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AquaFlowColors.panel,
          border: Border.all(color: AquaFlowColors.panelBorder),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Schedule', style: AquaFlowTextStyles.panelTitle),
                const Text(
                  'Edit â†’',
                  style: TextStyle(
                    fontSize: 12,
                    color: AquaFlowColors.mint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView(
                children: [
                  _buildScheduleItem('06:00', 'Zone C', 'Completed Â· 110 L',
                      '30m', true, false),
                  _buildScheduleItem(
                      '14:22', 'Zone A', 'Running now', '30m', true, true),
                  _buildScheduleItem('16:00', 'Zone B', 'AI Skip suggested',
                      '45m', false, false),
                  _buildScheduleItem(
                      '18:30', 'Zone F', 'High priority', '20m', true, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String zone, String meta,
      String duration, bool isOn, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isActive ? 0.06 : 0.03),
        border: Border.all(
          color: isActive
              ? AquaFlowColors.mint.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: isActive ? AquaFlowColors.mint : AquaFlowColors.sky,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AquaFlowColors.textMain,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  meta,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        isActive ? AquaFlowColors.mint : AquaFlowColors.textDim,
                  ),
                ),
              ],
            ),
          ),
          Text(
            duration,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: AquaFlowColors.textDim,
            ),
          ),
          const SizedBox(width: 10),
          _buildToggle(isOn),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isOn) {
    return Container(
      width: 36,
      height: 20,
      decoration: BoxDecoration(
        color: isOn ? AquaFlowColors.leaf : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildSensorsPanel(),
        const SizedBox(height: 16),
        _buildAlertsPanel(),
      ],
    );
  }

  Widget _buildSensorsPanel() {
    return Consumer<SensorDataProvider>(
      builder: (context, provider, _) {
        final data = provider.sensorData;
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AquaFlowColors.panel,
            border: Border.all(color: AquaFlowColors.panelBorder),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Soil Sensors', style: AquaFlowTextStyles.panelTitle),
                  const Text(
                    'All â†’',
                    style: TextStyle(
                      fontSize: 12,
                      color: AquaFlowColors.mint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildSensorItem(
                'Zone A Moisture',
                '${data?.moistureLevel.toStringAsFixed(0) ?? '62'}%',
                (data?.moistureLevel ?? 62) / 100,
                AquaFlowColors.flowGradient,
                'Optimal range: 50â€“75%',
              ),
              const SizedBox(height: 14),
              _buildSensorItem(
                'Temperature',
                '${data?.temperature.toStringAsFixed(1) ?? '24.2'}Â°C',
                0.48,
                AquaFlowColors.waterGradient,
                'Comfortable range',
              ),
              const SizedBox(height: 14),
              _buildSensorItem(
                'Humidity',
                '${data?.humidity.toStringAsFixed(0) ?? '72'}%',
                (data?.humidity ?? 72) / 100,
                const LinearGradient(
                  colors: [AquaFlowColors.sky, AquaFlowColors.mist],
                ),
                'Normal levels',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSensorItem(String label, String value, double progress,
      Gradient gradient, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AquaFlowColors.textMain,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AquaFlowColors.mint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          hint,
          style: const TextStyle(
            fontSize: 11,
            color: AquaFlowColors.textDim,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsPanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AquaFlowColors.panel,
        border: Border.all(color: AquaFlowColors.panelBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alerts', style: AquaFlowTextStyles.panelTitle),
              const Text(
                'Clear all',
                style: TextStyle(
                  fontSize: 12,
                  color: AquaFlowColors.mint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildAlertItem(
            'âš ï¸',
            'Check system pressure',
            '10m ago',
            AquaFlowColors.sun,
          ),
          const SizedBox(height: 8),
          _buildAlertItem(
            'ðŸŒ§',
            'Rain expected. AI adjusted schedule.',
            '1h ago',
            AquaFlowColors.sky,
          ),
          const SizedBox(height: 8),
          _buildAlertItem(
            'âœ“',
            'Zone C completed: 110L used.',
            '8h ago',
            AquaFlowColors.mint,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String icon, String text, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: color, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: AquaFlowColors.textMain,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AquaFlowColors.textDim,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterUsageChart() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AquaFlowColors.panel,
        border: Border.all(color: AquaFlowColors.panelBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Water Usage', style: AquaFlowTextStyles.panelTitle),
              Row(
                children: [
                  _buildLegendItem('Used (L)', AquaFlowColors.water),
                  const SizedBox(width: 16),
                  _buildLegendItem('Saved', AquaFlowColors.mint),
                  const SizedBox(width: 16),
                  const Text(
                    'Full Report â†’',
                    style: TextStyle(
                      fontSize: 12,
                      color: AquaFlowColors.mint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Mon', 0.8, 0.15),
                _buildBar('Tue', 0.7, 0.23),
                _buildBar('Wed', 0.9, 0.1),
                _buildBar('Thu', 0.6, 0.28),
                _buildBar('Fri', 0.78, 0.18),
                _buildBar('Sat', 0.73, 0.2),
                _buildBar('Sun', 1.0, 0.31, isToday: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AquaFlowColors.textDim,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, double used, double saved,
      {bool isToday = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 140 * used,
                      decoration: BoxDecoration(
                        gradient: AquaFlowColors.waterGradient,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: AquaFlowColors.sky.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Container(
                      height: 140 * saved,
                      decoration: BoxDecoration(
                        gradient: AquaFlowColors.flowGradient,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        boxShadow: isToday
                            ? [
                                BoxShadow(
                                  color: AquaFlowColors.mint.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                color: isToday ? AquaFlowColors.mint : AquaFlowColors.textDim,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
