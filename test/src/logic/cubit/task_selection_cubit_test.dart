import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/src/logic/cubit/task_selection_cubit.dart';

void main() {
  group('TaskSelectionCubit', () {
    late TaskSelectionCubit cubit;

    setUp(() {
      cubit = TaskSelectionCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is an empty set', () {
      expect(cubit.state, isEmpty);
    });

    test('toggleSelection adds taskId when not selected', () {
      cubit.toggleSelection(1);
      expect(cubit.state, equals({1}));
      expect(cubit.isSelected(1), isTrue);
    });

    test('toggleSelection removes taskId when already selected', () {
      cubit.toggleSelection(1);
      cubit.toggleSelection(1);
      expect(cubit.state, isEmpty);
      expect(cubit.isSelected(1), isFalse);
    });

    test('selectAll selects all provided taskIds', () {
      cubit.selectAll([1, 2, 3]);
      expect(cubit.state, equals({1, 2, 3}));
    });

    test('clearSelection clears all selected taskIds', () {
      cubit.selectAll([1, 2, 3]);
      cubit.clearSelection();
      expect(cubit.state, isEmpty);
    });
  });
}
