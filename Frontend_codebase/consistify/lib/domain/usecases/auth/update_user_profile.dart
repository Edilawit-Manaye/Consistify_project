// consistify_frontend/lib/domain/usecases/auth/update_user_profile.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/repositories/auth_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    String? username,
    String? notificationTime,
    String? timezone,
    Map<String, String>? platformUsernames,
    String? fcmToken,
  }) async {
    return await repository.updateUserProfile(
      username: username,
      notificationTime: notificationTime,
      timezone: timezone,
      platformUsernames: platformUsernames,
      fcmToken: fcmToken,
    );
  }
}