// consistify_frontend/lib/data/datasources/auth_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:consistify/core/constants/api_constants.dart';
import 'package:consistify/core/errors/exceptions.dart';
import 'package:consistify/data/models/user_model.dart';

abstract class AuthRemoteDataSource {


  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String notificationTime,
  });
  Future<String> loginUser({required String email, required String password}); // Returns JWT token
  Future<UserModel> getUserProfile({required String token});
  Future<void> updateUserProfile({
    required String token,
    String? username,
    String? notificationTime,
    String? timezone,
    Map<String, String>? platformUsernames,
    String? fcmToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String notificationTime,
  }) async {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier; 

    final response = await client.post(
      Uri.parse('$baseUrl${ApiConstants.registerEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'username': username,
        'notificationTime': notificationTime,
        'timezone': currentTimeZone, 
      }),
    );

    if (response.statusCode == 201) {
      return; 
    } else if (response.statusCode == 409) {
      throw EmailAlreadyExistsException(json.decode(response.body)['message'] ?? 'Email already exists.');
    } else if (response.statusCode == 400) {
      throw InvalidInputException(json.decode(response.body)['message'] ?? 'Invalid input.');
    } else {
      throw ServerException(json.decode(response.body)['message'] ?? 'Failed to register user.');
    }
  }

  @override
  Future<String> loginUser({required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('$baseUrl${ApiConstants.loginEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['token']; 
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException(json.decode(response.body)['message'] ?? 'Invalid email or password.');
    } else {
      throw ServerException(json.decode(response.body)['message'] ?? 'Failed to login.');
    }
  }

  @override
  Future<UserModel> getUserProfile({required String token}) async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiConstants.profileEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw const InvalidCredentialsException('Unauthorized. Please login again.');
    } else if (response.statusCode == 404) {
      throw const UserNotFoundException('User profile not found.');
    } else {
      throw ServerException('Failed to fetch user profile: ${response.body}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String token,
    String? username,
    String? notificationTime,
    String? timezone, 
    Map<String, String>? platformUsernames,
    String? fcmToken,
  }) async {
    final Map<String, dynamic> body = {};
    if (username != null) body['username'] = username;
    if (notificationTime != null) body['notificationTime'] = notificationTime;
    if (timezone != null) body['timezone'] = timezone; 
    if (platformUsernames != null) body['platformUsernames'] = platformUsernames;

   
    if (fcmToken != null) {
      body['fcmToken'] = fcmToken;
    }


    final response = await client.patch( 
      Uri.parse('$baseUrl${ApiConstants.updateProfileEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return; 
    } else if (response.statusCode == 401) {
      throw const InvalidCredentialsException('Unauthorized. Please login again.');
    } else if (response.statusCode == 404) {
      throw const UserNotFoundException('User profile not found.');
    } else if (response.statusCode == 400) {
      throw InvalidInputException(json.decode(response.body)['message'] ?? 'Invalid input for profile update.');
    } else {
      throw ServerException('Failed to update user profile: ${response.body}');
    }
  }
}