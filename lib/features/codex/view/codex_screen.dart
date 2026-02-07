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

class CodexScreen extends StatefulWidget {
  const CodexScreen({super.key});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  String? _expandedCategoryId;

  void _toggleCategory(String id) {
    setState(() {
      _expandedCategoryId = _expandedCategoryId == id ? null : id;
    });
  }

  static const List<AuraTier> _tiers = [
    AuraTier(
      title: 'NPC',
      auraRange: '0–99',
      minAura: 0,
      lore:
          'You exist in the world, but the world does not respond to you. No pull. No push. No narrative gravity.',
      color: Color(0xFF757575),
    ),
    AuraTier(
      title: 'Invisible',
      auraRange: '100–199',
      minAura: 100,
      lore:
          'You are present, but unnoticed. A background texture in the tapestry of others\' lives.',
      color: Color(0xFF4CAF50),
    ),
    AuraTier(
      title: 'Main Character',
      auraRange: '200–299',
      minAura: 200,
      lore:
          'The story acknowledges you. You are no longer background noise — events now orbit you.',
      color: Color(0xFF4CAF50),
    ),
    AuraTier(
      title: 'Black Flash',
      auraRange: '300–399',
      minAura: 300,
      lore:
          'A distortion in the norm. You move different. People notice a spark that threatens to ignite.',
      color: Color(0xFF4CAF50),
      hasGlow: true,
    ),
    AuraTier(
      title: 'Shadow',
      auraRange: '400–499',
      minAura: 400,
      lore:
          'You stick to the periphery, yet your influence is felt. A silhouette that commands respect.',
      color: Color(0xFF4CAF50),
    ),
    AuraTier(
      title: 'Aura Commander',
      auraRange: '500–599',
      minAura: 500,
      lore:
          'You don\'t just have aura; you wield it. Rooms shift when you enter. The atmosphere obeys your mood.',
      color: Color(0xFF2196F3),
    ),
    AuraTier(
      title: 'Unfazed',
      auraRange: '600–699',
      minAura: 600,
      lore:
          'Chaos moves around you, never through you. A pillar of stoic dominance in a shifting world.',
      color: Color(0xFF2196F3),
    ),
    AuraTier(
      title: 'Shadow Monarch',
      auraRange: '700–799',
      minAura: 700,
      lore:
          'You rule the quiet spaces. Your silence speaks louder than their screams. A king of the unseen.',
      color: Color(0xFF2196F3),
    ),
    AuraTier(
      title: 'The Original',
      auraRange: '800–899',
      minAura: 800,
      lore:
          'No derived sway. No imitation. Your presence is purely, terrifyingly unique.',
      color: Color(0xFF2196F3),
    ),
    AuraTier(
      title: 'Infinite Steez',
      auraRange: '900–999',
      minAura: 900,
      lore:
          'Effortless style. Endless rhythm. You flow through life while others struggle to swim.',
      color: Color(0xFF2196F3),
    ),
    AuraTier(
      title: 'The Honored One',
      auraRange: '1000–1199',
      minAura: 1000,
      lore:
          'Throughout heaven and earth, you alone are the honored one. A singularity of pure respect.',
      color: Color(0xFF9C27B0),
      hasGlow: true,
    ),
    AuraTier(
      title: 'Anomaly',
      auraRange: '1200–1399',
      minAura: 1200,
      lore:
          'Logic fails to explain you. Data cannot predict you. You are a glitch in the social matrix.',
      color: Color(0xFF9C27B0),
    ),
    AuraTier(
      title: 'The Beyonder',
      auraRange: '1400–1599',
      minAura: 1400,
      lore:
          'You exist outside the standard hierarchy. You play a game only you understand.',
      color: Color(0xFF9C27B0),
    ),
    AuraTier(
      title: 'Menace',
      auraRange: '1600–1799',
      minAura: 1600,
      lore: 'Dangerous. Unpredictable. Your aura has teeth, and it smiles.',
      color: Color(0xFF9C27B0),
    ),
    AuraTier(
      title: 'Eternal Shadow',
      auraRange: '1800–2099',
      minAura: 1800,
      lore:
          'Light fades, but shadow remains. Your influence is permanent, etched into the foundation of reality.',
      color: Color(0xFF9C27B0),
    ),
    AuraTier(
      title: 'The Inevitable',
      auraRange: '2100–2499',
      minAura: 2100,
      lore: 'Change is optional. You are not. Destiny arrives all the same.',
      color: Color(0xFFFFD700),
      hasGlow: true,
    ),
    AuraTier(
      title: 'The One Above All',
      auraRange: '2500–2999',
      minAura: 2500,
      lore: 'A god amongst mortals. You do not compete; you preside.',
      color: Color(0xFFFFD700),
      hasGlow: true,
    ),
    AuraTier(
      title: 'Aura Sovereign',
      auraRange: '3000+',
      minAura: 3000,
      lore:
          'The apex state. Your presence defines the system itself. There is nothing left to prove.',
      color: Color(0xFFFFD700),
      hasGlow: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('AURA CODEX'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        children: [
          _buildCategory(
            id: 'hierarchy',
            title: 'HIERARCHY OF POWER',
            subtitle: 'The 18 Tiers of Social Standing',
            emoji: '👑',
            color: AppColors.gold,
            content: Column(
              children: _tiers.map((tier) => _buildTierItem(tier)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildCategory(
            id: 'prestige',
            title: 'LEGACY & ASCENSION',
            subtitle: 'Breaking the Limits',
            emoji: '✨',
            color: AppColors.gold,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: 'The Path of the Transcendent',
                  body:
                      'Ascending resets your Aura and Streak to gain a Permanent Perk. Level 500+ required.',
                  points: [
                    'Sacrifice 500+ Aura to reset to 100',
                    'Gain 1 Permanent Perk Point',
                    'Unlock 24h Indestructible Mode',
                  ],
                  color: AppColors.gold,
                ),
                const SizedBox(height: 16),
                _buildPerkGrid(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCategory(
            id: 'mastery',
            title: 'BOUNTY MASTERY',
            subtitle: 'Skill & Activity Progress',
            emoji: '🎯',
            color: AppColors.info,
            content: _buildInfoCard(
              title: 'Permanent Progression',
              body:
                  'Mastery Level (XP) never resets. High levels represent elite standing.',
              points: [
                'Complete and Claim bounties to gain XP',
                'Each level requires 10% more XP than last',
                'UNLOCKS: Rank badges on Leaderboard',
                'UNLOCKS: Bonus Aura multiplier on claims (Lvl 10+)',
                'UNLOCKS: Elite Bounty missions (Lvl 20+)',
              ],
              color: AppColors.info,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategory(
            id: 'special',
            title: 'SPECIAL STATES',
            subtitle: 'God-tier Roles & Survival',
            emoji: '💎',
            color: AppColors.success,
            content: Column(
              children: [
                _buildHeroCard(
                  title: '"Him"',
                  body: 'The absolute apex of the hierarchy. Only one exists.',
                  requirements: '5 Boosts in one week, no penalties.',
                  emoji: '👑',
                  color: AppColors.gold,
                ),
                const SizedBox(height: 16),
                _buildHeroCard(
                  title: 'Indestructible Virgin',
                  body: 'Total immunity for 12h after your daily claim.',
                  requirements: '3 days of zero penalties.',
                  emoji: '🛡️',
                  color: AppColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCategory(
            id: 'warnings',
            title: 'SYSTEM WARNINGS',
            subtitle: 'Rank Decay & Penalties',
            emoji: '⚠️',
            color: AppColors.error,
            content: _buildInfoCard(
              title: 'Accountability is Key',
              body:
                  'Inactivity leads to Rank Decay. Don\'t let your presence fade.',
              points: [
                'Normal: Decay starts after 24h of inactivity',
                'Resilience: Decay starts after 48h',
                'Break Streak: Momentum penalty occurs',
              ],
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory({
    required String id,
    required String title,
    required String subtitle,
    required String emoji,
    required Color color,
    required Widget content,
  }) {
    final isExpanded = _expandedCategoryId == id;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded ? color.withAlpha(80) : AppColors.surfaceLight,
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleCategory(id),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.surfaceLight),
            Padding(padding: const EdgeInsets.all(20), child: content),
          ],
        ],
      ),
    );
  }

  Widget _buildTierItem(AuraTier tier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: tier.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tier.color.withAlpha(100),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: tier.hasGlow
                            ? [
                                Shadow(
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
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  tier.lore,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String body,
    required List<String> points,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: color, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard({
    required String title,
    required String body,
    required String requirements,
    required String emoji,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(50),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'REQUIREMENTS',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            requirements,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPerkGrid() {
    final perks = [
      (
        name: 'Influence',
        desc: 'Votes gain 1.5x weight.',
        icon: Icons.record_voice_over,
      ),
      (
        name: 'Fortitude',
        desc: 'Targeting you costs +10 Aura.',
        icon: Icons.gpp_maybe,
      ),
      (
        name: 'Guardian',
        desc: 'Shield cooldown reduced to 5d.',
        icon: Icons.security,
      ),
      (
        name: 'Resilience',
        desc: 'Decay starts after 48h.',
        icon: Icons.hourglass_empty,
      ),
      (
        name: 'Prosperity',
        desc: '10% bonus + 2 Min Floor.',
        icon: Icons.trending_up,
      ),
      (name: 'Momentum', desc: 'Daily starts at 1.1x.', icon: Icons.speed),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: perks
          .map(
            (p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(p.icon, color: AppColors.gold, size: 18),
                  const SizedBox(height: 6),
                  Text(
                    p.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      p.desc,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
