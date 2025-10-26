


// consistify_frontend/lib/data/repositories/consistency_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/exceptions.dart'; 
import 'package:consistify/core/errors/failures.dart';   
import 'package:consistify/data/datasources/consistency_remote_datasource.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';

class ConsistencyRepositoryImpl implements ConsistencyRepository {
  final ConsistencyRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ConsistencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, String>> _getAuthToken() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Left(InvalidCredentialsFailure('No authentication token found.'));
      }
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DailyConsistency>> getDailyConsistency() async {
    final tokenResult = await _getAuthToken();
    return tokenResult.fold(
          (failure) => Left(failure),
          (token) async {
        try {
          final dailyConsistencyModel = await remoteDataSource.getDailyConsistency(token: token);
          return Right(dailyConsistencyModel.toEntity()); 
        } on InvalidCredentialsException catch (e) {
          await localDataSource.clearAllAuthData();
          return Left(InvalidCredentialsFailure(e.message));
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<DailyConsistency>>> getConsistencyHistory({required DateTime startDate, required DateTime endDate}) async {
    final tokenResult = await _getAuthToken();
    return tokenResult.fold(
          (failure) => Left(failure),
          (token) async {
        try {
          final historyModels = await remoteDataSource.getConsistencyHistory(token: token, startDate: startDate, endDate: endDate);
         
          return Right(historyModels.map((model) => model.toEntity()).toList());
        } on InvalidCredentialsException catch (e) {
          await localDataSource.clearAllAuthData();
          return Left(InvalidCredentialsFailure(e.message));
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        }
      },
    );
  }

  @override
  Future<Either<Failure, StreakInfo>> getStreaks() async {
    final tokenResult = await _getAuthToken();
    return tokenResult.fold(
          (failure) => Left(failure),
          (token) async {
        try {
          final streakInfoModel = await remoteDataSource.getStreaks(token: token);
          return Right(streakInfoModel.toEntity()); 
        } on InvalidCredentialsException catch (e) {
          await localDataSource.clearAllAuthData();
          return Left(InvalidCredentialsFailure(e.message));
        } on ServerException catch (e) {
          return Left(ServerFailure(e.message));
        }
      },
    );
  }
}