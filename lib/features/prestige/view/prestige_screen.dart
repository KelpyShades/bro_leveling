import 'package:bro_leveling/core/constants/theme.dart';
import 'package:bro_leveling/core/widgets/snackbar.dart';
import 'package:bro_leveling/features/dashboard/logic/user_provider.dart';
import 'package:bro_leveling/features/prestige/logic/prestige_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrestigeScreen extends ConsumerStatefulWidget {
  const PrestigeScreen({super.key});

  @override
  ConsumerState<PrestigeScreen> createState() => _PrestigeScreenState();
}

class _PrestigeScreenState extends ConsumerState<PrestigeScreen> {
  String? _selectedPerk;
  bool _isAscending = false;

  @override
  Widget build(BuildContext context) {
    final prestigeAsync = ref.watch(prestigeStatusProvider);
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('PRESTIGE'),
      ),
      body: prestigeAsync.when(
        data: (status) {
          final user = userAsync.asData?.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              children: [
                // Ascension status card
                _buildStatusCard(status, user?.ascensionCount ?? 0),
                const SizedBox(height: 24),

                // Requirements section
                _buildRequirementsSection(status),
                const SizedBox(height: 24),

                // Owned perks section (if any)
                if (status.ownedPerks.isNotEmpty) ...[
                  _buildOwnedPerksSection(status.ownedPerks),
                  const SizedBox(height: 24),
                ],

                // Perk selection (if can ascend)
                if (status.canAscend && !status.isMaxAscension) ...[
                  _buildPerkSelectionSection(status),
                  const SizedBox(height: 24),
                  _buildAscendButton(status),
                ],

                // Max ascension message
                if (status.isMaxAscension) _buildEternalCard(),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $err',
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(prestigeStatusProvider),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(PrestigeStatus status, int ascensionCount) {
    final stars = List.generate(3, (i) => i < ascensionCount);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            status.isMaxAscension
                ? const Color(0xFFFFD700).withAlpha(30)
                : AppColors.gold.withAlpha(20),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.isMaxAscension
              ? const Color(0xFFFFD700)
              : AppColors.gold.withAlpha(100),
          width: status.isMaxAscension ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Ascension stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stars
                .map(
                  (filled) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: filled ? AppColors.gold : AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            status.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: status.isMaxAscension
                  ? const Color(0xFFFFD700)
                  : AppColors.gold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Ascension ${status.ascensionCount}/3',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),

          if (status.canAscend && !status.isMaxAscension) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success),
              ),
              child: const Text(
                '✨ READY TO ASCEND',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementsSection(PrestigeStatus status) {
    final requirements = [
      (
        name: '500+ Aura',
        current: status.currentAura,
        target: 500,
        met: status.currentAura >= 500,
      ),
      (
        name: '14+ Day Streak',
        current: status.currentStreak,
        target: 14,
        met: status.currentStreak >= 14,
      ),
      (
        name: 'Survive 1+ Penalty',
        current: status.penaltiesSurvived,
        target: 1,
        met: status.penaltiesSurvived >= 1,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REQUIREMENTS',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...requirements.map(
          (req) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: req.met
                  ? AppColors.success.withAlpha(15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: req.met
                  ? Border.all(color: AppColors.success.withAlpha(50))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  req.met ? Icons.check_circle : Icons.circle_outlined,
                  color: req.met ? AppColors.success : AppColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    req.name,
                    style: TextStyle(
                      color: req.met
                          ? AppColors.success
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${req.current}/${req.target}',
                  style: TextStyle(
                    color: req.met ? AppColors.success : AppColors.textMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnedPerksSection(List<String> ownedPerks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YOUR PERKS',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...ownedPerks.map((perk) {
          final info = perkInfo[perk];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gold.withAlpha(50)),
            ),
            child: Row(
              children: [
                Text(info?.emoji ?? '✨', style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info?.name ?? perk,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        info?.description ?? '',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check, color: AppColors.gold),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPerkSelectionSection(PrestigeStatus status) {
    // Filter out owned perks
    final availablePerks = status.availablePerks
        .where((p) => !status.ownedPerks.contains(p))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE YOUR PERK',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        RadioGroup<String>(
          groupValue: _selectedPerk,
          onChanged: (v) => setState(() => _selectedPerk = v),
          child: Column(
            children: availablePerks.map((perk) {
              final info = perkInfo[perk];
              final isSelected = _selectedPerk == perk;

              return GestureDetector(
                onTap: () => setState(() => _selectedPerk = perk),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.gold.withAlpha(30)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.gold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        info?.emoji ?? '✨',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info?.name ?? perk,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              info?.description ?? '',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(value: perk, activeColor: AppColors.gold),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAscendButton(PrestigeStatus status) {
    return Column(
      children: [
        // Warning
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withAlpha(50)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ascending will reset your Aura to 100 and streak to 0!\nYou will gain 24h immunity and your chosen perk.',
                  style: TextStyle(
                    color: AppColors.warning.withAlpha(200),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Ascend button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedPerk == null || _isAscending
                ? null
                : _performAscension,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isAscending
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.background,
                    ),
                  )
                : const Text(
                    '✨ ASCEND ✨',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEternalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x40FFD700), Color(0x20FFA500)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
      ),
      child: Column(
        children: [
          const Text('👑', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'ETERNAL',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have reached the pinnacle of existence.\nAll perks unlocked. Your legacy is eternal.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _performAscension() async {
    if (_selectedPerk == null) return;

    setState(() => _isAscending = true);

    try {
      await ref.read(prestigeLogicProvider).ascend(_selectedPerk!);

      if (mounted) {
        showAuraSnackbar(
          context,
          '✨ ASCENDED! Gained ${perkInfo[_selectedPerk]?.name ?? _selectedPerk} perk.\n24h immunity granted!',
          type: SnackType.success,
        );

        // Refresh providers
        ref.invalidate(prestigeStatusProvider);
        ref.invalidate(userProvider);
      }
    } catch (e) {
      if (mounted) {
        showAuraSnackbar(
          context,
          'Ascension failed: $e',
          type: SnackType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAscending = false);
      }
    }
  }
}
