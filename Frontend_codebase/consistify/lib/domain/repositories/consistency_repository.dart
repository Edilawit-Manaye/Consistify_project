// consistify_frontend/lib/domain/repositories/consistency_repository.dart

import 'package:dartz/dartz.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/domain/entities/consistency.dart';

abstract class ConsistencyRepository {
  Future<Either<Failure, DailyConsistency>> getDailyConsistency();
  Future<Either<Failure, List<DailyConsistency>>> getConsistencyHistory({required DateTime startDate, required DateTime endDate});
  Future<Either<Failure, StreakInfo>> getStreaks();
}