import 'dart:io';

class NetworkErrorHandler {
  static void register(Map<Type, String Function(dynamic)> handlers) {
    handlers[SocketException] = _handleSocketException;
    handlers[HttpException] = _handleHttpException;
  }

  static String _handleSocketException(dynamic error) {
    return 'No internet connection. Please check your network';
  }

  static String _handleHttpException(dynamic error) {
    if (error is! HttpException) return 'Network error';
    return 'Server error: ${error.message}';
  }
}
