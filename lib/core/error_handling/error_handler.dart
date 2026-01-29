import 'dart:async';

import 'package:bro_leveling/core/error_handling/contexts/app_error.dart';
import 'package:bro_leveling/core/error_handling/contexts/auth_error_handler.dart';
import 'package:bro_leveling/core/error_handling/contexts/network_error_handler.dart';
import 'package:bro_leveling/core/error_handling/contexts/postgres_error_handler.dart';
import 'package:bro_leveling/core/error_handling/contexts/unknown_error_handler.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:flutter/widgets.dart';

extension AsyncErrorExtention<T> on Future<T> {
  Future<T?> handleAsyncError<F>({
    BuildContext? context,
    String? successMessage,
    String? errorMessage,
    F Function()? finallyOperation,
    String? debugTrace,
  }) async {
    return _asyncErrorWrapper<T, F>(
      () async => this,
      context: context,
      successMessage: successMessage,
      errorMessage: errorMessage,
      finallyOperation: finallyOperation,
      debugTrace: debugTrace,
    );
  }
}

Future<T?> _asyncErrorWrapper<T, F>(
  Future<T> Function() operation, {
  F Function()? finallyOperation,
  BuildContext? context,
  String? successMessage,
  String? errorMessage,
  String? debugTrace,
}) async {
  try {
    final result = await operation();

    if (successMessage != null && context != null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showAuraSnackbar(context, successMessage, type: SnackType.success);
      });
    }

    return result;
  } catch (e, stackTrace) {
    debugPrint('Error [$debugTrace]: $e\n$stackTrace');
    if (context != null && context.mounted) {
      ErrorTranslator.translate(
        e,
        errorMessage: errorMessage,
        context: context,
      );
      if (finallyOperation != null) {
        finallyOperation();
      }
      return null;
    } else {
      rethrow;
    }
  }
}

class ErrorTranslator {
  static final Map<Type, String Function(dynamic)> _errorHandlers = {};

  static void _initializeHandlers() {
    if (_errorHandlers.isNotEmpty) return;

    NetworkErrorHandler.register(_errorHandlers);
    AuthErrorHandler.register(_errorHandlers);
    PostgresErrorHandler.register(_errorHandlers);
    AppErrorHandler.register(_errorHandlers);
  }

  static void translate(
    dynamic error, {
    String? errorMessage,
    BuildContext? context,
    SnackType? type,
  }) {
    _initializeHandlers();

    String translation = '';
    final handler = _errorHandlers[error.runtimeType];

    if (handler == null) {
      translation = UnknownErrorHandler.handleError(error);
    } else {
      translation = handler(error);
    }

    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showAuraSnackbar(
          context,
          errorMessage ?? translation,
          type: type ?? SnackType.error,
        );
      });
    }
  }
}
