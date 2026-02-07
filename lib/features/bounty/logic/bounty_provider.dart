import 'package:bro_leveling/features/proposals/logic/proposal_provider.dart';
import 'package:bro_leveling/features/proposals/data/proposal_model.dart';
import 'dart:math' as math;
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Bounty model representing a single bounty's progress
class BountyProgress {
  final String
  id; // Unique ID for this bounty instance (e.g. 'vote_2_2024-02-07')
  final int progress;
  final int target;
  final int reward;
  final int xp;
  final bool complete;
  final bool claimed;

  BountyProgress({
    required this.id,
    required this.progress,
    required this.target,
    required this.reward,
    required this.xp,
    required this.complete,
    required this.claimed,
  });

  double get progressPercent => (progress / target).clamp(0.0, 1.0);
  bool get canClaim => complete && !claimed;
}

/// State for the bounty system
class BountyStatus {
  final Map<String, BountyProgress> dailyBounties;
  final Map<String, BountyProgress> weeklyBounties;
  final int level;
  final int currentXp;
  final int nextLevelXp;

  BountyStatus({
    required this.dailyBounties,
    required this.weeklyBounties,
    required this.level,
    required this.currentXp,
    required this.nextLevelXp,
  });

  int get completedCount => [
    ...dailyBounties.values,
    ...weeklyBounties.values,
  ].where((b) => b.complete).length;

  int get readyToClaimCount => [
    ...dailyBounties.values,
    ...weeklyBounties.values,
  ].where((b) => b.canClaim).length;
}

/// Provider for list of claimed bounty IDs
final _claimedBountiesProvider = StreamProvider.autoDispose<List<String>>((
  ref,
) {
  final user = ref.watch(userProvider).asData?.value;
  if (user == null) return Stream.value([]);

  return Supabase.instance.client
      .from('claimed_bounties')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .map((data) => data.map((row) => row['bounty_id'] as String).toList());
});

/// Client-side computed bounty provider with Mastery integration
final bountyProgressProvider = Provider.autoDispose<BountyStatus>((ref) {
  final userAsync = ref.watch(userProvider);
  final proposalsAsync = ref.watch(proposalsProvider);
  final claimedIds = ref.watch(_claimedBountiesProvider).asData?.value ?? [];

  if (!userAsync.hasValue || !proposalsAsync.hasValue) {
    return BountyStatus(
      dailyBounties: {},
      weeklyBounties: {},
      level: 1,
      currentXp: 0,
      nextLevelXp: 100,
    );
  }

  final user = userAsync.value!;
  final proposals = proposalsAsync.value ?? <ProposalModel>[];

  final now = DateTime.now();
  final todayStr = DateFormat('yyyy-MM-dd').format(now);
  final weekStr = 'W${DateFormat('w').format(now)}';
  final todayStart = DateTime(now.year, now.month, now.day);
  final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));

  // XP Progress Calculation
  // Calculate next level XP using the same exponential formula as the database
  // Formula: current_level * 100 * (1.10 ^ (current_level - 1))
  final nextLevelXp =
      (user.bountyLevel * 100 * math.pow(1.10, user.bountyLevel - 1)).toInt();

  // Helper to check if a specific bounty is claimed
  bool isClaimed(String key, String period) =>
      claimedIds.contains('${key}_$period');

  // Daily Stats
  final votesToday = proposals
      .where(
        (p) =>
            p.supportVoterIds.contains(user.id) ||
            p.rejectVoterIds.contains(user.id),
      )
      .where((p) => p.createdAt.isAfter(todayStart))
      .length;

  final claimedToday =
      user.lastDailyClaim != null &&
      user.lastDailyClaim!.isAfter(
        todayStart.subtract(const Duration(days: 1)),
      );

  // Weekly Stats
  final votesWeek = proposals
      .where(
        (p) =>
            p.supportVoterIds.contains(user.id) ||
            p.rejectVoterIds.contains(user.id),
      )
      .where((p) => p.createdAt.isAfter(weekStart))
      .length;

  final createdWeek = proposals
      .where((p) => p.proposerId == user.id && p.createdAt.isAfter(weekStart))
      .length;

  final approvedWeek = proposals
      .where(
        (p) =>
            p.proposerId == user.id &&
            p.status == 'approved' &&
            p.createdAt.isAfter(weekStart),
      )
      .length;

  final survivedWeek = proposals
      .where(
        (p) =>
            p.targetUserId == user.id &&
            p.type == 'penalty' &&
            (p.status == 'rejected' || p.shielded) &&
            p.createdAt.isAfter(weekStart),
      )
      .length;

  final shieldUsedThisWeek =
      user.lastShieldUsed != null && user.lastShieldUsed!.isAfter(weekStart);

  // Quick Responder: Voted on an active proposal within 60 mins of its creation
  final votedQuicklyToday = proposals.any(
    (p) =>
        (p.supportVoterIds.contains(user.id) ||
            p.rejectVoterIds.contains(user.id)) &&
        p.createdAt.isAfter(now.subtract(const Duration(minutes: 60))) &&
        p.createdAt.isAfter(todayStart),
  );

  return BountyStatus(
    level: user.bountyLevel,
    currentXp: user.bountyXp,
    nextLevelXp: nextLevelXp,
    dailyBounties: {
      'vote_2': BountyProgress(
        id: 'vote_2_$todayStr',
        progress: votesToday,
        target: 2,
        reward: 5,
        xp: 20,
        complete: votesToday >= 2,
        claimed: isClaimed('vote_2', todayStr),
      ),
      'quick_responder': BountyProgress(
        id: 'quick_$todayStr',
        progress: votedQuicklyToday ? 1 : 0,
        target: 1,
        reward: 8,
        xp: 30,
        complete: votedQuicklyToday,
        claimed: isClaimed('quick', todayStr),
      ),
      'maintain_streak': BountyProgress(
        id: 'streak_$todayStr',
        progress: claimedToday && user.streak >= 2 ? 1 : 0,
        target: 1,
        reward: 5, // Increased to 5
        xp: 20, // Increased to 20
        complete: claimedToday && user.streak >= 2,
        claimed: isClaimed('streak', todayStr),
      ),
    },
    weeklyBounties: {
      'vote_5': BountyProgress(
        id: 'vote_5_$weekStr',
        progress: votesWeek,
        target: 5,
        reward: 20,
        xp: 50,
        complete: votesWeek >= 5,
        claimed: isClaimed('vote_5', weekStr),
      ),
      'guardian_angel': BountyProgress(
        id: 'guardian_$weekStr',
        progress: shieldUsedThisWeek ? 1 : 0,
        target: 1,
        reward: 30,
        xp: 75,
        complete: shieldUsedThisWeek,
        claimed: isClaimed('guardian', weekStr),
      ),
      'create_proposal': BountyProgress(
        id: 'create_$weekStr',
        progress: createdWeek,
        target: 1,
        reward: 15,
        xp: 35,
        complete: createdWeek >= 1,
        claimed: isClaimed('create', weekStr),
      ),
      'proposal_approved': BountyProgress(
        id: 'approved_$weekStr',
        progress: approvedWeek,
        target: 1,
        reward: 35,
        xp: 75,
        complete: approvedWeek >= 1,
        claimed: isClaimed('approved', weekStr),
      ),
      'survive_penalty': BountyProgress(
        id: 'survive_$weekStr',
        progress: survivedWeek,
        target: 1,
        reward: 40,
        xp: 100,
        complete: survivedWeek >= 1,
        claimed: isClaimed('survive', weekStr),
      ),
    },
  );
});

/// Bounty Logic Handler
final bountyLogicProvider = Provider((ref) => BountyLogic(ref));

class BountyLogic {
  final Ref _ref;
  BountyLogic(this._ref);

  Future<void> claim(BountyProgress bounty) async {
    final client = Supabase.instance.client;
    await client.rpc(
      'claim_bounty',
      params: {
        'p_bounty_id': bounty.id,
        'p_reward_amount': bounty.reward,
        'p_xp_amount': bounty.xp,
      },
    );
    // User provider will automatically refresh if it's watching correctly,
    // but explicit refresh is safer.
    _ref.invalidate(userProvider);
  }
}

/// Bounty display names and descriptions
const bountyDisplayInfo = {
  'vote_2': (
    name: 'Active Voter',
    description: 'Vote on 2+ proposals today',
    emoji: '🗳️',
  ),
  'quick_responder': (
    name: 'Quick Responder',
    description: 'Vote within 60m of a proposal',
    emoji: '⚡',
  ),
  'maintain_streak': (
    name: 'Consistent',
    description: 'Claim daily with 2+ streak',
    emoji: '📅',
  ),
  'vote_5': (
    name: 'Democracy Champion',
    description: 'Vote on 5+ proposals this week',
    emoji: '🏛️',
  ),
  'guardian_angel': (
    name: 'Guardian Angel',
    description: 'Use your Shield this week',
    emoji: '🛡️',
  ),
  'create_proposal': (
    name: 'Initiator',
    description: 'Create a proposal this week',
    emoji: '📝',
  ),
  'proposal_approved': (
    name: 'Persuader',
    description: 'Get a proposal approved',
    emoji: '✅',
  ),
  'survive_penalty': (
    name: 'Survivor',
    description: 'Survive a penalty proposal',
    emoji: '💀',
  ),
};
