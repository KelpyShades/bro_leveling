import 'package:flutter/material.dart';

/// Aura title ladder based on spec Section 4.
/// Computes title from aura value.
/// "Him" is a special override title (contested crown mechanic).
String getTitle(int aura, {bool isHim = false}) {
  if (isHim) return 'Him';
  if (aura < 100) return 'NPC';
  if (aura < 200) return 'Invisible';
  if (aura < 300) return 'Main Character';
  if (aura < 400) return 'Black Flash';
  if (aura < 500) return 'Shadow';
  if (aura < 600) return 'Aura Commander';
  if (aura < 700) return 'Unfazed';
  if (aura < 800) return 'Shadow Monarch';
  if (aura < 900) return 'The Original';
  if (aura < 1000) return 'Infinite Steez';
  if (aura < 1200) return 'The Honored One';
  if (aura < 1400) return 'Anomaly';
  if (aura < 1600) return 'The Beyonder';
  if (aura < 1800) return 'Menace';
  if (aura < 2100) return 'Eternal Shadow';
  if (aura < 2500) return 'The Inevitable';
  if (aura < 3000) return 'The One Above All';
  return 'Aura Sovereign';
}

/// Get color based on aura tier for visual distinction.
Color getAuraColor(int aura, {bool isBroken = false}) {
  if (isBroken || aura == 0) return const Color(0xFF424242); // Dark gray
  if (aura < 100) return const Color(0xFF757575); // Gray (NPC)
  if (aura < 500) return const Color(0xFF4CAF50); // Green
  if (aura < 1000) return const Color(0xFF2196F3); // Blue
  if (aura < 2000) return const Color(0xFF9C27B0); // Purple
  return const Color(0xFFFFD700); // Gold (Legend+)
}

/// Get a short status message based on aura state.
String getAuraStatus(int aura, bool isBroken) {
  if (isBroken) return 'AURALESS';
  if (aura == 0) return 'AURALESS';
  if (aura < 100) return 'STRUGGLING';
  if (aura < 500) return 'RISING';
  if (aura < 1000) return 'RESPECTED';
  if (aura < 2000) return 'FEARED';
  return 'LEGENDARY';
}
