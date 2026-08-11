enum Priority { high, medium, low }

enum TaskStatus {
  todo,
  inProgress,
  done;

  String get arabicTitle {
    switch (this) {
      case TaskStatus.todo:
        return 'يجب إنجازه';
      case TaskStatus.inProgress:
        return 'قيد العمل';
      case TaskStatus.done:
        return 'تم إنجازها';
    }
  }
}

