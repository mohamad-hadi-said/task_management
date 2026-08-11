import 'package:task_management/src/logic/home/home_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/repositories/task_repository.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<LoadHome>(_onLoadHome);
  }

  final taskRepository = sl<TaskRepository>();

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, error: false));
    try {
      final tasks = await taskRepository.getAllTasks();
      if (tasks.isEmpty) {
        emit(
          state.copyWith(
            loading: false,
            error: false,
            errorMessage: 'لايوجد مهام!',
          ),
        );
      } else {
        emit(state.copyWith(loading: false, error: false, tasks: tasks));
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: true,
          errorMessage: "يوجد خطأ : $e",
        ),
      );
    }
  }
}
