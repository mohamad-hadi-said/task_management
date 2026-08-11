import 'package:flutter_bloc/flutter_bloc.dart';

class TaskSelectionCubit extends Cubit<Set<int>> {
  TaskSelectionCubit() : super(<int>{});

  void toggleSelection(int taskId) {
    final updated = Set<int>.from(state);
    if (updated.contains(taskId)) {
      updated.remove(taskId);
    } else {
      updated.add(taskId);
    }
    emit(updated);
  }

  void selectAll(List<int> taskIds) {
    emit(Set<int>.from(taskIds));
  }

  void clearSelection() {
    emit(<int>{});
  }

  bool isSelected(int taskId) {
    return state.contains(taskId);
  }
}
