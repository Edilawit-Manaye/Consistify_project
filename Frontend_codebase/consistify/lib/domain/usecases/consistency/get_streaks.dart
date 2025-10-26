// consistify_frontend/lib/domain/usecases/consistency/get_streaks.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';

class GetStreaksUseCase {
  final ConsistencyRepository repository;

  GetStreaksUseCase(this.repository);

  Future<Either<Failure, StreakInfo>> call() async {
    return await repository.getStreaks();
  }
}