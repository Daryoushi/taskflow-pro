// lib/widgets/task_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isOverdue
                  ? AppTheme.priorityHigh.withOpacity(0.3)
                  : task.isDueToday
                      ? AppTheme.priorityMedium.withOpacity(0.3)
                      : const Color(0xFFF0F0F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox(),
                const SizedBox(width: 12),
                Expanded(child: _buildContent()),
                const SizedBox(width: 8),
                _buildPriorityIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 26,
        height: 26,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: task.isCompleted ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: task.isCompleted
                ? AppTheme.primary
                : const Color(0xFFCED4DA),
            width: 2,
          ),
        ),
        child: task.isCompleted
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _buildContent() {
    final categoryLabels = ['شخصی', 'کاری', 'خرید', 'سلامت', 'آموزش', 'سایر'];
    final categoryColor = AppTheme.categoryColor(task.category.index);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          task.title,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: task.isCompleted
                ? const Color(0xFFADB5BD)
                : const Color(0xFF2D3436),
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: const Color(0xFFADB5BD),
          ),
        ),
        if (task.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            task.description,
            textDirection: TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 12,
              color: Color(0xFF636E72),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          alignment: WrapAlignment.end,
          children: [
            // Category chip
            _buildChip(
              label: categoryLabels[task.category.index],
              color: categoryColor,
            ),
            // Due date
            if (task.dueDate != null)
              _buildChip(
                label: DateFormat('dd/MM').format(task.dueDate!),
                color: task.isOverdue
                    ? AppTheme.priorityHigh
                    : task.isDueToday
                        ? AppTheme.priorityMedium
                        : const Color(0xFF636E72),
                icon: task.isOverdue
                    ? Icons.warning_rounded
                    : Icons.calendar_today_rounded,
              ),
            // Reminder
            if (task.hasReminder)
              _buildChip(
                label: '',
                color: AppTheme.primary,
                icon: Icons.notifications_rounded,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon != null && label.isEmpty ? 6 : 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          if (icon != null) ...[
            if (label.isNotEmpty) const SizedBox(width: 3),
            Icon(icon, size: 11, color: color),
          ],
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    final color = AppTheme.priorityColor(task.priority.index);
    return Container(
      width: 4,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
