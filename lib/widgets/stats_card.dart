// lib/widgets/stats_card.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  final int total;
  final int completed;
  final int active;
  final int overdue;
  final int today;
  final double completionRate;

  const StatsCard({
    super.key,
    required this.total,
    required this.completed,
    required this.active,
    required this.overdue,
    required this.today,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                '${(completionRate * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Text(
                'پیشرفت کلی',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completionRate,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStat('معوق', overdue.toString(), AppTheme.secondary),
              const SizedBox(width: 16),
              _buildStat('امروز', today.toString(), AppTheme.warning),
              const Spacer(),
              _buildStat('فعال', active.toString(), Colors.white),
              const SizedBox(width: 16),
              _buildStat('تکمیل', completed.toString(), AppTheme.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 11,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}
