import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/cubit/search_btn_cubit.dart';
import 'package:task_management/src/logic/cubit/task_selection_cubit.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/view/pages/add_task_page.dart';
import 'package:task_management/src/view/pages/settings_page.dart';
import 'package:task_management/src/view/pages/tasks_page.dart';
import 'package:task_management/src/view/widgets/bottom_navigation.dart';
import 'package:task_management/src/logic/tasks/tasks_event.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),

      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: IndexedStack(
          index: _currentIndex.clamp(0, 1),
          children: const [TasksPage(), SettingsPage()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          sl<TaskSelectionCubit>().clearSelection();
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 10),
      child: BlocBuilder<TaskSelectionCubit, Set<int>>(
        bloc: sl<TaskSelectionCubit>(),
        builder: (context, selectedIds) {
          final isSelectionMode = selectedIds.isNotEmpty;

          return AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Container(),
            ),
            shape: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
                width: 0.5,
              ),
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: isSelectionMode
                ? IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      sl<TaskSelectionCubit>().clearSelection();
                    },
                  )
                : null,
            title: Text(
              isSelectionMode
                  ? 'تم تحديد (${selectedIds.length})'
                  : 'وقتي أمانة',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            centerTitle: true,
            actions: isSelectionMode
                ? [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                        foregroundColor: Colors.redAccent,
                      ),
                      onPressed: () => _confirmDeleteSelectedTasks(context, selectedIds),
                      icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                    ),
                    const SizedBox(width: 10),
                  ]
                : [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      onPressed: () {
                        sl<SearchBtnCubit>().toggle();
                      },
                      icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(width: 10),
                  ],
          );
        },
      ),
    );
  }

  void _confirmDeleteSelectedTasks(BuildContext context, Set<int> selectedIds) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'حذف المهام المحددة',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت تأكد من رغبتك في حذف (${selectedIds.length}) من المهام المحددة؟',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              sl<TasksBloc>().add(DeleteMultipleTasks(selectedIds.toList()));
              sl<TaskSelectionCubit>().clearSelection();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المهام المحددة بنجاح'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTask(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    ).then((_) {
      // Refresh tasks after adding new task
      sl<TasksBloc>().add(LoadTasks());
    });
  }
}
