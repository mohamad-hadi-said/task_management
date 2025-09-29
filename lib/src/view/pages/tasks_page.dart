import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/cubit/search_btn_cubit.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/view/pages/details_task_page.dart';
import 'package:task_management/src/view/pages/edit_task_page.dart';
import 'package:task_management/src/view/widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tasks when page initializes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        BlocBuilder<SearchBtnCubit, SearchBtnState>(
          bloc: sl<SearchBtnCubit>(),
          builder: (context, state) {
            if (state.isToggled) {
              return _buildSearchBar();
            }
            return const SizedBox.shrink();
          },
        ),

        // Tasks list
        Expanded(
          child: BlocBuilder<TasksBloc, TasksState>(
            bloc: sl<TasksBloc>()..add(LoadTasks()),
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4A90E2),
                    ),
                  ),
                );
              } else if (state is TasksLoaded) {
                if (state.tasks.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildTasksList(state.tasks);
              } else if (state is TasksError) {
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          hintText: 'البحث في المهام...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          sl<TasksBloc>().add(SearchTasks(value));
        },
      ),
    );
  }

  Widget _buildTasksList(List tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for FAB
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onToggleStatus: (isDone) {
            sl<TasksBloc>().add(ToggleTaskStatus(task.id));
          },
          onTap: () {
            // Navigate to task details
            _navigateToTaskDetails(task);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا توجد مهام',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على + لإضافة مهمة جديدة',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              sl<TasksBloc>().add(LoadTasks());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _navigateToTaskDetails(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => EditTaskPage(task: task),
        builder: (_) => DetailsTaskPage(task: task),
      ),
    ).then((_) {
      // Refresh tasks after adding new task
      sl<TasksBloc>().add(LoadTasks());
    });
  }
}
