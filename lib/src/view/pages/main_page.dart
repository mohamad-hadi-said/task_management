import 'package:flutter/material.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/view/pages/add_task_page.dart';
import 'package:task_management/src/view/pages/settings_page.dart';
import 'package:task_management/src/view/pages/tasks_page.dart';
import 'package:task_management/src/view/widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex.clamp(0, 2 - 1),
        children: [
          TasksPage(),
          SettingsPage(), // Placeholder for Notifications Page
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // // Handle navigation to other pages
          // _handleNavigation(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A1D2E),
      elevation: 0,
      title: const Text(
        'مهامي',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        // Search icon
        IconButton(
          onPressed: () {
            // Focus on search field
            FocusScope.of(context).requestFocus(FocusNode());
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        // Filter icon
        IconButton(
          onPressed: () => _showFilterDialog(),
          icon: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text(
          'تصفية المهام',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                'جميع المهام',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                sl<TasksBloc>().add(LoadTasks());
              },
            ),
            ListTile(
              title: const Text(
                'المهام المكتملة',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                sl<TasksBloc>().add(FilterTasksByStatus(true));
              },
            ),
            ListTile(
              title: const Text(
                'المهام المعلقة',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                sl<TasksBloc>().add(FilterTasksByStatus(false));
              },
            ),
            ListTile(
              title: const Text(
                'أولوية عالية',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                sl<TasksBloc>().add(FilterTasksByPriority(Priority.high));
              },
            ),
          ],
        ),
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
