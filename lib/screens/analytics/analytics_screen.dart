import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Insights'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soil Moisture Trend
            Text(
              'Soil Moisture Trend',
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
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const hours = [
                                  '00',
                                  '04',
                                  '08',
                                  '12',
                                  '16',
                                  '20',
                                  '24'
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < hours.length) {
                                  return Text(hours[value.toInt()],
                                      style: const TextStyle(fontSize: 10));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 45),
                              const FlSpot(1, 42),
                              const FlSpot(2, 38),
                              const FlSpot(3, 28),
                              const FlSpot(4, 50),
                              const FlSpot(5, 48),
                              const FlSpot(6, 45),
                            ],
                            isCurved: true,
                            color: const Color(0xFF2196F3),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF2196F3)
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIndicator(
                          'Current', '45%', const Color(0xFF2196F3)),
                      _buildIndicator(
                          'Average', '42%', const Color(0xFF757575)),
                      _buildIndicator(
                          'Optimal', '50%', const Color(0xFF4CAF50)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Irrigation Efficiency
            Text(
              'Irrigation Efficiency',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEfficiencyCard(
                          'Auto Mode', '87%', const Color(0xFF4CAF50)),
                      _buildEfficiencyCard(
                          'Manual Mode', '73%', const Color(0xFFFF9800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Automation saves 14% more water compared to manual control',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Performance Metrics
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildMetricCard('Uptime', '98.5%', Icons.cloud_done,
                    const Color(0xFF4CAF50)),
                _buildMetricCard(
                    'Response', '1.2s', Icons.speed, const Color(0xFF2196F3)),
                _buildMetricCard(
                    'Savings', '₹450', Icons.savings, const Color(0xFFFF9800)),
                _buildMetricCard(
                    'CO₂ Saved', '125kg', Icons.eco, const Color(0xFF4CAF50)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEfficiencyCard(String label, String efficiency, Color color) {
    return Column(
      children: [
        Text(
          efficiency,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}
