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
    // RTL direction
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(
          0xFF1A1D2E,
        ), // dark background similar to screenshot
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1D2E),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تفاصيل المهمة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
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
                  const Text(
                    'العنوان',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.task.title,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Description
                  const Text('الوصف', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Container(
                    height: 140,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.task.note,
                        style: TextStyle(
                          color: Colors.white70,
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
                  const Text(
                    'حالة المهمة',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white12)),
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
                                color: _getStatusColor(_currentStatus).withOpacity(0.2),
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
                            const Text('الحالة الحالية', style: TextStyle(color: Colors.white54)),
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
                      border: Border(top: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(widget.task.dueTime),
                          style: TextStyle(color: Colors.white54),
                        ),
                        Text(
                          'التوقيت',
                          style: TextStyle(color: Colors.white54),
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
                        const Color(0xFF111720),
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
                        const Color(0xFF111720),
                        () {
                          sl<TasksBloc>().add(DeleteTask(widget.task.id));
                          Navigator.of(context).pop();
                        },
                      ),
                      _actionButton(
                        Icons.nightlight_round,
                        'تأجيل',
                        const Color(0xFF111720),
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
    return BlocBuilder<SubtasksBloc, SubTasksState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is SubtasksLoading) {
          return Center(child: CircularProgressIndicator());
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
                      onChanged: (v) {
                        bloc.add(ToggleSubtaskStatus(subtask.id));
                      },
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
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
            color: const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'لا توجد مهام فرعية',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color bg,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Container(
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF111720),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton.icon(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(icon, color: Colors.white70),
          label: Text(label, style: const TextStyle(color: Colors.white70)),
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
            color: isSelected ? color : const Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? null : Border.all(color: Colors.white24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
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
