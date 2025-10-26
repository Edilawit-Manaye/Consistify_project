// consistify_frontend/lib/data/datasources/auth_local_datasource.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:consistify/core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
  Future<void> cacheLoggedInStatus(bool isLoggedIn);
  Future<bool> getLoggedInStatus();
  Future<void> clearAllAuthData(); 
}

const String CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';
const String IS_LOGGED_IN = 'IS_LOGGED_IN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await secureStorage.write(key: CACHED_AUTH_TOKEN, value: token);
    } catch (e) {
      throw CacheException('Failed to cache auth token: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return await secureStorage.read(key: CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheException('Failed to retrieve auth token: $e');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await secureStorage.delete(key: CACHED_AUTH_TOKEN);
    } catch (e) {
      throw CacheException('Failed to clear auth token: $e');
    }
  }

  @override
  Future<void> cacheLoggedInStatus(bool isLoggedIn) async {
    try {
      await sharedPreferences.setBool(IS_LOGGED_IN, isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to cache logged in status: $e');
    }
  }

  @override
  Future<bool> getLoggedInStatus() {
    try {
      return Future.value(sharedPreferences.getBool(IS_LOGGED_IN) ?? false);
    } catch (e) {
      throw CacheException('Failed to get logged in status: $e');
    }
  }

  @override
  Future<void> clearAllAuthData() async {
    try {
      await clearAuthToken();
      await cacheLoggedInStatus(false);
    } catch (e) {
      throw CacheException('Failed to clear all auth data: $e');
    }
  }
}