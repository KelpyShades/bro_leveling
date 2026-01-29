import 'package:another_flushbar/flushbar.dart';
import 'package:bro_leveling/core/constants/theme.dart';
import 'package:flutter/cupertino.dart';

enum SnackType { warning, success, info, error }

class FlushbarManager {
  static final FlushbarManager _instance = FlushbarManager._internal();
  factory FlushbarManager() => _instance;
  FlushbarManager._internal();

  Flushbar? _currentFlushbar;

  void showFlushbar(
    String content, {
    SnackType type = SnackType.info,
    int duration = 4,
    bool isDismissible = true,
    BuildContext? context,
  }) {
    if (context == null) return;
    _currentFlushbar?.dismiss();

    _currentFlushbar = Flushbar(
      messageText: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      margin: const EdgeInsets.all(7),
      borderRadius: BorderRadius.circular(25),
      backgroundColor: AppColors.surface,
      icon: Icon(
        type == SnackType.success
            ? CupertinoIcons.check_mark_circled
            : type == SnackType.warning
            ? CupertinoIcons.exclamationmark_circle
            : type == SnackType.info
            ? CupertinoIcons.info_circle
            : CupertinoIcons.xmark_circle,
        color: type == SnackType.success
            ? AppColors.success
            : type == SnackType.warning
            ? AppColors.warning
            : type == SnackType.info
            ? AppColors.gold
            : AppColors.error,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: duration),
      isDismissible: isDismissible,
      onStatusChanged: (FlushbarStatus? status) {
        if (status == FlushbarStatus.DISMISSED) {
          _currentFlushbar = null;
        }
      },
    );
    _currentFlushbar!.show(context);
  }

  void dismissCurrent() {
    _currentFlushbar?.dismiss();
    _currentFlushbar = null;
  }
}

/// Shows a themed aura snackbar message using Flushbar.
void showAuraSnackbar(
  BuildContext context,
  String message, {
  SnackType type = SnackType.info,
  int duration = 4,
  bool isDismissible = true,
}) {
  FlushbarManager().showFlushbar(
    message,
    type: type,
    duration: duration,
    isDismissible: isDismissible,
    context: context,
  );
}
