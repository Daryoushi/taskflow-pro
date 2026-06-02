// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/filter_chips.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
      _fabController.forward();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            if (!_isSearching) _buildStatsSection(),
            _buildFilterSection(),
            _buildTaskList(),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
        child: FloatingActionButton.extended(
          onPressed: () => _navigateToAddTask(),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            'وظیفه جدید',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          elevation: 6,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: const Color(0xFFF8F9FF),
      expandedHeight: 80,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'جستجو در وظایف...',
                border: InputBorder.none,
                filled: false,
              ),
              onChanged: (value) {
                context.read<TaskProvider>().setSearch(value);
              },
            )
          : const Text(
              'TaskFlow Pro',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                context.read<TaskProvider>().setSearch('');
              }
            });
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              key: ValueKey(_isSearching),
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        IconButton(
          onPressed: _showSortMenu,
          icon: const Icon(Icons.sort_rounded, color: Color(0xFF2D3436)),
        ),
        IconButton(
          onPressed: _showMoreMenu,
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3436)),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: StatsCard(
              total: provider.totalCount,
              completed: provider.completedCount,
              active: provider.activeCount,
              overdue: provider.overdueCount,
              today: provider.todayCount,
              completionRate: provider.completionRate,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: FilterChipsWidget(),
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }

        final tasks = provider.filteredTasks;

        if (tasks.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(provider.currentFilter),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskCard(
                    task: task,
                    onToggle: () => provider.toggleTask(task.id),
                    onDelete: () => _confirmDelete(task.id),
                    onEdit: () => _navigateToEditTask(task),
                  ),
                );
              },
              childCount: tasks.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(FilterType filter) {
    String emoji = '';
    String title = '';
    String subtitle = '';

    switch (filter) {
      case FilterType.all:
        emoji = '✅';
        title = 'هنوز وظیفه‌ای ندارید!';
        subtitle = 'با کلیک روی دکمه + اولین وظیفه‌تان را اضافه کنید';
        break;
      case FilterType.active:
        emoji = '🎉';
        title = 'همه کارها انجام شد!';
        subtitle = 'شما همه وظایف فعال را کامل کرده‌اید';
        break;
      case FilterType.completed:
        emoji = '📝';
        title = 'هنوز کاری کامل نشده';
        subtitle = 'وظایف تکمیل‌شده اینجا نمایش داده می‌شوند';
        break;
      case FilterType.today:
        emoji = '📅';
        title = 'امروز کاری ندارید';
        subtitle = 'وظایف با سررسید امروز اینجا نمایش داده می‌شوند';
        break;
      case FilterType.overdue:
        emoji = '⏰';
        title = 'هیچ کار معوقی ندارید';
        subtitle = 'عالی! همه کارها به موقع انجام شده‌اند';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 14,
                color: Color(0xFF636E72),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
    );
  }

  void _navigateToEditTask(task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
    );
  }

  Future<void> _confirmDelete(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'حذف وظیفه',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید این وظیفه را حذف کنید؟',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Vazirmatn'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Vazirmatn')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Vazirmatn')),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<TaskProvider>().deleteTask(taskId);
    }
  }

  void _showSortMenu() {
    final provider = context.read<TaskProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'مرتب‌سازی بر اساس',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _sortTile('تاریخ ایجاد', SortType.createdAt, provider, ctx),
            _sortTile('تاریخ سررسید', SortType.dueDate, provider, ctx),
            _sortTile('اولویت', SortType.priority, provider, ctx),
            _sortTile('حروف الفبا', SortType.alphabetical, provider, ctx),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(String label, SortType sort, TaskProvider provider, BuildContext ctx) {
    final isSelected = provider.currentSort == sort;
    return ListTile(
      onTap: () {
        provider.setSort(sort);
        Navigator.pop(ctx);
      },
      title: Text(
        label,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Vazirmatn',
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected ? AppTheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppTheme.primary)
          : null,
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text(
                      'پاک کردن تکمیل‌شده‌ها',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
                    ),
                    content: const Text(
                      'تمام وظایف کامل‌شده حذف می‌شوند. مطمئنید؟',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('انصراف', style: TextStyle(fontFamily: 'Vazirmatn')),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('حذف', style: TextStyle(fontFamily: 'Vazirmatn')),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  context.read<TaskProvider>().deleteCompletedTasks();
                }
              },
              leading: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
              title: const Text(
                'حذف وظایف تکمیل‌شده',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
