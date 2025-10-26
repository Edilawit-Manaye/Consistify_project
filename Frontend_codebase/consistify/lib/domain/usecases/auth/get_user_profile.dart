// consistify_frontend/lib/domain/usecases/auth/get_user_profile.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/user.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class GetUserProfileUseCase {
  final AuthRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getUserProfile();
  }
}