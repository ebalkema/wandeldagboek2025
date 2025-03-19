import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../error/failures.dart';
import '../services/logging_service.dart';

class NetworkService {
  final http.Client _client;
  final LoggingService _logger;

  NetworkService({
    http.Client? client,
    LoggingService? logger,
  })  : _client = client ?? http.Client(),
        _logger = logger ?? LoggingService();

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
        headers: await _getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      _logger.error('Network GET request failed', e);
      throw NetworkFailure(message: 'Netwerkfout bij ophalen data');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic body) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      _logger.error('Network POST request failed', e);
      throw NetworkFailure(message: 'Netwerkfout bij versturen data');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic body) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      _logger.error('Network PUT request failed', e);
      throw NetworkFailure(message: 'Netwerkfout bij updaten data');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
        headers: await _getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      _logger.error('Network DELETE request failed', e);
      throw NetworkFailure(message: 'Netwerkfout bij verwijderen data');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    // TODO: Implementeer authenticatie headers
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      _logger.error('API Error: ${response.statusCode}', response.body);
      throw ServerFailure(
        message: 'Serverfout: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
  }
}
