// consistify_frontend/lib/domain/usecases/auth/logout_user.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class LogoutUserUseCase {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logoutUser();
  }
}