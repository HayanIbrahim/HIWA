import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    
    // Auto-inject appid if not already provided
    if (!options.queryParameters.containsKey('appid') && apiKey.isNotEmpty) {
      options.queryParameters['appid'] = apiKey;
    }

    super.onRequest(options, handler);
  }
}
