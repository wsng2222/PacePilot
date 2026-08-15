import 'dart:async';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/cupertino.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../models/routine.dart';
import '../models/machine_type.dart';
import '../storage/routine_provider.dart';
import '../utils/custom_routine_generator.dart';
import '../utils/custom_routine_units.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../services/sound_service.dart';
import '../../../services/voice_guide_service.dart';
import '../../../services/analytics_service.dart';
import '../../../widgets/bottom_sheet_action_bar.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_dialog.dart';
import '../../../onboarding/onboarding_storage.dart';
import '../../profile/providers/weight_tracker_provider.dart';

class AiRoutineGeneratorSheet extends StatefulWidget {
  final MachineType initialMachineType;

  const AiRoutineGeneratorSheet({
    super.key,
    required this.initialMachineType,
  });

  static void show(BuildContext context, MachineType initialMachineType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => AiRoutineGeneratorSheet(
        initialMachineType: initialMachineType,
      ),
    );
  }

  @override
  State<AiRoutineGeneratorSheet> createState() =>
      _AiRoutineGeneratorSheetState();
}

class _AiRoutineGeneratorSheetState extends State<AiRoutineGeneratorSheet> {
  late MachineType _machineType;
  int _durationMinutes = 20;

  // Workout Goal Variables
  double _distanceTargetKm = 5.0; // 1.0 to 10.0 km
  int _stairsTargetFloors = 50; // 10 to 200 floors (StairMaster only)
  double _bodyWeightKg = 70.0; // 40 to 150 kg
  late TextEditingController _weightController;
  String? _displayedWeightUnit;
  String _difficulty = 'medium';
  bool _includeIncline = true;
  bool _includeWarmupCooldown = true;

  bool _isGenerating = false;
  int _loadingStep = 0;
  int _regenerateCount = 0;
  Routine? _generatedRoutine;
  Timer? _generationTimer;

  @override
  void initState() {
    super.initState();
    _machineType = widget.initialMachineType;
    _weightController =
        TextEditingController(text: _bodyWeightKg.toInt().toString());
    _loadSavedWeight();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final weightUnit = context.watch<AppSettingsProvider>().weightUnit;
    if (_displayedWeightUnit != weightUnit) {
      _displayedWeightUnit = weightUnit;
      _syncWeightController(weightUnit);
    }
  }

  Future<void> _loadSavedWeight() async {
    final savedWeight = await OnboardingStorage.getSavedWeightKg();
    if (!mounted) return;
    var weightKg = _bodyWeightKg;
    if (savedWeight != null) {
      weightKg = savedWeight;
    } else {
      try {
        final weightTracker =
            Provider.of<WeightTrackerProvider>(context, listen: false);
        if (weightTracker.currentWeight != null) {
          weightKg = weightTracker.currentWeight!.weightKg;
        }
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _bodyWeightKg = weightKg;
      final weightUnit = context.read<AppSettingsProvider>().weightUnit;
      _displayedWeightUnit = weightUnit;
      _syncWeightController(weightUnit);
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _generationTimer?.cancel();
    super.dispose();
  }

  void _startGeneration({bool isRegenerating = false}) {
    HapticFeedback.mediumImpact();
    _validateAndFixWeightInput();
    if (isRegenerating) {
      _regenerateCount++;
    }

    setState(() {
      _isGenerating = true;
      _loadingStep = 0;
      _generatedRoutine = null;
    });

    _generationTimer?.cancel();
    int currentStep = 0;
    _generationTimer =
        Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (currentStep < 3) {
        currentStep++;
        setState(() {
          _loadingStep = currentStep;
        });
      } else {
        timer.cancel();
        _finalizeGeneration();
      }
    });
  }

  void _finalizeGeneration() {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.read<AppSettingsProvider>();
    final intervals = buildCustomRoutineIntervals(
      machineType: _machineType,
      durationMinutes: _durationMinutes,
      distanceTargetKm: _distanceTargetKm,
      caloriesTarget: _difficultyToCaloriesTarget(),
      bodyWeightKg: _bodyWeightKg,
      includeIncline: _includeIncline,
      includeWarmupCooldown: _includeWarmupCooldown,
      stairsTargetFloors: _stairsTargetFloors,
      variationSeed: _regenerateCount,
      difficulty: _difficulty,
    );

    // Name formatting based on generation pattern mode
    final int patternMode = _regenerateCount % 3;
    String name = '';
    final distStr = LocalizedFormat.decimal(
      context,
      _distanceForDisplay(settingsProvider),
    );
    final distanceUnit = _distanceUnit(settingsProvider);

    if (_machineType == MachineType.treadmill) {
      if (patternMode == 1) {
        name = l10n.buildUpRunName(distStr, distanceUnit);
      } else if (patternMode == 2) {
        name = l10n.pyramidRunName(distStr, distanceUnit);
      } else {
        name = l10n.customRunName(
          distStr,
          distanceUnit,
          LocalizedFormat.decimal(
            context,
            _difficultyToCaloriesTarget(),
            decimalDigits: 0,
          ),
        );
      }
    } else if (_machineType == MachineType.cycle) {
      if (patternMode == 1) {
        name = l10n.buildUpCycleName(distStr, distanceUnit);
      } else if (patternMode == 2) {
        name = l10n.pyramidCycleName(distStr, distanceUnit);
      } else {
        name = l10n.customCycleName(
          distStr,
          distanceUnit,
          LocalizedFormat.decimal(
            context,
            _difficultyToCaloriesTarget(),
            decimalDigits: 0,
          ),
        );
      }
    } else {
      name = l10n.customStairsName(
        LocalizedFormat.decimal(
          context,
          _stairsTargetFloors,
          decimalDigits: 0,
        ),
        LocalizedFormat.decimal(
          context,
          _difficultyToCaloriesTarget(),
          decimalDigits: 0,
        ),
      );
    }

    setState(() {
      _isGenerating = false;
      _generatedRoutine = Routine(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        difficulty: _difficulty == 'hard'
            ? l10n.hard
            : (_difficulty == 'easy' ? l10n.easy : l10n.medium),
        intervals: intervals,
        machineType: _machineType,
      );
    });

    // Trigger completion feedback effects
    unawaited(SoundService().playFinished());
    unawaited(
      VoiceGuideService.instance.speakCustom(
        l10n.customRoutineSpeech(
          LocalizedFormat.decimal(
            context,
            _difficultyToCaloriesTarget(),
            decimalDigits: 0,
          ),
        ),
      ),
    );
  }

  int _difficultyToCaloriesTarget() {
    switch (_difficulty) {
      case 'easy':
        return 180;
      case 'hard':
        return 350;
      case 'medium':
      default:
        return 250;
    }
  }

  Widget _buildDifficultyChip(String value, String label, IconData icon) {
    final isSelected = _difficulty == value;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _difficulty = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color:
                      isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyLabel(AppLocalizations l10n) {
    switch (_difficulty) {
      case 'easy':
        return l10n.easy;
      case 'hard':
        return l10n.hard;
      case 'medium':
      default:
        return l10n.medium;
    }
  }

  Future<void> _saveRoutine() async {
    if (_generatedRoutine == null) return;

    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Limit check for Treadmill free users
    if (_generatedRoutine!.machineType == MachineType.treadmill &&
        !settingsProvider.isPremium &&
        routineProvider.routines
                .where((r) => r.machineType == MachineType.treadmill)
                .length >=
            2) {
      showAppDialog<void>(
        context: context,
        builder: (dialogContext) => AppDialog(
          icon: Icons.lock_outline_rounded,
          title: l10n.routineLimitReached,
          message: l10n.routineLimitMessage,
          actions: [
            AppDialogAction(
              label: l10n.ok,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
      );
      return;
    }

    await routineProvider.addRoutine(_generatedRoutine!);
    if (!mounted) return;
    AnalyticsService.instance.logEvent(
      'custom_routine_created',
      {
        'machine_type': _machineType.name,
        'duration_minutes': _durationMinutes,
        'interval_count': _generatedRoutine!.intervals.length,
      },
    );

    Navigator.pop(context); // Close bottom sheet
  }

  double get _maxDistanceTargetKm {
    // Treadmill: max ~12 km/h → 0.21 km/min
    // Cycle: max ~30 km/h virtual → 0.55 km/min
    double kmPerMin = _machineType == MachineType.cycle ? 0.55 : 0.21;
    double maxLimit = (_durationMinutes * kmPerMin);
    double rounded = (maxLimit * 10).round() / 10.0;
    return rounded.clamp(1.0, 40.0);
  }

  int get _maxStairsTargetFloors {
    int maxLimit = (_durationMinutes * 4.5).round();
    return maxLimit.clamp(10, 200);
  }

  bool _usesMiles(AppSettingsProvider settingsProvider) =>
      settingsProvider.measurement == 'mph';

  bool _usesPounds(AppSettingsProvider settingsProvider) =>
      settingsProvider.weightUnit == 'lbs';

  double _distanceForDisplay(AppSettingsProvider settingsProvider) {
    return CustomRoutineUnits.distanceForDisplay(
      _distanceTargetKm,
      useMiles: _usesMiles(settingsProvider),
    );
  }

  double _maxDistanceForDisplay(AppSettingsProvider settingsProvider) {
    final converted = CustomRoutineUnits.distanceForDisplay(
      _maxDistanceTargetKm,
      useMiles: _usesMiles(settingsProvider),
    );
    return (converted * 10).floorToDouble() / 10;
  }

  double _minDistanceForDisplay(AppSettingsProvider settingsProvider) =>
      _usesMiles(settingsProvider) ? 0.6 : 1.0;

  String _distanceUnit(AppSettingsProvider settingsProvider) =>
      _usesMiles(settingsProvider) ? 'mi' : 'km';

  String _formatDistance(AppSettingsProvider settingsProvider) {
    return '${LocalizedFormat.decimal(context, _distanceForDisplay(settingsProvider))} '
        '${_distanceUnit(settingsProvider)}';
  }

  void _updateDistanceFromDisplay(
    double displayDistance,
    AppSettingsProvider settingsProvider,
  ) {
    final roundedDisplayDistance = (displayDistance * 10).round() / 10.0;
    _distanceTargetKm = CustomRoutineUnits.distanceToKilometers(
      roundedDisplayDistance,
      useMiles: _usesMiles(settingsProvider),
    ).clamp(1.0, _maxDistanceTargetKm);
  }

  String _formatWeightInput(
    double weightKg,
    String weightUnit,
  ) {
    final displayWeight = CustomRoutineUnits.weightForDisplay(
      weightKg,
      usePounds: weightUnit == 'lbs',
    );
    final decimalDigits =
        displayWeight.truncateToDouble() == displayWeight ? 0 : 1;
    return LocalizedFormat.decimal(
      context,
      displayWeight,
      decimalDigits: decimalDigits,
    );
  }

  void _syncWeightController(String weightUnit) {
    _weightController.text = _formatWeightInput(_bodyWeightKg, weightUnit);
  }

  double? _weightInputInKilograms(AppSettingsProvider settingsProvider) {
    final parsed =
        LocalizedFormat.tryParseDecimal(context, _weightController.text);
    if (parsed == null) return null;
    return CustomRoutineUnits.weightToKilograms(
      parsed,
      usePounds: _usesPounds(settingsProvider),
    );
  }

  void _updateWeightFromInput(AppSettingsProvider settingsProvider) {
    final weightKg = _weightInputInKilograms(settingsProvider);
    if (weightKg == null || weightKg < 30.0 || weightKg > 250.0) return;
    _bodyWeightKg = weightKg;
    OnboardingStorage.setSavedWeightKg(_bodyWeightKg);
  }

  void _validateAndFixWeightInput() {
    final settingsProvider = context.read<AppSettingsProvider>();
    final weightKg = _weightInputInKilograms(settingsProvider);
    if (weightKg == null || weightKg < 30.0 || weightKg > 250.0) {
      _syncWeightController(settingsProvider.weightUnit);
    } else {
      _bodyWeightKg = weightKg;
      _syncWeightController(settingsProvider.weightUnit);
      OnboardingStorage.setSavedWeightKg(_bodyWeightKg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: AppBottomSheetFrame(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isGenerating) ...[
              _buildLoadingState(theme, appColors)
            ] else if (_generatedRoutine != null) ...[
              _buildPreviewState(theme, appColors)
            ] else ...[
              Flexible(
                child: _buildConfigurationState(theme, appColors),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppColors appColors) {
    final l10n = AppLocalizations.of(context)!;
    final phrases = [
      l10n.customRoutineLoadingTarget,
      l10n.customRoutineLoadingStructure,
      l10n.customRoutineLoadingPace,
      l10n.customRoutineLoadingVoice,
    ];
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium glowing AI circle loader
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Colors.purpleAccent,
                      Colors.blueAccent,
                      Colors.cyanAccent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                l10n.customRoutineGenerating,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 32),
              // Step status checker list
              Column(
                children: List.generate(phrases.length, (idx) {
                  final isDone = _loadingStep > idx;
                  final isCurrent = _loadingStep == idx;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle
                              : (isCurrent
                                  ? Icons.circle_outlined
                                  : Icons.circle_outlined),
                          color: isDone
                              ? Colors.greenAccent
                              : (isCurrent
                                  ? Colors.blueAccent
                                  : Colors.grey.withValues(alpha: 0.4)),
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            phrases[idx],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isCurrent ? FontWeight.w600 : FontWeight.w400,
                              color: isDone
                                  ? theme.colorScheme.onSurface
                                  : (isCurrent
                                      ? theme.colorScheme.primary
                                      : appColors.mutedText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewState(ThemeData theme, AppColors appColors) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<AppSettingsProvider>();
    final targetSummary = _machineType == MachineType.stairmaster
        ? '${l10n.targetStairs}: ${l10n.floorCount(
            LocalizedFormat.decimal(
              context,
              _stairsTargetFloors,
              decimalDigits: 0,
            ),
          )}'
        : '${l10n.targetDistance}: ${_formatDistance(settingsProvider)}';
    return Expanded(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.generationComplete,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _generatedRoutine!.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$targetSummary • ${l10n.difficulty}: ${_getDifficultyLabel(l10n)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _startGeneration(isRegenerating: true),
                  child: Text(l10n.regenerate),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5),

          // Scrollable Preview List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildFlatIntervalList(theme, appColors),
            ),
          ),

          BottomSheetActionBar(
            secondaryLabel: l10n.adjustGoals,
            primaryLabel: l10n.saveRoutine,
            onSecondaryPressed: () => setState(() => _generatedRoutine = null),
            onPrimaryPressed: _saveRoutine,
          ),
        ],
      ),
    );
  }

  Widget _buildFlatIntervalList(ThemeData theme, AppColors appColors) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final layeredSurfaceColor =
        isDark ? appColors.surfaceElevated : const Color(0xFFF2F2F7);
    final chipSurfaceColor = isDark ? const Color(0xFF3C3C3C) : Colors.white;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _generatedRoutine!.intervals.length,
      itemBuilder: (context, index) {
        final interval = _generatedRoutine!.intervals[index];
        String? pill1Text;
        String? pill2Text;

        switch (_machineType) {
          case MachineType.treadmill:
            if (interval.speedKmh != null && interval.grade != null) {
              pill1Text = settingsProvider.formatSpeed(interval.speedKmh!);
              pill2Text = l10n.inclineValue(
                LocalizedFormat.decimal(context, interval.grade!),
              );
            }
            break;
          case MachineType.cycle:
            if (interval.rpm != null && interval.resistance != null) {
              pill1Text = l10n.rpmValue(
                LocalizedFormat.decimal(
                  context,
                  interval.rpm!,
                  decimalDigits: 0,
                ),
              );
              pill2Text = l10n.resistanceColon(
                LocalizedFormat.decimal(
                  context,
                  interval.resistance!,
                  decimalDigits: 0,
                ),
              );
            }
            break;
          case MachineType.stairmaster:
            if (interval.level != null) {
              pill1Text = l10n.levelColon(
                LocalizedFormat.decimal(
                  context,
                  interval.level!,
                  decimalDigits: 0,
                ),
              );
              pill2Text = null;
            }
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: layeredSurfaceColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : appColors.border,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: chipSurfaceColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        interval.durationFormatted,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (pill1Text != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: chipSurfaceColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          pill1Text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                    if (pill2Text != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: chipSurfaceColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          pill2Text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfigurationState(
    ThemeData theme,
    AppColors appColors,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<AppSettingsProvider>();
    final isStairMaster = _machineType == MachineType.stairmaster;

    // Premium styling tokens
    final cardBgColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : theme.colorScheme.onSurface.withValues(alpha: 0.03);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Premium Header with clear primary text color (No blurry gradient)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l10n.customRoutineBuilder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Goal Selection Cards
          // Time Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.timer_outlined,
                              color: iconColor, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l10n.duration,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        l10n.durationMinutes(
                          LocalizedFormat.decimal(
                            context,
                            _durationMinutes,
                            decimalDigits: 0,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: theme.colorScheme.primary,
                    inactiveTrackColor:
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                    thumbColor: theme.colorScheme.primary,
                    overlayColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 9),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 18),
                  ),
                  child: Slider(
                    value: _durationMinutes.toDouble(),
                    min: 10,
                    max: 60,
                    divisions: 10,
                    onChanged: (val) {
                      setState(() {
                        _durationMinutes = val.toInt();
                        if (_distanceTargetKm > _maxDistanceTargetKm) {
                          _distanceTargetKm = _maxDistanceTargetKm;
                        }
                        if (_stairsTargetFloors > _maxStairsTargetFloors) {
                          _stairsTargetFloors = _maxStairsTargetFloors;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Distance or Floor Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            isStairMaster
                                ? Icons.stairs_outlined
                                : Icons.directions_run_outlined,
                            color: iconColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              isStairMaster
                                  ? l10n.targetStairs
                                  : l10n.targetDistance,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        isStairMaster
                            ? l10n.floorCount(
                                LocalizedFormat.decimal(
                                  context,
                                  _stairsTargetFloors,
                                  decimalDigits: 0,
                                ),
                              )
                            : _formatDistance(settingsProvider),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: theme.colorScheme.primary,
                    inactiveTrackColor:
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                    thumbColor: theme.colorScheme.primary,
                    overlayColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 9),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 18),
                  ),
                  child: isStairMaster
                      ? Slider(
                          value: _stairsTargetFloors
                              .clamp(10, _maxStairsTargetFloors)
                              .toDouble(),
                          min: 10,
                          max: _maxStairsTargetFloors.toDouble(),
                          onChanged: (val) =>
                              setState(() => _stairsTargetFloors = val.toInt()),
                        )
                      : Slider(
                          value: _distanceForDisplay(settingsProvider).clamp(
                            _minDistanceForDisplay(settingsProvider),
                            _maxDistanceForDisplay(settingsProvider),
                          ),
                          min: _minDistanceForDisplay(settingsProvider),
                          max: _maxDistanceForDisplay(settingsProvider),
                          onChanged: (val) => setState(
                            () => _updateDistanceFromDisplay(
                              val,
                              settingsProvider,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Body Weight Card (Direct Number Input)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.monitor_weight_outlined,
                          color: iconColor, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.weightTab,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            _validateAndFixWeightInput();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onSubmitted: (_) {
                            _validateAndFixWeightInput();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            _updateWeightFromInput(settingsProvider);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        settingsProvider.weightUnit,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Difficulty Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed_outlined, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.difficulty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildDifficultyChip(
                        'easy', l10n.easy, Icons.slow_motion_video_outlined),
                    _buildDifficultyChip(
                        'medium', l10n.medium, Icons.speed_outlined),
                    _buildDifficultyChip('hard', l10n.hard,
                        Icons.local_fire_department_outlined),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Warmup & Cooldown Toggle Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.fitness_center_outlined,
                        color: iconColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.includeWarmupCooldown,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Transform.scale(
                  scale: 0.85,
                  child: CupertinoSwitch(
                    value: _includeWarmupCooldown,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (val) =>
                        setState(() => _includeWarmupCooldown = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Incline Toggle Card (Treadmill only)
          if (_machineType == MachineType.treadmill) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: iconColor, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.includeIncline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: CupertinoSwitch(
                      value: _includeIncline,
                      activeTrackColor: theme.colorScheme.primary,
                      onChanged: (val) => setState(() => _includeIncline = val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ] else ...[
            const SizedBox(height: 28),
          ],

          // 3. Action Button (Red Sporty accent)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: _startGeneration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.generateCustomRoutine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
