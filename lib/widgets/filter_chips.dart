// lib/widgets/filter_chips.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // RTL support
          child: Row(
            children: [
              const SizedBox(width: 4),
              _buildChip(
                context,
                label: 'همه',
                filter: FilterType.all,
                icon: Icons.list_rounded,
                provider: provider,
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: 'فعال',
                filter: FilterType.active,
                icon: Icons.radio_button_unchecked_rounded,
                provider: provider,
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: 'تکمیل‌شده',
                filter: FilterType.completed,
                icon: Icons.check_circle_outline_rounded,
                provider: provider,
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: 'امروز',
                filter: FilterType.today,
                icon: Icons.today_rounded,
                provider: provider,
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: 'معوق',
                filter: FilterType.overdue,
                icon: Icons.warning_amber_rounded,
                provider: provider,
                activeColor: AppTheme.priorityHigh,
              ),
              const SizedBox(width: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required FilterType filter,
    required IconData icon,
    required TaskProvider provider,
    Color activeColor = AppTheme.primary,
  }) {
    final isSelected = provider.currentFilter == filter;

    return GestureDetector(
      onTap: () => provider.setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE0E0E0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xFF636E72),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : const Color(0xFF636E72),
            ),
          ],
        ),
      ),
    );
  }
}
