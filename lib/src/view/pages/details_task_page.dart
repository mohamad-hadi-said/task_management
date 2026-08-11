import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/subtasks/subtascks_state.dart';
import 'package:task_management/src/logic/subtasks/subtasks_bloc.dart';
import 'package:task_management/src/logic/subtasks/subtasks_event.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/logic/tasks/tasks_event.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/view/pages/edit_task_page.dart';

class DetailsTaskPage extends StatefulWidget {
  const DetailsTaskPage({Key? key, required this.task}) : super(key: key);
  final TaskModel task;

  @override
  State<DetailsTaskPage> createState() => _DetailsTaskPageState();
}

class _DetailsTaskPageState extends State<DetailsTaskPage> {
  late SubtasksBloc bloc;
  final _subtaskController = TextEditingController();
  late TaskStatus _currentStatus;

  @override
  void initState() {
    _currentStatus = widget.task.status;
    bloc = sl<SubtasksBloc>()..add(LoadSubtasks(widget.task.id));
    super.initState();
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white12 : Colors.black12;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'تفاصيل المهمة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward, color: theme.colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // Title field (read-only style)
                  Text(
                    'العنوان',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Description
                  Text(
                    'الوصف',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 140,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.task.note,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subtasks header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المهام الفرعية',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskPage(task: widget.task),
                            ),
                          ).then((_) {
                            // Refresh tasks after adding new task
                            bloc.add(LoadSubtasks(widget.task.id));
                          });
                        },
                        icon: const Icon(Icons.add, color: Color(0xFF1E88E5)),
                        label: const Text(
                          'إضافة مهمة فرعية',
                          style: TextStyle(color: Color(0xFF1E88E5)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Subtasks list
                  _buildSubtasksList(),

                  const SizedBox(height: 22),

                  // Status block
                  Text(
                    'حالة المهمة',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(_currentStatus).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(_currentStatus),
                                ),
                              ),
                              child: Text(
                                _currentStatus.arabicTitle,
                                style: TextStyle(
                                  color: _getStatusColor(_currentStatus),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'الحالة الحالية',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _statusChip(TaskStatus.todo, 'يجب إنجازه', const Color(0xFF4A90E2)),
                            const SizedBox(width: 8),
                            _statusChip(TaskStatus.inProgress, 'قيد العمل', const Color(0xFFF39C12)),
                            const SizedBox(width: 8),
                            _statusChip(TaskStatus.done, 'تم إنجازها', const Color(0xFF27AE60)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Time row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(widget.task.dueTime),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          'التوقيت',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Action buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        Icons.edit,
                        'تعديل',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskPage(task: widget.task),
                            ),
                          ).then((_) {
                            // Refresh tasks after adding new task
                            bloc.add(LoadSubtasks(widget.task.id));
                          });
                        },
                      ),

                      _actionButton(
                        Icons.delete,
                        'حذف',
                        () {
                          sl<TasksBloc>().add(DeleteTask(widget.task.id));
                          Navigator.of(context).pop();
                        },
                      ),
                      _actionButton(
                        Icons.nightlight_round,
                        'تأجيل',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskPage(task: widget.task),
                            ),
                          ).then((_) {
                            // Refresh tasks after adding new task
                            bloc.add(LoadSubtasks(widget.task.id));
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtasksList() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<SubtasksBloc, SubTasksState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is SubtasksLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SubtasksLoaded) {
          final List<SubtaskModel> subtasks = state.subtasks ?? [];
          return Column(
            children: subtasks.map((subtask) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: subtask.isDone,
                      activeColor: const Color(0xFF4A90E2),
                      onChanged: (v) {
                        bloc.add(ToggleSubtaskStatus(subtask.id));
                      },
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          color: subtask.isDone
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : theme.colorScheme.onSurface,
                          fontSize: 15,
                          decoration: subtask.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),
          child: Text(
            'لا توجد مهام فرعية',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: TextButton.icon(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            elevation: isDark ? 2 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
          ),
          icon: Icon(icon, color: theme.colorScheme.onSurface),
          label: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF4A90E2);
      case TaskStatus.inProgress:
        return const Color(0xFFF39C12);
      case TaskStatus.done:
        return const Color(0xFF27AE60);
    }
  }

  Widget _statusChip(TaskStatus status, String label, Color color) {
    final isSelected = _currentStatus == status;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          sl<TasksBloc>().add(ChangeTaskStatus(widget.task.id, status));
          setState(() {
            _currentStatus = status;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? null
                : Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }
}
