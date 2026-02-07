import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Prestige status model
class PrestigeStatus {
  final bool canAscend;
  final List<String> reasons;
  final int currentAura;
  final int currentStreak;
  final int penaltiesSurvived;
  final int ascensionCount;
  final List<String> availablePerks;
  final List<String> ownedPerks;

  PrestigeStatus({
    required this.canAscend,
    required this.reasons,
    required this.currentAura,
    required this.currentStreak,
    required this.penaltiesSurvived,
    required this.ascensionCount,
    required this.availablePerks,
    required this.ownedPerks,
  });

  factory PrestigeStatus.fromJson(Map<String, dynamic> json) {
    return PrestigeStatus(
      canAscend: json['can_ascend'] as bool? ?? false,
      reasons:
          (json['reasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      currentAura: json['current_aura'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      penaltiesSurvived: json['penalties_survived'] as int? ?? 0,
      ascensionCount: json['ascension_count'] as int? ?? 0,
      availablePerks:
          (json['available_perks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ownedPerks:
          (json['owned_perks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  bool get isMaxAscension => ascensionCount >= 3;
  String get title {
    if (ascensionCount >= 3) return 'ETERNAL';
    if (ascensionCount == 2) return 'ASCENDED III';
    if (ascensionCount == 1) return 'ASCENDED II';
    if (ascensionCount == 0 && canAscend) return 'READY TO ASCEND';
    return 'MORTAL';
  }
}

/// Perk display information
const perkInfo = {
  'resilience': (
    name: 'Resilience',
    description: 'Decay takes 2 days to start instead of 1',
    emoji: '🛡️',
  ),
  'momentum_boost': (
    name: 'Momentum Boost',
    description: 'Daily claim starts at +0.1x base multiplier',
    emoji: '🚀',
  ),
  'fortitude': (
    name: 'Fortitude',
    description: 'Proposals targeting you cost proposer 10 extra Aura',
    emoji: '💪',
  ),
  'influence': (
    name: 'Influence',
    description: 'Your votes count as 1.5 votes',
    emoji: '👑',
  ),
  'guardian': (
    name: 'Guardian',
    description: 'Shield cooldown is 5 days instead of 7',
    emoji: '⚔️',
  ),
  'prosperity': (
    name: 'Prosperity',
    description: '+5% bonus on all Aura gains',
    emoji: '💰',
  ),
};

/// Provider to check prestige status
final prestigeStatusProvider = FutureProvider.autoDispose<PrestigeStatus>((
  ref,
) async {
  final client = Supabase.instance.client;
  final response = await client.rpc('can_ascend');
  return PrestigeStatus.fromJson(response as Map<String, dynamic>);
});

/// Provider to perform ascension
class PrestigeLogic {
  final SupabaseClient _client;

  PrestigeLogic(this._client);

  Future<Map<String, dynamic>> ascend(String chosenPerk) async {
    final response = await _client.rpc(
      'ascend',
      params: {'p_chosen_perk': chosenPerk},
    );
    return response as Map<String, dynamic>;
  }
}

final prestigeLogicProvider = Provider<PrestigeLogic>((ref) {
  return PrestigeLogic(Supabase.instance.client);
});
