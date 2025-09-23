import 'package:dartz/dartz.dart';
import 'package:task_management/core/cache/app_cache.dart';
import 'package:task_management/core/errors/exceptions.dart';
import 'package:task_management/core/errors/failures.dart';
import 'package:task_management/src/api/azkar_remote_data_source.dart';
import 'package:task_management/src/model/azkar_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


abstract class AzkarRepository {
 
  /// Fetches all azkar (for admin purposes or initial load)
  Future<Either<Failure, List<AzkarModel>>> getAllAzkar();
  
  /// Gets the user's current score
  Future<Either<Failure, int>> getUserScore(String userId);
  
}


class AzkarRepositoryImpl implements AzkarRepository {
  final AzkarRemoteDataSource remoteDataSource;
  final Connectivity connectivity;

  AzkarRepositoryImpl({required this.remoteDataSource, required this.connectivity});


  @override
  Future<Either<Failure, List<AzkarModel>>> getAllAzkar() async {
    try {
      final connectivityResults = await connectivity.checkConnectivity();
      if (connectivityResults.isEmpty || connectivityResults.first == ConnectivityResult.none) {
        List<AzkarModel> azkar = AppCache.instance.getAzkar();
        if(azkar.isEmpty){
          return Left(ServerFailure('لا يوجد اتصال بالانترنت \n قم بالتصال بالانترنت لتحميل الأذكار'));
        }
        return Right(azkar);
      }
      final azkar = await remoteDataSource.getAllAzkar();
      return Right(azkar);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUserScore(String userId) async {
    try {
      final score = await remoteDataSource.getUserScore(userId);
      return Right(score);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
