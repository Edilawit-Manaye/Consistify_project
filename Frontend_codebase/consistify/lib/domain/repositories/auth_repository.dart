// consistify_frontend/lib/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String notificationTime,
  });
  Future<Either<Failure, Unit>> loginUser({required String email, required String password});
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, Unit>> updateUserProfile({
    String? username,
    String? notificationTime,
    String? timezone,
    Map<String, String>? platformUsernames,
    String? fcmToken,
  });
  Future<Either<Failure, Unit>> logoutUser();
  Future<bool> isAuthenticated();
}