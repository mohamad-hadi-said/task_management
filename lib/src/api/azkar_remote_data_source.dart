import 'dart:developer' as dev;

import 'package:task_management/core/cache/app_cache.dart';
import 'package:task_management/core/errors/exceptions.dart';
import 'package:task_management/src/model/azkar_model.dart';

abstract class AzkarRemoteDataSource {
  Future<List<AzkarModel>> getAllAzkar();
  Future<int> getUserScore(String userId);
}

class AzkarRemoteDataSourceImpl implements AzkarRemoteDataSource {

  AzkarRemoteDataSourceImpl();

  @override
  Future<List<AzkarModel>> getAllAzkar() async {
    /* try {
      dev.log('Fetching azkar from Supabase...');
      final response = await _supabaseService.fetchData('azkar');
      dev.log('Supabase response: ${response.toString()}');
      dev.log('Response type: ${response.runtimeType}');
      dev.log('Response length: ${(response as List).length}');

      if (response.isEmpty) {
        dev.log('Warning: No azkar found in database');
        return [];
      }
      final azkar =
          (response as List)
              .map(
                (q) =>
                    AzkarModel.fromJson(Map<String, dynamic>.from(q as Map)),
              )
              .toList();
      dev.log('Successfully parsed ${azkar.length} azkar');
      await AppCache.instance.saveAzkar(azkar);
      return azkar;
    } catch (e) {
      dev.log('Error fetching azkar: ${e.toString()}');
      throw ServerException(e.toString());
    } */
    return [];
  }

  @override
  Future<int> getUserScore(String userId) async {
    /* try {
      final response = await _supabaseService.client
          .from('user_profiles')
          .select('score')
          .eq('id', userId)
          .single()
          .catchError((_) => <String, dynamic>{});

      if (response.isNotEmpty) {
        return response['score'] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      // If there's an error (e.g., user doesn't exist), return 0
    } */
    return 0;
  }
}
