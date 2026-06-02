// lib/screens/add_edit_task_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;
  DateTime? _dueDate;
  bool _hasReminder = false;
  DateTime? _reminderTime;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.task != null;

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');

    if (_isEditing) {
      _priority = widget.task!.priority;
      _category = widget.task!.category;
      _dueDate = widget.task!.dueDate;
      _hasReminder = widget.task!.hasReminder;
      _reminderTime = widget.task!.reminderTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(_isEditing ? 'ویرایش وظیفه' : 'وظیفه جدید'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'ذخیره',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSectionTitle('اولویت'),
              const SizedBox(height: 10),
              _buildPrioritySelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('دسته‌بندی'),
              const SizedBox(height: 10),
              _buildCategorySelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('تاریخ و یادآوری'),
              const SizedBox(height: 10),
              _buildDateTimePicker(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF636E72),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      maxLength: 100,
      style: const TextStyle(
        fontFamily: 'Vazirmatn',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        hintText: 'عنوان وظیفه...',
        labelText: 'عنوان',
        labelStyle: TextStyle(fontFamily: 'Vazirmatn'),
        prefixIcon: Icon(Icons.task_alt_rounded, color: AppTheme.primary),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'لطفاً عنوان وظیفه را وارد کنید';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      maxLines: 3,
      maxLength: 500,
      style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
      decoration: const InputDecoration(
        hintText: 'توضیحات (اختیاری)...',
        labelText: 'توضیحات',
        labelStyle: TextStyle(fontFamily: 'Vazirmatn'),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 48),
          child: Icon(Icons.notes_rounded, color: AppTheme.primary),
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: TaskPriority.values.reversed.map((priority) {
        final isSelected = _priority == priority;
        final labels = ['بالا', 'متوسط', 'پایین'];
        final colors = [AppTheme.priorityHigh, AppTheme.priorityMedium, AppTheme.priorityLow];
        final icons = [Icons.arrow_upward_rounded, Icons.remove_rounded, Icons.arrow_downward_rounded];
        final idx = priority.index;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priority = priority),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? colors[idx].withOpacity(0.15) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colors[idx] : const Color(0xFFE0E0E0),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(icons[idx], color: colors[idx], size: 20),
                  const SizedBox(height: 4),
                  Text(
                    labels[idx],
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? colors[idx] : const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySelector() {
    final labels = ['شخصی', 'کاری', 'خرید', 'سلامت', 'آموزش', 'سایر'];
    final icons = [
      Icons.person_rounded,
      Icons.work_rounded,
      Icons.shopping_cart_rounded,
      Icons.favorite_rounded,
      Icons.school_rounded,
      Icons.category_rounded,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskCategory.values.map((category) {
        final isSelected = _category == category;
        final idx = category.index;
        final color = AppTheme.categoryColor(idx);

        return GestureDetector(
          onTap: () => setState(() => _category = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labels[idx],
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? color : const Color(0xFF636E72),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(icons[idx], size: 16, color: color),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          // Due Date
          GestureDetector(
            onTap: _pickDueDate,
            child: Row(
              children: [
                if (_dueDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _dueDate = null),
                    child: const Icon(Icons.close_rounded, color: Colors.red, size: 18),
                  ),
                const Spacer(),
                Text(
                  _dueDate != null
                      ? DateFormat('yyyy/MM/dd').format(_dueDate!)
                      : 'انتخاب سررسید',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 14,
                    color: _dueDate != null ? const Color(0xFF2D3436) : const Color(0xFFADB5BD),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.calendar_today_rounded, color: AppTheme.primary, size: 20),
              ],
            ),
          ),
          if (_dueDate != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                Switch(
                  value: _hasReminder,
                  onChanged: (val) async {
                    setState(() => _hasReminder = val);
                    if (val) await _pickReminderTime();
                  },
                  activeColor: AppTheme.primary,
                ),
                const Spacer(),
                Text(
                  _hasReminder && _reminderTime != null
                      ? DateFormat('HH:mm').format(_reminderTime!)
                      : 'یادآوری',
                  style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.notifications_rounded, color: AppTheme.primary, size: 20),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      locale: const Locale('fa'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _pickReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final base = _dueDate ?? DateTime.now();
      setState(() {
        _reminderTime = DateTime(base.year, base.month, base.day, time.hour, time.minute);
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TaskProvider>();

    if (_isEditing) {
      final updated = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        category: _category,
        dueDate: _dueDate,
        hasReminder: _hasReminder,
        reminderTime: _reminderTime,
      );
      provider.updateTask(updated);
    } else {
      provider.addTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        category: _category,
        dueDate: _dueDate,
        hasReminder: _hasReminder,
        reminderTime: _reminderTime,
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing ? 'وظیفه ویرایش شد ✅' : 'وظیفه اضافه شد ✅',
          style: const TextStyle(fontFamily: 'Vazirmatn'),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
