// consistify_frontend/lib/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/exceptions.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';
import 'package:consistify/data/datasources/auth_remote_datasource.dart';
import 'package:consistify/domain/entities/user.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String notificationTime,
  }) async {
    try {
      await remoteDataSource.registerUser(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        username: username,
        notificationTime: notificationTime,
      );
      return const Right(unit);
    } on EmailAlreadyExistsException catch (e) {
      return Left(EmailAlreadyExistsFailure(e.message));
    } on InvalidInputException catch (e) {
      return Left(InvalidInputFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> loginUser({required String email, required String password}) async {
    try {
      final token = await remoteDataSource.loginUser(email: email, password: password);
      await localDataSource.cacheAuthToken(token);
      await localDataSource.cacheLoggedInStatus(true);
      return const Right(unit);
    } on InvalidCredentialsException catch (e) {
      return Left(InvalidCredentialsFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Left(InvalidCredentialsFailure('No authentication token found.'));
      }
      final userModel = await remoteDataSource.getUserProfile(token: token);
      return Right(userModel);
    } on InvalidCredentialsException catch (e) {
      await localDataSource.clearAllAuthData(); 
      return Left(InvalidCredentialsFailure(e.message));
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile({
    String? username,
    String? notificationTime,
    String? timezone,
    Map<String, String>? platformUsernames,
    String? fcmToken,
  }) async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Left(InvalidCredentialsFailure('No authentication token found.'));
      }
      await remoteDataSource.updateUserProfile(
        token: token,
        username: username,
        notificationTime: notificationTime,
        timezone: timezone,
        platformUsernames: platformUsernames,
        fcmToken: fcmToken,
      );
      return const Right(unit);
    } on InvalidCredentialsException catch (e) {
      await localDataSource.clearAllAuthData();
      return Left(InvalidCredentialsFailure(e.message));
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(e.message));
    } on InvalidInputException catch (e) {
      return Left(InvalidInputFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutUser() async {
    try {
      await localDataSource.clearAllAuthData();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await localDataSource.getAuthToken();
      return token != null && await localDataSource.getLoggedInStatus();
    } on CacheException {
      return false;
    }
  }
}