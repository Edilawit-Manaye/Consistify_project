// consistify_frontend/lib/domain/usecases/auth/login_user.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required String email, required String password}) async {
    return await repository.loginUser(email: email, password: password);
  }
}