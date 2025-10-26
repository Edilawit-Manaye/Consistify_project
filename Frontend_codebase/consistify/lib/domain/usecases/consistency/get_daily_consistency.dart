// consistify_frontend/lib/domain/usecases/consistency/get_daily_consistency.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';

class GetDailyConsistencyUseCase {
  final ConsistencyRepository repository;

  GetDailyConsistencyUseCase(this.repository);

  Future<Either<Failure, DailyConsistency>> call() async {
    return await repository.getDailyConsistency();
  }
}