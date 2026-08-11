import 'package:flutter/material.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/core/utils/enums.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status icon toggle
                GestureDetector(
                  onTap: onToggleStatus,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _getStatusBgColor(),
                      border: Border.all(
                        color: _getStatusBorderColor(),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task title
                      Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Task note
                      if (task.note.isNotEmpty) ...[
                        Text(
                          task.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade100,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Task status & priority badges
                      Row(
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusBgColor(),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusBorderColor(),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              task.status.arabicTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Priority badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getPriorityText(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Time
                          Text(
                            _formatTime(task.dueTime),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          task.dueTime.isAfter(DateTime.now())
                              ? Icon(
                                  Icons.access_time,
                                  color: Colors.grey[400],
                                  size: 14,
                                )
                              : Icon(
                                  Icons.done,
                                  color: Colors.red[400],
                                  size: 14,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (task.status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.sync;
      case TaskStatus.done:
        return Icons.check;
    }
  }

  Color _getStatusBgColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return const Color(0x554A90E2);
      case TaskStatus.inProgress:
        return const Color(0x66F39C12);
      case TaskStatus.done:
        return const Color(0x6627AE60);
    }
  }

  Color _getStatusBorderColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return const Color(0xFF4A90E2);
      case TaskStatus.inProgress:
        return const Color(0xFFF39C12);
      case TaskStatus.done:
        return const Color(0xFF27AE60);
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.high:
        return const Color(0x88E74C3C); // Red, more transparent (~53%)
      case Priority.medium:
        return const Color(0x88F39C12); // Orange, more transparent (~53%)
      case Priority.low:
        return const Color(0x8827AE60); // Green, more transparent (~53%)
    }
  }

  String _getPriorityText() {
    switch (task.priority) {
      case Priority.high:
        return 'عالية';
      case Priority.medium:
        return 'متوسطة';
      case Priority.low:
        return 'منخفضة';
    }
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
