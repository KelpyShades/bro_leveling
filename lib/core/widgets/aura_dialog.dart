import 'dart:async';
import 'package:bro_leveling/core/widgets/aura_button.dart';
import 'package:flutter/material.dart';

enum AuraDialogType { confirm, destructive }

/// Shows a simple confirm or destructive dialog.
Future<bool?> showAuraDialog({
  required BuildContext context,
  required String title,
  required String message,
  AuraDialogType type = AuraDialogType.confirm,
  String? confirmText,
  String? cancelText,
  FutureOr<void> Function()? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) => _AuraDialog(
      title: title,
      message: message,
      type: type,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
    ),
  );
}

class _AuraDialog extends StatelessWidget {
  const _AuraDialog({
    required this.title,
    required this.message,
    required this.type,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
  });

  final String title;
  final String message;
  final AuraDialogType type;
  final String? confirmText;
  final String? cancelText;
  final FutureOr<void> Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AuraButton(
                  label: cancelText ?? 'Cancel',
                  palette: AuraButtonPalette.secondary,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(width: 12),
                AuraButton(
                  label:
                      confirmText ??
                      (type == AuraDialogType.destructive
                          ? 'Delete'
                          : 'Confirm'),
                  palette: type == AuraDialogType.destructive
                      ? AuraButtonPalette.danger
                      : AuraButtonPalette.gold,
                  onPressed: () async {
                    if (onConfirm != null) await onConfirm!();
                    if (context.mounted) Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
