import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:consistify/core/errors/exceptions.dart';
import 'package:consistify/core/errors/failures.dart';
import 'package:consistify/data/repositories/consistency_repository_impl.dart';
import 'package:consistify/data/datasources/consistency_remote_datasource.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';
import 'package:consistify/domain/entities/consistency.dart';
import 'package:consistify/data/models/consistency_model.dart';

import '../test_helpers/mocks.dart';

void main() {
  late ConsistencyRemoteDataSource remote;
  late AuthLocalDataSource local;
  late ConsistencyRepositoryImpl repo;

  setUp(() {
    remote = MockConsistencyRemoteDataSource();
    local = MockAuthLocalDataSource();
    repo = ConsistencyRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  group('getDailyConsistency', () {
    test('returns Right(DailyConsistency) on success', () async {
      when(() => local.getAuthToken()).thenAnswer((_) async => 'jwt');
      when(() => remote.getDailyConsistency(token: any(named: 'token'))).thenAnswer((_) async =>
          DailyConsistencyModel(
            id: '1',
            userId: 'u1',
            date: DateTime(2025, 10, 23),
            platformActivities: const [],
            overallConsistent: false,
            createdAt: DateTime(2025, 10, 23),
            updatedAt: DateTime(2025, 10, 23),
          ));

      final result = await repo.getDailyConsistency();
      expect(result.isRight(), true);
      result.fold((_) {}, (val) {
        expect(val.overallConsistent, false);
      });
    });

    test('returns InvalidCredentialsFailure if token missing', () async {
      when(() => local.getAuthToken()).thenAnswer((_) async => null);
      final result = await repo.getDailyConsistency();
      expect(result.swap().getOrElse(() => const ServerFailure('')), isA<InvalidCredentialsFailure>());
    });

    test('clears auth on InvalidCredentialsException', () async {
      when(() => local.getAuthToken()).thenAnswer((_) async => 'jwt');
      when(() => remote.getDailyConsistency(token: any(named: 'token')))
          .thenThrow(const InvalidCredentialsException('Unauthorized'));
      when(() => local.clearAllAuthData()).thenAnswer((_) async {});

      final result = await repo.getDailyConsistency();
      expect(result.swap().getOrElse(() => const ServerFailure('')), isA<InvalidCredentialsFailure>());
      verify(() => local.clearAllAuthData()).called(1);
    });
  });

  group('getConsistencyHistory', () {
    test('maps models to entities and returns Right(list)', () async {
      when(() => local.getAuthToken()).thenAnswer((_) async => 'jwt');
      when(() => remote.getConsistencyHistory(token: any(named: 'token'), startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
          .thenAnswer((_) async => [
        DailyConsistencyModel(
          id: '1',
          userId: 'u1',
          date: DateTime(2025, 10, 22),
          platformActivities: const [],
          overallConsistent: true,
          createdAt: DateTime(2025, 10, 22),
          updatedAt: DateTime(2025, 10, 22),
        )
      ]);

      final result = await repo.getConsistencyHistory(startDate: DateTime(2025,10,1), endDate: DateTime(2025,10,31));
      expect(result.isRight(), true);
      result.fold((_) {}, (list) {
        expect(list, isA<List<DailyConsistency>>());
        expect(list.first.overallConsistent, true);
      });
    });
  });
}
