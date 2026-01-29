/// Custom app-specific error for controlled error handling.
class AppError implements Exception {
  final String message;
  final String? code;

  AppError(this.message, {this.code});

  @override
  String toString() => message;
}

class AppErrorHandler {
  static void register(Map<Type, String Function(dynamic)> handlers) {
    handlers[AppError] = _handleAppError;
  }

  static String _handleAppError(dynamic error) {
    if (error is! AppError) return 'Application error';
    return error.message;
  }
}
