import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/cubit/search_btn_cubit.dart';
import 'package:task_management/src/logic/tasks/tascks_state.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/view/pages/details_task_page.dart';
import 'package:task_management/src/view/widgets/task_card.dart';
import 'package:task_management/src/logic/tasks/tasks_event.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasksForCurrentTab();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTasksForCurrentTab() {
    switch (_selectedTabIndex) {
      case 0:
        sl<TasksBloc>().add(LoadTasks());
        break;
      case 1:
        sl<TasksBloc>().add(FilterTasksBySpecificStatus(TaskStatus.todo));
        break;
      case 2:
        sl<TasksBloc>().add(FilterTasksBySpecificStatus(TaskStatus.inProgress));
        break;
      case 3:
        sl<TasksBloc>().add(FilterTasksBySpecificStatus(TaskStatus.done));
        break;
    }
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

        // Status filter TabBar
        _buildStatusTabBar(),

        const SizedBox(height: 4),

        // Tasks list
        Expanded(
          child: BlocBuilder<TasksBloc, TasksState>(
            bloc: sl<TasksBloc>(),
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

  Widget _buildStatusTabBar() {
    final tabs = [
      {'title': 'الكل', 'icon': Icons.list_alt_rounded, 'color': const Color(0xFF4A90E2)},
      {'title': 'يجب إنجازه', 'icon': Icons.radio_button_unchecked, 'color': const Color(0xFF4A90E2)},
      {'title': 'قيد العمل', 'icon': Icons.sync, 'color': const Color(0xFFF39C12)},
      {'title': 'تم إنجازها', 'icon': Icons.check_circle_outline, 'color': const Color(0xFF27AE60)},
    ];

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          final tab = tabs[index];
          final Color accentColor = tab['color'] as Color;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
              _loadTasksForCurrentTab();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : const Color(0xFF2A2D3E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accentColor.withOpacity(0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
                border: Border.all(
                  color: isSelected ? accentColor : Colors.white12,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tab['title'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[300],
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
        style: const TextStyle(color: Colors.white),
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

  Widget _buildTasksList(List<TaskModel> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for FAB
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onToggleStatus: () {
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
              _loadTasksForCurrentTab();
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
        builder: (_) => DetailsTaskPage(task: task),
      ),
    ).then((_) {
      _loadTasksForCurrentTab();
    });
  }
}
