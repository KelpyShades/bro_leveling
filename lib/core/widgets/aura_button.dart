import 'dart:async';
import 'package:flutter/material.dart';

enum AuraButtonPalette { gold, secondary, danger }

/// A simplified, reusable button for Bro Leveling.
class AuraButton extends StatefulWidget {
  const AuraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.palette = AuraButtonPalette.gold,
    this.isOutline = false,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  final String label;
  final FutureOr<void> Function() onPressed;
  final AuraButtonPalette palette;
  final bool isOutline;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  @override
  State<AuraButton> createState() => _AuraButtonState();
}

class _AuraButtonState extends State<AuraButton> {
  bool _isLoading = false;

  Color _backgroundColor() {
    switch (widget.palette) {
      case AuraButtonPalette.gold:
        return const Color(0xFFFFD700);
      case AuraButtonPalette.secondary:
        return Colors.white10;
      case AuraButtonPalette.danger:
        return Colors.red.shade700;
    }
  }

  Color _foregroundColor() {
    switch (widget.palette) {
      case AuraButtonPalette.gold:
        return Colors.black;
      case AuraButtonPalette.secondary:
        return Colors.white;
      case AuraButtonPalette.danger:
        return Colors.white;
    }
  }

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = widget.isLoading || _isLoading;

    if (widget.isOutline) {
      return OutlinedButton(
        onPressed: loading ? null : _handlePress,
        style: OutlinedButton.styleFrom(
          fixedSize: widget.width != null ? Size(widget.width!, 48) : null,
          side: BorderSide(color: _backgroundColor(), width: 2),
          foregroundColor: _backgroundColor(),
        ),
        child: loading ? _loadingIndicator() : _buttonContent(),
      );
    }

    return ElevatedButton(
      onPressed: loading ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        fixedSize: widget.width != null ? Size(widget.width!, 48) : null,
        backgroundColor: _backgroundColor(),
        foregroundColor: _foregroundColor(),
      ),
      child: loading ? _loadingIndicator() : _buttonContent(),
    );
  }

  Widget _buttonContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
    return Text(
      widget.label,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _loadingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: widget.isOutline ? _backgroundColor() : _foregroundColor(),
      ),
    );
  }
}
