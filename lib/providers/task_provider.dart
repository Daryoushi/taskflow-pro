// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

enum FilterType { all, active, completed, today, overdue }
enum SortType { createdAt, dueDate, priority, alphabetical }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  FilterType _currentFilter = FilterType.all;
  SortType _currentSort = SortType.createdAt;
  String _searchQuery = '';
  bool _isLoading = false;

  final _db = DatabaseService.instance;
  final _uuid = const Uuid();

  // Getters
  bool get isLoading => _isLoading;
  FilterType get currentFilter => _currentFilter;
  SortType get currentSort => _currentSort;
  String get searchQuery => _searchQuery;

  List<Task> get filteredTasks {
    List<Task> result = List.from(_tasks);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply filter
    switch (_currentFilter) {
      case FilterType.active:
        result = result.where((t) => !t.isCompleted).toList();
        break;
      case FilterType.completed:
        result = result.where((t) => t.isCompleted).toList();
        break;
      case FilterType.today:
        result = result.where((t) => t.isDueToday).toList();
        break;
      case FilterType.overdue:
        result = result.where((t) => t.isOverdue).toList();
        break;
      case FilterType.all:
        break;
    }

    // Apply sort
    switch (_currentSort) {
      case SortType.createdAt:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.dueDate:
        result.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortType.priority:
        result.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortType.alphabetical:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return result;
  }

  // Statistics
  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get activeCount => _tasks.where((t) => !t.isCompleted).length;
  int get overdueCount => _tasks.where((t) => t.isOverdue).length;
  int get todayCount => _tasks.where((t) => t.isDueToday).length;
  double get completionRate =>
      totalCount > 0 ? completedCount / totalCount : 0.0;

  // Load all tasks from DB
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _db.getAllTasks();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask({
    required String title,
    String description = '',
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    TaskCategory category = TaskCategory.personal,
    bool hasReminder = false,
    DateTime? reminderTime,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      category: category,
      hasReminder: hasReminder,
      reminderTime: reminderTime,
    );

    await _db.createTask(task);
    _tasks.insert(0, task);
    notifyListeners();
  }

  // Toggle task completion
  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await _db.updateTask(_tasks[index]);
      notifyListeners();
    }
  }

  // Update a task
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _db.updateTask(updatedTask);
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _db.deleteTask(id);
    notifyListeners();
  }

  // Delete all completed
  Future<void> deleteCompletedTasks() async {
    _tasks.removeWhere((t) => t.isCompleted);
    await _db.deleteCompletedTasks();
    notifyListeners();
  }

  // Set filter
  void setFilter(FilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Set sort
  void setSort(SortType sort) {
    _currentSort = sort;
    notifyListeners();
  }

  // Set search
  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Get tasks by category
  List<Task> getTasksByCategory(TaskCategory category) {
    return _tasks.where((t) => t.category == category).toList();
  }
}
