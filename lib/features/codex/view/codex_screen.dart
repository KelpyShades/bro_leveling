import 'package:bro_leveling/core/constants/theme.dart';
import 'package:flutter/material.dart';

/// Data class for an aura title tier.
class AuraTier {
  final String title;
  final String auraRange;
  final int minAura;
  final String lore;
  final Color color;
  final bool hasGlow;

  const AuraTier({
    required this.title,
    required this.auraRange,
    required this.minAura,
    required this.lore,
    required this.color,
    this.hasGlow = false,
  });
}

class CodexScreen extends StatelessWidget {
  const CodexScreen({super.key});

  static const List<AuraTier> _tiers = [
    AuraTier(
      title: 'NPC',
      auraRange: '0–99',
      minAura: 0,
      lore:
          'You exist in the world, but the world does not respond to you. No pull. No push. No narrative gravity.',
      color: Color(0xFF757575), // Gray (NPC)
    ),
    AuraTier(
      title: 'Invisible',
      auraRange: '100–199',
      minAura: 100,
      lore:
          'You are present, but unnoticed. A background texture in the tapestry of others\' lives.',
      color: Color(0xFF4CAF50), // Green
    ),
    AuraTier(
      title: 'Main Character',
      auraRange: '200–299',
      minAura: 200,
      lore:
          'The story acknowledges you. You are no longer background noise — events now orbit you. Responsibility begins here.',
      color: Color(0xFF4CAF50), // Green
    ),
    AuraTier(
      title: 'Black Flash',
      auraRange: '300–399',
      minAura: 300,
      lore:
          'A distortion in the norm. You move different. People notice a spark that threatens to ignite.',
      color: Color(0xFF4CAF50), // Green
      hasGlow: true,
    ),
    AuraTier(
      title: 'Shadow',
      auraRange: '400–499',
      minAura: 400,
      lore:
          'You stick to the periphery, yet your influence is felt. A silhouette that commands respect without speaking.',
      color: Color(0xFF4CAF50), // Green
    ),
    AuraTier(
      title: 'Aura Commander',
      auraRange: '500–599',
      minAura: 500,
      lore:
          'You don\'t just have aura; you wield it. Rooms shift when you enter. The atmosphere obeys your mood.',
      color: Color(0xFF2196F3), // Blue
    ),
    AuraTier(
      title: 'Unfazed',
      auraRange: '600–699',
      minAura: 600,
      lore:
          'Chaos moves around you, never through you. A pillar of stoic dominance in a shifting world.',
      color: Color(0xFF2196F3), // Blue
    ),
    AuraTier(
      title: 'Shadow Monarch',
      auraRange: '700–799',
      minAura: 700,
      lore:
          'You rule the quiet spaces. Your silence speaks louder than their screams. A king of the unseen.',
      color: Color(0xFF2196F3), // Blue
    ),
    AuraTier(
      title: 'The Original',
      auraRange: '800–899',
      minAura: 800,
      lore:
          'No derived sway. No imitation. Your presence is purely, terrifyingly unique.',
      color: Color(0xFF2196F3), // Blue
    ),
    AuraTier(
      title: 'Infinite Steez',
      auraRange: '900–999',
      minAura: 900,
      lore:
          'Effortless style. Endless rhythm. You flow through life while others struggle to swim.',
      color: Color(0xFF2196F3), // Blue
    ),
    AuraTier(
      title: 'The Honored One',
      auraRange: '1000–1199',
      minAura: 1000,
      lore:
          'Throughout heaven and earth, you alone are the honored one. A singularity of pure respect.',
      color: Color(0xFF9C27B0), // Purple
      hasGlow: true,
    ),
    AuraTier(
      title: 'Anomaly',
      auraRange: '1200–1399',
      minAura: 1200,
      lore:
          'Logic fails to explain you. Data cannot predict you. You are a glitch in the social matrix.',
      color: Color(0xFF9C27B0), // Purple
    ),
    AuraTier(
      title: 'The Beyonder',
      auraRange: '1400–1599',
      minAura: 1400,
      lore:
          'You exist outside the standard hierarchy. You play a game only you understand.',
      color: Color(0xFF9C27B0), // Purple
    ),
    AuraTier(
      title: 'Menace',
      auraRange: '1600–1799',
      minAura: 1600,
      lore: 'Dangerous. Unpredictable. Your aura has teeth, and it smiles.',
      color: Color(0xFF9C27B0), // Purple
    ),
    AuraTier(
      title: 'Eternal Shadow',
      auraRange: '1800–2099',
      minAura: 1800,
      lore:
          'Light fades, but shadow remains. Your influence is permanent, etched into the foundation of reality.',
      color: Color(0xFF9C27B0), // Purple
    ),
    AuraTier(
      title: 'The Inevitable',
      auraRange: '2100–2499',
      minAura: 2100,
      lore: 'Change is optional. You are not. Destiny arrives all the same.',
      color: Color(0xFFFFD700), // Gold
      hasGlow: true,
    ),
    AuraTier(
      title: 'The One Above All',
      auraRange: '2500–2999',
      minAura: 2500,
      lore: 'A god amongst mortals. You do not compete; you preside.',
      color: Color(0xFFFFD700), // Gold
      hasGlow: true,
    ),
    AuraTier(
      title: 'Aura Sovereign',
      auraRange: '3000+',
      minAura: 3000,
      lore:
          'The apex state. Your presence defines the system itself. There is nothing left to prove.',
      color: Color(0xFFFFD700), // Gold
      hasGlow: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('AURA CODEX'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THE HIERARCHY OF POWER',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Tier List
            ..._tiers.map((tier) => _buildTier(tier)),

            const Divider(color: AppColors.surfaceLight, height: 48),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withAlpha(50)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(20),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('👑', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text(
                        'THE CONTESTED CROWN',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'TITLE: "Him"',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'There can only be one. The absolute apex of the aura hierarchy. This title overrides all others.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'REQUIREMENTS:',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Receive 5 BOOSTS in one week\n• Boosts must come from at least 2 different people\n• No successful PENALTIES in the same week',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Indestructible Virgin Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withAlpha(50)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withAlpha(20),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('🛡️', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 8),
                      Text(
                        'TEMPORARY STATUS',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'MODE: "Indestructible Virgin"',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Total immunity. For 12 hours after claiming your daily, NO penalties can be created against you.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'REQUIREMENTS:',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Receive NO penalties for 3 consecutive days\n• Activates automatically on Daily Claim',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Aura Decay Warning
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(10), // Subtle red tint
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withAlpha(50)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.error),
                      SizedBox(width: 8),
                      Text(
                        'SYSTEM WARNING',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rank Decay Active',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Inactivity is punished. If you do not claim your daily aura for over 26 hours, your aura will decay.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '• 26-50h Inactivity: -25 Aura\n• >50h Inactivity: -50 Aura / day',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTier(AuraTier tier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank Indicator
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: tier.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tier.color.withAlpha(100),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tier.title,
                      style: TextStyle(
                        color: tier.color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: tier.hasGlow
                            ? [
                                BoxShadow(
                                  color: tier.color.withAlpha(150),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    Text(
                      tier.auraRange,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  tier.lore,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
