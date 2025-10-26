// consistify_frontend/lib/data/datasources/consistency_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consistify/core/constants/api_constants.dart';
import 'package:consistify/core/errors/exceptions.dart';
import 'package:consistify/data/models/consistency_model.dart';
import 'package:intl/intl.dart';

abstract class ConsistencyRemoteDataSource {
  Future<DailyConsistencyModel> getDailyConsistency({required String token});
  Future<List<DailyConsistencyModel>> getConsistencyHistory({required String token, required DateTime startDate, required DateTime endDate});
  Future<StreakInfoModel> getStreaks({required String token});
}

class ConsistencyRemoteDataSourceImpl implements ConsistencyRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ConsistencyRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<DailyConsistencyModel> getDailyConsistency({required String token}) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl${ApiConstants.consistencyCheckEndpoint}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      
      final Map<String, dynamic> map = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
      final data = map.containsKey('consistency') ? map['consistency'] : map;
      return DailyConsistencyModel.fromJson(data as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      throw const InvalidCredentialsException('Unauthorized. Please login again.');
    } else {
      throw ServerException('Failed to fetch daily consistency: ${response.body}');
    }
  }

  @override
  Future<List<DailyConsistencyModel>> getConsistencyHistory({required String token, required DateTime startDate, required DateTime endDate}) async {
    final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    final uri = Uri.parse('$baseUrl${ApiConstants.consistencyHistoryEndpoint}')
        .replace(queryParameters: {
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
    });

    final response = await client
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DailyConsistencyModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw const InvalidCredentialsException('Unauthorized. Please login again.');
    } else {
      throw ServerException('Failed to fetch consistency history: ${response.body}');
    }
  }

  @override
  Future<StreakInfoModel> getStreaks({required String token}) async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiConstants.consistencyStreaksEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StreakInfoModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw const InvalidCredentialsException('Unauthorized. Please login again.');
    } else {
      throw ServerException('Failed to fetch streaks: ${response.body}');
    }
  }
}