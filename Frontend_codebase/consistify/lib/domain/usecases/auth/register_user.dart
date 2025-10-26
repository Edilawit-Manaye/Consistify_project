// consistify_frontend/lib/domain/usecases/auth/register_user.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String notificationTime,
  }) async {
    return await repository.registerUser(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      username: username,
      notificationTime: notificationTime,
    );
  }
}