import 'package:get_it/get_it.dart';
import 'package:task_management/src/api/azkar_remote_data_source.dart';
import 'package:task_management/src/repositories/quiz_repository_impl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {

  // Connectivity for network status
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Data sources
  sl.registerLazySingleton<AzkarRemoteDataSource>(
    () => AzkarRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AzkarRepository>(
    () => AzkarRepositoryImpl(
      remoteDataSource: sl(),
      connectivity: sl(),
    ),
  );
}
