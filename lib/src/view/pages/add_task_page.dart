import 'package:flutter/material.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/src/logic/tasks/tasks_event.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _dueDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _dueTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 1) % 24,
    minute: TimeOfDay.now().minute,
  );
  Priority _priority = Priority.medium;
  TaskStatus _status = TaskStatus.todo;

  final List<String> _subtasks = [];
  final _subtaskController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'إضافة مهمة جديدة',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: const Text(
              'حفظ',
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task title
              _buildSectionTitle('عنوان المهمة'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hintText: 'أدخل عنوان المهمة',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Task note
              _buildSectionTitle('ملاحظات'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _noteController,
                hintText: 'أدخل ملاحظات المهمة',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Due date and time
              _buildSectionTitle('التوقيت'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeField(
                      label: 'التاريخ',
                      value: _formatDate(_dueDate),
                      onTap: _selectDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateTimeField(
                      label: 'الوقت',
                      value: _formatTime(_dueTime),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Priority
              _buildSectionTitle('الأولوية'),
              const SizedBox(height: 8),
              _buildPrioritySelector(),
              const SizedBox(height: 24),

              // Task Status
              _buildSectionTitle('حالة المهمة'),
              const SizedBox(height: 8),
              _buildStatusSelector(),
              const SizedBox(height: 24),

              // Subtasks
              _buildSectionTitle('المهام الفرعية'),
              const SizedBox(height: 8),
              _buildSubtaskInput(),
              const SizedBox(height: 8),
              _buildSubtasksList(),
              const SizedBox(height: 100), // Space for keyboard
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.colorScheme.onSurface),
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPriorityOption(
            priority: Priority.high,
            label: 'عالية',
            color: const Color(0xFFE74C3C),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityOption(
            priority: Priority.medium,
            label: 'متوسطة',
            color: const Color(0xFFF39C12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityOption(
            priority: Priority.low,
            label: 'منخفضة',
            color: const Color(0xFF27AE60),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityOption({
    required Priority priority,
    required String label,
    required Color color,
  }) {
    final isSelected = _priority == priority;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _priority = priority),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtaskInput() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _subtaskController,
            hintText: 'أدخل مهمة فرعية',
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _addSubtask,
          icon: const Icon(Icons.add_circle, color: Color(0xFF4A90E2)),
        ),
      ],
    );
  }

  Widget _buildSubtasksList() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_subtasks.isEmpty) {
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
    }

    return Column(
      children: _subtasks.asMap().entries.map((entry) {
        final index = entry.key;
        final subtask = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  subtask,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              IconButton(
                onPressed: () => _removeSubtask(index),
                icon: const Icon(Icons.remove_circle, color: Colors.red),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }

  Future<void> _selectDate() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF4A90E2),
                    onPrimary: Colors.white,
                    surface: Color(0xFF2A2D3E),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF4A90E2),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF1A1D2E),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _selectTime() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF4A90E2),
                    onPrimary: Colors.white,
                    surface: Color(0xFF2A2D3E),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF4A90E2),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF1A1D2E),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => _dueTime = time);
    }
  }

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      setState(() {
        _subtasks.add(_subtaskController.text);
        _subtaskController.clear();
      });
    }
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  Widget _buildStatusSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildStatusOption(
            status: TaskStatus.todo,
            color: const Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatusOption(
            status: TaskStatus.inProgress,
            color: const Color(0xFFF39C12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatusOption(
            status: TaskStatus.done,
            color: const Color(0xFF27AE60),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusOption({
    required TaskStatus status,
    required Color color,
  }) {
    final isSelected = _status == status;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _status = status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: isDark ? Colors.white12 : Colors.black12),
        ),
        child: Text(
          status.arabicTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final dueDateTime = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      final task = TaskModel(
        id: 0, // Will be auto-generated
        title: _titleController.text,
        note: _noteController.text,
        dueTime: dueDateTime,
        status: _status,
        priority: _priority,
      );

      // Add task with subtasks
      
      sl<TasksBloc>().add(AddTask(task, subtaskTitles: _subtasks));

      Navigator.pop(context);
    }
  }
}
