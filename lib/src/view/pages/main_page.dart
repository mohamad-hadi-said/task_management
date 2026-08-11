import 'package:flutter/material.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/cubit/search_btn_cubit.dart';
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
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: Container(),
      ),
      shape: Border(
        bottom: BorderSide(
          color: theme.brightness == Brightness.dark
              ? Colors.white12
              : Colors.black12,
          width: 0.5,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        'وقتي أمانة',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      centerTitle: true,
      actions: [
        // Search icon
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
        SizedBox(width: 10),
      ],
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
