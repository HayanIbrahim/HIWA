import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';
import 'error_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    final baseUrl = dotenv.env['BASE_URL'] ?? ApiConstants.defaultBaseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      ApiInterceptor(),
      ErrorInterceptor(),
    ]);
  }
}
