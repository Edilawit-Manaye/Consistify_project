import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart'; // NEW: Added for NetworkInfo

// Core
import 'package:consistify/core/constants/api_constants.dart';
import 'package:consistify/core/network/network_info.dart';

// Data Sources
import 'package:consistify/data/datasources/auth_remote_datasource.dart';
import 'package:consistify/data/datasources/auth_local_datasource.dart';
import 'package:consistify/data/datasources/consistency_remote_datasource.dart';

// Repositories
import 'package:consistify/data/repositories/auth_repository_impl.dart';
import 'package:consistify/data/repositories/consistency_repository_impl.dart';

// Domain Repositories
import 'package:consistify/domain/repositories/auth_repository.dart';
import 'package:consistify/domain/repositories/consistency_repository.dart';

// Use Cases - Auth
import 'package:consistify/domain/usecases/auth/register_user.dart';
import 'package:consistify/domain/usecases/auth/login_user.dart';
import 'package:consistify/domain/usecases/auth/get_user_profile.dart';
import 'package:consistify/domain/usecases/auth/update_user_profile.dart';
import 'package:consistify/domain/usecases/auth/logout_user.dart';

// Use Cases - Consistency
import 'package:consistify/domain/usecases/consistency/get_daily_consistency.dart';
import 'package:consistify/domain/usecases/consistency/get_consistency_history.dart';
import 'package:consistify/domain/usecases/consistency/get_streaks.dart';

// Blocs
import 'package:consistify/presentation/blocs/auth/auth_bloc.dart';
import 'package:consistify/presentation/blocs/consistency/consistency_bloc.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
        () => AuthBloc(
      registerUser: sl(),
      loginUser: sl(),
      getUserProfile: sl(),
      updateUserProfile: sl(),
      logoutUser: sl(),
      authRepository: sl(), // Injecting the repository itself to check isAuthenticated
      firebaseMessaging: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl(), secureStorage: sl()),
  );

  //! Features - Consistency
  // Bloc
  sl.registerFactory(
        () => ConsistencyBloc(
      getDailyConsistency: sl(),
      getConsistencyHistory: sl(),
      getStreaks: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDailyConsistencyUseCase(sl()));
  sl.registerLazySingleton(() => GetConsistencyHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetStreaksUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ConsistencyRepository>(
        () => ConsistencyRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(), // Needs AuthLocalDataSource to get token
    ),
  );

  // Data sources
  sl.registerLazySingleton<ConsistencyRemoteDataSource>(
        () => ConsistencyRemoteDataSourceImpl(client: sl(), baseUrl: ApiConstants.baseUrl),
  );

  //! Core
  // Internet Connection Checker Plus (MOVED UP FOR CORRECT DEPENDENCY ORDER)
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);

  // NetworkInfo (now InternetConnectionCheckerPlus is available via sl())
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // FlutterSecureStorage
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Http Client
  sl.registerLazySingleton(() => http.Client());

  // Firebase Messaging
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
}