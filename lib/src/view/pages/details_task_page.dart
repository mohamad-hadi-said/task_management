import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/subtasks/subtasks_bloc.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
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
  @override
  void initState() {
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
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.task.isDone
                            ? Text(
                                'مكتملة',
                                style: TextStyle(
                                  color: Color(0xFF19C37B),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'غير مكتملة',
                                style: TextStyle(
                                  color: Color(0xFFFF5C5C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        Text('الحالة', style: TextStyle(color: Colors.white54)),
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
                        const Color(0xFF1A1D2E),
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
                        const Color(0xFF1A1D2E),
                        () {
                          sl<TasksBloc>().add(DeleteTask(widget.task.id));
                          Navigator.of(context).pop();
                        },
                      ),
                      _actionButton(
                        Icons.nightlight_round,
                        'تأجيل',
                        const Color(0xFF1A1D2E),
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
    return BlocBuilder<SubtasksBloc, SubtasksState>(
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white70),
          label: Text(label, style: const TextStyle(color: Colors.white70)),
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
