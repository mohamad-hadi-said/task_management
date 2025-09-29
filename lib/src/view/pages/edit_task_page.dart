import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/subtasks/subtasks_bloc.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/core/utils/enums.dart';

class EditTaskPage extends StatefulWidget {
  EditTaskPage({Key? key, required this.task}) : super(key: key);

  final TaskModel task;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  late Priority _priority;
  late SubtasksBloc bloc;
  final _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);

    _dueDate = widget.task.dueTime;
    _dueTime = TimeOfDay.fromDateTime(widget.task.dueTime);
    _priority = widget.task.priority;

    bloc = sl<SubtasksBloc>()..add(LoadSubtasks(widget.task.id));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
     bloc.close();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D2E),
        elevation: 0,
        title: const Text(
          'تعديل المهمة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _updateTask,
            child: const Text(
              'حفظ التعديلات',
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
              _buildSectionTitle('عنوان المهمة'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hintText: 'أدخل عنوان المهمة',
                validator: (value) => value == null || value.isEmpty
                    ? 'يرجى إدخال عنوان المهمة'
                    : null,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('ملاحظات'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _noteController,
                hintText: 'أدخل ملاحظات المهمة',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

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

              _buildSectionTitle('الأولوية'),
              const SizedBox(height: 8),
              _buildPrioritySelector(),
              const SizedBox(height: 24),

              const SizedBox(height: 8),
              _buildSubtaskInput(),
              const SizedBox(height: 8),

              _buildSubtasksList(),
              const SizedBox(height: 100),
              _buildActionButtons(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
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
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2A2D3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
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
            Priority.high,
            'عالية',
            const Color(0xFFE74C3C),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityOption(
            Priority.medium,
            'متوسطة',
            const Color(0xFFF39C12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityOption(
            Priority.low,
            'منخفضة',
            const Color(0xFF27AE60),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityOption(Priority priority, String label, Color color) {
    final isSelected = _priority == priority;
    return GestureDetector(
      onTap: () => setState(() => _priority = priority),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.grey),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
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
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D3E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: subtask.isDone,
                      activeColor: const Color(0xFF4A90E2),
                      onChanged: (value) {
                        bloc.add(ToggleSubtaskStatus(subtask.id));
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          color: subtask.isDone ? Colors.grey : Colors.white,
                          decoration: subtask.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // حذف المهمة الفرعية
                        _removeSubtask(subtask.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _buildActionButton(
        //   Icons.nightlight_round,
        //   "تأجيل",
        //   const Color(0xFF4A90E2),
        //   () {},
        // ),
        _buildActionButton(Icons.delete, "حذف", Colors.redAccent, () {
          sl<TasksBloc>().add(DeleteTask(widget.task.id));
          Navigator.pop(context);
        }),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    void Function()? onPressed,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2D3E),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4A90E2),
            onPrimary: Colors.white,
            surface: Color(0xFF2A2D3E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4A90E2),
            onPrimary: Colors.white,
            surface: Color(0xFF2A2D3E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _dueTime = time);
  }

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      bloc.add(
        AddSubtask(
          SubtaskModel(
            id: 0,
            taskId: widget.task.id,
            title: _subtaskController.text,
          ),
        ),
      );
      _subtaskController.clear();
    }
  }

  void _removeSubtask(int index) {
    bloc.add(DeleteSubtask(index));
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      final dueDateTime = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      final updatedTask = TaskModel(
        id: widget.task.id,
        title: _titleController.text,
        note: _noteController.text,
        dueTime: dueDateTime,
        isDone: widget.task.isDone,
        priority: _priority,
      );

      sl<TasksBloc>().add(UpdateTask(task: updatedTask));
      Navigator.pop(context);
    }
  }
}
