import 'package:get_it/get_it.dart';
import 'package:task_management/src/logic/cubit/search_btn_cubit.dart';
import 'package:task_management/src/logic/subtasks/subtasks_bloc.dart';
import 'package:task_management/src/repositories/task_repository.dart';
import 'package:task_management/core/services/database_helper.dart';
import 'package:task_management/src/api/database_controller.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Connectivity for network status
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  sl.registerLazySingleton<TaskRepository>(() => TaskRepository());

  sl.registerLazySingleton<DatabaseController>(
    () => DatabaseController(taskRepository: sl()),
  );

  // Blocs
  sl.registerLazySingleton<TasksBloc>(() => TasksBloc(taskRepository: sl()));
  sl.registerFactory<SubtasksBloc>(() => SubtasksBloc(taskRepository: sl()));

  sl.registerLazySingleton(() => SearchBtnCubit());
}
