import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/data.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> isTokenExpired(String token) async {
  return JwtDecoder.isExpired(token);
}

Future<void> refreshToken() async {
  final storage = FlutterSecureStorage();
  final refreshToken = await storage.read(key: 'refresh_token');

  if (refreshToken != null) {
    final uri = Uri.parse('$url/api/Authorization/RefreshToken');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'refreshToken': refreshToken});

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('token') &&
            responseData.containsKey('refreshToken')) {
          final newAccessToken = responseData['token'];
          final newRefreshToken = responseData['refreshToken'];

          await storage.write(key: 'access_token', value: newAccessToken);
          await storage.write(key: 'refresh_token', value: newRefreshToken);
        } else {
          throw Exception('Failed to refresh token: Invalid response');
        }
      } else {
        throw Exception('Failed to refresh token: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error refreshing token: $e');
      throw e;
    }
  } else {
    throw Exception('No refresh token available');
  }
}
