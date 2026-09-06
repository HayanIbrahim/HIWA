import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Unexpected network error occurred.';
    final int? statusCode = err.response?.statusCode;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        final data = err.response?.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else {
          errorMessage = 'Server returned error ($statusCode).';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Cannot connect to server. Please verify your internet connection.';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = err.message ?? 'An unknown network error occurred.';
        break;
    }

    // Wrap in custom ServerException
    final customException = ServerException(
      message: errorMessage,
      statusCode: statusCode,
    );

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: customException,
        message: errorMessage,
      ),
    );
  }
}
