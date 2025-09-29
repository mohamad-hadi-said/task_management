import 'package:flutter/material.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/core/utils/enums.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleStatus;

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
                // Checkbox
                GestureDetector(
                  onTap: () => onToggleStatus?.call(!task.isDone),
                  child: Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: task.isDone ? _getPriorityColor() : Colors.white12,
                        width: 1,
                      ),
                      color: task.isDone
                          ? _getPriorityColor()
                          : Colors.grey[800]!,
                    ),
                    child: task.isDone
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Task time and priority
                      Row(
                        children: [
                          // Priority badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getPriorityText(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
