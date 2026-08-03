import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import 'package:image_picker/image_picker.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../../routines/models/routine.dart';
import '../../routines/models/machine_type.dart';
import '../../routines/models/interval.dart';
import '../../../widgets/bidi_safe_text.dart';
import '../../../widgets/bounceable.dart';
import '../../../widgets/secondary_outlined_button.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_message.dart';
import '../../../theme/app_theme.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../services/ad_service.dart';
import '../../../utils/debug_log.dart';
import '../../profile/models/workout_session.dart';
import '../../profile/providers/workout_history_provider.dart';
import '../../profile/models/achievement.dart';
import '../../profile/providers/achievement_provider.dart';

class WorkoutFinishedScreen extends StatefulWidget {
  final Routine routine;
  final int elapsedSeconds;
  final int? elapsedMilliseconds;
  final DateTime finishTime;
  final double? distanceMeters; // Distance in meters (null for non-treadmill)
  final int
      currentIntervalIndex; // Index of the interval that was active when workout ended
  final int
      elapsedSecondsInCurrentSession; // Seconds elapsed in the current interval when workout ended
  final bool previewMode;

  const WorkoutFinishedScreen({
    super.key,
    required this.routine,
    required this.elapsedSeconds,
    this.elapsedMilliseconds,
    required this.finishTime,
    this.distanceMeters,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
    this.previewMode = false,
  });

  @override
  State<WorkoutFinishedScreen> createState() => _WorkoutFinishedScreenState();
}

class _WorkoutFinishedScreenState extends State<WorkoutFinishedScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _fadeController;
  bool _hasPlayedAnimation = false;
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Save workout session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.previewMode) {
        _saveWorkoutSession();
      }
    });

    // Trigger animation and haptic on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasPlayedAnimation) {
        _hasPlayedAnimation = true;
        _fadeController.forward();
        if (!widget.previewMode) {
          HapticFeedback.lightImpact();
          _confettiController.forward();
        }
      }
    });
  }

  void _saveWorkoutSession() {
    if (!mounted) return;

    final historyProvider =
        Provider.of<WorkoutHistoryProvider>(context, listen: false);

    // Calculate averages
    double? avgRpm;
    double? avgLevel;

    if (widget.routine.machineType == MachineType.cycle) {
      double totalWeightedRpm = 0.0;
      int totalActualSeconds = 0;

      for (int i = 0; i < widget.currentIntervalIndex; i++) {
        final interval = widget.routine.intervals[i];
        if (interval.rpm != null && interval.durationSeconds > 0) {
          totalWeightedRpm += interval.rpm! * interval.durationSeconds;
          totalActualSeconds += interval.durationSeconds;
        }
      }

      if (widget.currentIntervalIndex < widget.routine.intervals.length) {
        final currentInterval =
            widget.routine.intervals[widget.currentIntervalIndex];
        if (currentInterval.rpm != null &&
            widget.elapsedSecondsInCurrentSession > 0) {
          totalWeightedRpm +=
              currentInterval.rpm! * widget.elapsedSecondsInCurrentSession;
          totalActualSeconds += widget.elapsedSecondsInCurrentSession;
        }
      }

      if (totalActualSeconds > 0) {
        avgRpm = totalWeightedRpm / totalActualSeconds;
      }
    } else if (widget.routine.machineType == MachineType.stairmaster) {
      double totalWeightedLevel = 0.0;
      int totalActualSeconds = 0;

      for (int i = 0; i < widget.currentIntervalIndex; i++) {
        final interval = widget.routine.intervals[i];
        if (interval.level != null && interval.durationSeconds > 0) {
          totalWeightedLevel += interval.level! * interval.durationSeconds;
          totalActualSeconds += interval.durationSeconds;
        }
      }

      if (widget.currentIntervalIndex < widget.routine.intervals.length) {
        final currentInterval =
            widget.routine.intervals[widget.currentIntervalIndex];
        if (currentInterval.level != null &&
            widget.elapsedSecondsInCurrentSession > 0) {
          totalWeightedLevel +=
              currentInterval.level! * widget.elapsedSecondsInCurrentSession;
          totalActualSeconds += widget.elapsedSecondsInCurrentSession;
        }
      }

      if (totalActualSeconds > 0) {
        avgLevel = totalWeightedLevel / totalActualSeconds;
      }
    }

    final session = WorkoutSession(
      machineType: widget.routine.machineType,
      dateTime: widget.finishTime,
      durationSeconds: widget.elapsedSeconds,
      elapsedMilliseconds: widget.elapsedMilliseconds,
      distanceMeters: widget.distanceMeters,
      averageRpm: avgRpm,
      averageLevel: avgLevel,
      routineName: widget.routine.name,
      routineId: widget.routine.id,
    );

    historyProvider.addSession(session);

    // Check if there are newly unlocked achievements to celebrate
    final achievementProvider =
        Provider.of<AchievementProvider>(context, listen: false);
    if (achievementProvider.newlyUnlocked.isNotEmpty) {
      _showCongratsDialog(achievementProvider.newlyUnlocked);
    }
  }

  void _showCongratsDialog(List<Achievement> achievements) {
    if (!mounted) return;

    final langCode = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    // Play a premium vibration
    HapticFeedback.heavyImpact();

    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppDialog(
          icon: Icons.emoji_events_rounded,
          title: l10n.achievementUnlocked,
          message: l10n.achievementCongratulations,
          content: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: achievements.map((ach) {
              final title = ach.getTitle(langCode);
              final desc = ach.getDescription(langCode);
              return SizedBox(
                width: 120,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: ach.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ach.gradientColors[0]
                                .withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(ach.icon, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(dialogContext)
                            .extension<AppColors>()!
                            .mutedText,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: [
            AppDialogAction(
              label: l10n.awesome,
              onPressed: () {
                final provider = Provider.of<AchievementProvider>(
                  dialogContext,
                  listen: false,
                );
                provider.clearNewlyUnlocked();
                Navigator.of(dialogContext).pop();
                HapticFeedback.lightImpact();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _shareWorkout(BuildContext context) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (!context.mounted || pickedFile == null) {
        // Closing the camera is an intentional cancellation. Keep the user on
        // the workout completion screen instead of showing an empty card.
        return;
      }

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _SharePreviewSheet(
          routine: widget.routine,
          elapsedSeconds: widget.elapsedSeconds,
          distanceMeters: widget.distanceMeters,
          finishTime: widget.finishTime,
          currentIntervalIndex: widget.currentIntervalIndex,
          elapsedSecondsInCurrentSession: widget.elapsedSecondsInCurrentSession,
          imagePath: pickedFile.path,
        ),
      );
    } catch (e) {
      debugLog('[WorkoutFinishedScreen] Error picking image: $e');
      if (context.mounted) {
        showAppMessage(
          context,
          AppLocalizations.of(context)!.unableToShareWorkout,
          type: AppMessageType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final machineTypeLabel = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.treadmill,
      MachineType.cycle => l10n.cycle,
      MachineType.stairmaster => l10n.stairmaster,
    };

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            if (!widget.previewMode)
              _ConfettiAnimation(controller: _confettiController),
            // Main content
            FadeTransition(
              opacity: _fadeController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.workoutComplete,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.routine.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.extension<AppColors>()!.mutedText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _WorkoutSummaryCard(
                      elapsedSeconds: widget.elapsedSeconds,
                      distanceMeters:
                          widget.routine.machineType == MachineType.treadmill
                              ? widget.distanceMeters
                              : null,
                      finishTime: widget.finishTime,
                      routine: widget.routine,
                      machineTypeLabel: machineTypeLabel,
                      currentIntervalIndex: widget.currentIntervalIndex,
                      elapsedSecondsInCurrentSession:
                          widget.elapsedSecondsInCurrentSession,
                    ),
                    const SizedBox(height: 12),
                    _WorkoutChart(
                      routine: widget.routine,
                      currentIntervalIndex: widget.currentIntervalIndex,
                      elapsedSecondsInCurrentSession:
                          widget.elapsedSecondsInCurrentSession,
                    ),
                    const Spacer(),
                    // Share button
                    SecondaryOutlinedButton(
                      key: _shareButtonKey,
                      onPressed: () => _shareWorkout(context),
                      borderRadius: AppTheme.buttonRadius,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      borderColor: theme.colorScheme.outline.withOpacity(0.38),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share_outlined, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.share,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Primary button: End
                    SizedBox(
                      width: double.infinity,
                      child: Bounceable(
                        onTap: () {
                          // Check if user is premium - premium users don't see ads
                          final settingsProvider =
                              Provider.of<AppSettingsProvider>(context,
                                  listen: false);
                          final isPremium = settingsProvider.isPremium;

                          if (isPremium) {
                            // Premium user: navigate directly without ads
                            Navigator.of(context, rootNavigator: true)
                                .popUntil((route) => route.isFirst);
                            return;
                          }

                          // Show interstitial ad if available, then navigate home
                          final adService = AdService();
                          final navigatorContext =
                              Navigator.of(context, rootNavigator: true);
                          final wasAdShown = adService.showAd(
                            onAdClosed: () {
                              // Navigate back to AppShell (home route) after ad is closed
                              if (mounted) {
                                navigatorContext
                                    .popUntil((route) => route.isFirst);
                              }
                            },
                          );

                          // If ad wasn't shown, navigate immediately
                          if (!wasAdShown) {
                            navigatorContext.popUntil((route) => route.isFirst);
                          }
                        },
                        child: IgnorePointer(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppTheme.buttonRadius),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.end,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Combined workout summary card (time + distance/average)
class _WorkoutSummaryCard extends StatelessWidget {
  final int elapsedSeconds;
  final double? distanceMeters;
  final DateTime finishTime;
  final Routine routine;
  final String machineTypeLabel;
  final int currentIntervalIndex;
  final int elapsedSecondsInCurrentSession;

  const _WorkoutSummaryCard({
    required this.elapsedSeconds,
    this.distanceMeters,
    required this.finishTime,
    required this.routine,
    required this.machineTypeLabel,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatDistance(BuildContext context, double distanceMeters) {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.measurement == 'kmh';

    if (isMetric) {
      // Metric: show meters (< 1000m) or km (>= 1000m)
      if (distanceMeters < 1000) {
        return '${LocalizedFormat.decimal(context, distanceMeters, decimalDigits: 0)} m';
      } else {
        final km = distanceMeters / 1000.0;
        return '${LocalizedFormat.decimal(context, km, decimalDigits: 2)} km';
      }
    } else {
      // Imperial: convert meters to miles
      const metersPerMile = 1609.344;
      final miles = distanceMeters / metersPerMile;

      if (miles < 0.1) {
        // Very small distances: show 3 decimals
        return '${LocalizedFormat.decimal(context, miles, decimalDigits: 3)} mi';
      } else {
        // Normal distances: show 2 decimals
        return '${LocalizedFormat.decimal(context, miles, decimalDigits: 2)} mi';
      }
    }
  }

  /// Calculate time-weighted average RPM for Bike workouts
  /// Returns null if no valid data or workout was stopped immediately
  double? _calculateAverageRpm() {
    if (routine.machineType != MachineType.cycle) return null;

    double totalWeightedRpm = 0.0;
    int totalActualSeconds = 0;

    // Process completed intervals (fully elapsed)
    for (int i = 0; i < currentIntervalIndex; i++) {
      final interval = routine.intervals[i];
      if (interval.rpm != null && interval.durationSeconds > 0) {
        totalWeightedRpm += interval.rpm! * interval.durationSeconds;
        totalActualSeconds += interval.durationSeconds;
      }
    }

    // Process current interval (partially elapsed if stopped mid-session)
    if (currentIntervalIndex < routine.intervals.length) {
      final currentInterval = routine.intervals[currentIntervalIndex];
      if (currentInterval.rpm != null && elapsedSecondsInCurrentSession > 0) {
        totalWeightedRpm +=
            currentInterval.rpm! * elapsedSecondsInCurrentSession;
        totalActualSeconds += elapsedSecondsInCurrentSession;
      }
    }

    if (totalActualSeconds == 0) return null;
    return totalWeightedRpm / totalActualSeconds;
  }

  /// Calculate time-weighted average Level for Stairmaster workouts
  /// Returns null if no valid data or workout was stopped immediately
  double? _calculateAverageLevel() {
    if (routine.machineType != MachineType.stairmaster) return null;

    double totalWeightedLevel = 0.0;
    int totalActualSeconds = 0;

    // Process completed intervals (fully elapsed)
    for (int i = 0; i < currentIntervalIndex; i++) {
      final interval = routine.intervals[i];
      if (interval.level != null && interval.durationSeconds > 0) {
        totalWeightedLevel += interval.level! * interval.durationSeconds;
        totalActualSeconds += interval.durationSeconds;
      }
    }

    // Process current interval (partially elapsed if stopped mid-session)
    if (currentIntervalIndex < routine.intervals.length) {
      final currentInterval = routine.intervals[currentIntervalIndex];
      if (currentInterval.level != null && elapsedSecondsInCurrentSession > 0) {
        totalWeightedLevel +=
            currentInterval.level! * elapsedSecondsInCurrentSession;
        totalActualSeconds += elapsedSecondsInCurrentSession;
      }
    }

    if (totalActualSeconds == 0) return null;
    return totalWeightedLevel / totalActualSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColors>()!;

    // Card background color
    final cardColor = isDark
        ? const Color(0xFF1C1C1E) // Dark surface
        : const ui.Color.fromARGB(245, 245, 245, 245);
    final secondaryMetric = distanceMeters != null && distanceMeters! > 0
        ? _formatDistance(context, distanceMeters!)
        : routine.machineType == MachineType.cycle
            ? (() {
                final avgRpm = _calculateAverageRpm();
                return avgRpm == null
                    ? null
                    : '${LocalizedFormat.decimal(context, avgRpm)} RPM';
              })()
            : routine.machineType == MachineType.stairmaster
                ? (() {
                    final avgLevel = _calculateAverageLevel();
                    return avgLevel == null
                        ? null
                        : l10n.levelColon(
                            LocalizedFormat.decimal(context, avgLevel),
                          );
                  })()
                : null;
    final summaryParts =
        secondaryMetric != null ? <String>[secondaryMetric] : <String>[];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: isDark
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.totalWorkoutTime,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: appColors.mutedText,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          BidiSafeText(
            _formatTime(elapsedSeconds),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -1.4,
              fontFeatures: const [
                ui.FontFeature.tabularFigures()
              ], // Monospaced digits
            ),
            forceLTR: true, // Timers must always be LTR
          ),
          Text(
            summaryParts.join(' · '),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: appColors.mutedText,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            LocalizedFormat.dateTime(context, finishTime),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: appColors.mutedText,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// Advanced physics-based confetti particle animation
class _ConfettiAnimation extends StatelessWidget {
  final AnimationController controller;

  const _ConfettiAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(progress: controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final width = size.width;
    final height = size.height;

    final colors = [
      const Color(0xFFFF1744), // Vibrant Red
      const Color(0xFFFF9100), // Orange
      const Color(0xFFFFEA00), // Yellow
      const Color(0xFF00E676), // Green
      const Color(0xFF2979FF), // Blue
      const Color(0xFFD500F9), // Purple
      const Color(0xFF00E5FF), // Cyan
    ];

    const particleCount = 100;

    for (int i = 0; i < particleCount; i++) {
      // Use deterministic random based on particle index so we don't need real-time state updates
      final rand = math.Random(i + 100);

      // Emitter side: true = left bottom, false = right bottom
      final isLeft = i % 2 == 0;
      final startX = isLeft ? width * 0.10 : width * 0.90;
      final startY = height * 0.85;

      // Launch Angle: shoot upwards and towards the center
      // Left side shoots at -30 to -60 degrees, Right side shoots at -120 to -150 degrees
      final angleRange = rand.nextDouble() * (math.pi / 4); // 0 to 45 deg
      final baseAngle =
          isLeft ? -math.pi / 6 - angleRange : -5 * math.pi / 6 + angleRange;

      // Initial speed (pixels per second)
      final speed = 700 + rand.nextDouble() * 600;
      final vx = math.cos(baseAngle) * speed;
      final vy = math.sin(baseAngle) * speed;

      // Gravity (pixels per second squared)
      final gravity = 700 + rand.nextDouble() * 300;

      // Wind (sinusoidal horizontal drift)
      final windFreq = 2.0 + rand.nextDouble() * 3.0;
      final windAmp = 40.0 + rand.nextDouble() * 50.0;

      // Rotation settings
      final rotationSpeed = (rand.nextDouble() - 0.5) * 8.0;
      final rotationPhase = rand.nextDouble() * math.pi;

      // Size and scale settings
      final sizeScale = 8.0 + rand.nextDouble() * 10.0;
      final shapeType = rand.nextInt(3); // 0: rectangle, 1: circle, 2: triangle

      // Time (t goes from 0.0 to 3.0 seconds based on progress)
      final t = progress * 3.0;

      // Update positions using projectile physics with drag & wind
      final drag = math.exp(-0.25 * t);

      // Position equations
      final x = startX +
          (vx * t) * drag +
          math.sin(t * windFreq + rotationPhase) * windAmp * t;
      final y = startY + (vy * t) * drag + (0.5 * gravity * t * t);

      // Skip painting if off-screen below bottom
      if (y > height + 20) continue;

      // Fading opacity: stays solid, then fades out in the last 30% of progress
      final double opacity =
          progress < 0.7 ? 1.0 : (1.0 - (progress - 0.7) / 0.3).clamp(0.0, 1.0);
      if (opacity <= 0.0) continue;

      // Rotation angle
      final angle = rotationPhase + rotationSpeed * t;

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      // 3D scaling simulation
      final scaleX = math.sin(t * 5.0 + rotationPhase).abs().clamp(0.1, 1.0);
      canvas.scale(scaleX, 1.0);

      // Draw different shapes
      switch (shapeType) {
        case 0: // Rectangle ribbon
          canvas.drawRect(
            Rect.fromCenter(
                center: Offset.zero, width: sizeScale, height: sizeScale * 0.5),
            paint,
          );
          break;
        case 1: // Circle dot
          canvas.drawCircle(Offset.zero, sizeScale * 0.35, paint);
          break;
        case 2: // Triangle
          final path = Path();
          final r = sizeScale * 0.5;
          path.moveTo(0, -r);
          path.lineTo(r * 0.86, r * 0.5);
          path.lineTo(-r * 0.86, r * 0.5);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ShareCard extends StatelessWidget {
  final Routine routine;
  final int elapsedSeconds;
  final double? distanceMeters;
  final DateTime finishTime;
  final int currentIntervalIndex;
  final int elapsedSecondsInCurrentSession;
  final String machineTypeLabel;
  final String totalTimeLabel;
  final String distanceLabel;
  final String avgRpmLabel;
  final String avgLevelLabel;
  final String? imagePath;
  final double cardW;
  final double cardH;

  const _ShareCard({
    required this.routine,
    required this.elapsedSeconds,
    this.distanceMeters,
    required this.finishTime,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
    required this.machineTypeLabel,
    required this.totalTimeLabel,
    required this.distanceLabel,
    required this.avgRpmLabel,
    required this.avgLevelLabel,
    this.imagePath,
    required this.cardW,
    required this.cardH,
  });

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatDate(BuildContext context, DateTime dateTime) {
    return LocalizedFormat.date(context, dateTime);
  }

  String _formatTimeOfDay(BuildContext context, DateTime dateTime) {
    return LocalizedFormat.time(context, dateTime);
  }

  String _formatDistance(BuildContext context, double rawDistanceMeters) {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.measurement == 'kmh';

    if (isMetric) {
      if (rawDistanceMeters < 1000) {
        return '${LocalizedFormat.decimal(context, rawDistanceMeters, decimalDigits: 0)} m';
      }
      return '${LocalizedFormat.decimal(context, rawDistanceMeters / 1000, decimalDigits: 2)} km';
    }

    const metersPerMile = 1609.344;
    final miles = rawDistanceMeters / metersPerMile;
    return miles < 0.1
        ? '${LocalizedFormat.decimal(context, miles, decimalDigits: 3)} mi'
        : '${LocalizedFormat.decimal(context, miles, decimalDigits: 2)} mi';
  }

  String? _secondaryMetricValue(BuildContext context) {
    if (routine.machineType == MachineType.treadmill) {
      final treadmillDistance = distanceMeters;
      if (treadmillDistance != null) {
        return _formatDistance(context, treadmillDistance);
      }
    }
    if (routine.machineType == MachineType.cycle) {
      final rpm = _avgRpm();
      return rpm?.round().toString();
    }
    if (routine.machineType == MachineType.stairmaster) {
      final level = _avgLevel();
      return level == null ? null : LocalizedFormat.decimal(context, level);
    }
    return null;
  }

  double? _avgRpm() {
    if (routine.machineType != MachineType.cycle) return null;
    double w = 0;
    int t = 0;
    for (int i = 0; i < currentIntervalIndex; i++) {
      final iv = routine.intervals[i];
      if (iv.rpm != null) {
        w += iv.rpm! * iv.durationSeconds;
        t += iv.durationSeconds;
      }
    }
    if (currentIntervalIndex < routine.intervals.length) {
      final iv = routine.intervals[currentIntervalIndex];
      if (iv.rpm != null && elapsedSecondsInCurrentSession > 0) {
        w += iv.rpm! * elapsedSecondsInCurrentSession;
        t += elapsedSecondsInCurrentSession;
      }
    }
    return t == 0 ? null : w / t;
  }

  double? _avgLevel() {
    if (routine.machineType != MachineType.stairmaster) return null;
    double w = 0;
    int t = 0;
    for (int i = 0; i < currentIntervalIndex; i++) {
      final iv = routine.intervals[i];
      if (iv.level != null) {
        w += iv.level! * iv.durationSeconds;
        t += iv.durationSeconds;
      }
    }
    if (currentIntervalIndex < routine.intervals.length) {
      final iv = routine.intervals[currentIntervalIndex];
      if (iv.level != null && elapsedSecondsInCurrentSession > 0) {
        w += iv.level! * elapsedSecondsInCurrentSession;
        t += elapsedSecondsInCurrentSession;
      }
    }
    return t == 0 ? null : w / t;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSquare = cardH == cardW;

    final brandFontSize = isSquare ? 18.0 : 22.0;
    final dateFontSize = isSquare ? 10.0 : 12.0;
    final timeFontSize = isSquare ? 26.0 : 32.0;
    final labelFontSize = isSquare ? 9.0 : 10.0;
    final metricValFontSize = isSquare ? 16.0 : 20.0;
    final metricLabelFontSize = isSquare ? 9.0 : 10.0;
    final graphHeight = isSquare ? 30.0 : 44.0;
    final contentPadding = isSquare
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 18)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 26);
    final bottomSpacerHeight = isSquare ? 8.0 : 12.0;
    final graphSpacerHeight = isSquare ? 12.0 : 18.0;

    const textShadows = [
      Shadow(
        offset: Offset(0, 1.5),
        blurRadius: 4.0,
        color: Colors.black87,
      ),
      Shadow(
        offset: Offset(0, 3.0),
        blurRadius: 8.0,
        color: Colors.black54,
      ),
    ];

    final l10n = AppLocalizations.of(context)!;
    final metricLabel = switch (routine.machineType) {
      MachineType.treadmill => distanceLabel,
      MachineType.cycle => avgRpmLabel,
      MachineType.stairmaster => avgLevelLabel,
    };
    final metricValue = _secondaryMetricValue(context);
    final dateStr = _formatDate(context, finishTime);
    final timeStr = _formatTimeOfDay(context, finishTime);

    Widget backgroundWidget;
    if (imagePath != null && File(imagePath!).existsSync()) {
      backgroundWidget = Image.file(
        File(imagePath!),
        width: cardW,
        height: cardH,
        fit: BoxFit.cover,
      );
    } else {
      backgroundWidget = Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1016), Color(0xFF1B1D2A)],
          ),
        ),
      );
    }

    return SizedBox(
      width: cardW,
      height: cardH,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            Positioned.fill(child: backgroundWidget),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.0, 0.25, 0.65, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/app_icon.png',
                            width: brandFontSize * 1.45,
                            height: brandFontSize * 1.45,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.directions_run,
                                color: theme.colorScheme.primary,
                                size: brandFontSize * 1.45,
                              );
                            },
                          ),
                          Transform.translate(
                            offset: Offset(isSquare ? -1.0 : -2.0, 0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: brandFontSize,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.2,
                                  fontStyle: FontStyle.italic,
                                  fontFamily:
                                      theme.textTheme.titleMedium?.fontFamily,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Val',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'cue',
                                    style: TextStyle(
                                        color: theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$dateStr  $timeStr',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: dateFontSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BidiSafeText(
                        _formatTime(elapsedSeconds),
                        forceLTR: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: timeFontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: isSquare ? -1.5 : -3.0,
                          height: 1.0,
                          fontFeatures: const [ui.FontFeature.tabularFigures()],
                          shadows: textShadows,
                        ),
                      ),
                      Text(
                        totalTimeLabel.toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          shadows: textShadows,
                        ),
                      ),
                      SizedBox(height: bottomSpacerHeight),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  metricValue ?? '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: metricValFontSize,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.8,
                                    height: 1.1,
                                    shadows: textShadows,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  metricLabel.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: metricLabelFontSize,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.4,
                                    shadows: textShadows,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  machineTypeLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: metricValFontSize,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.8,
                                    height: 1.1,
                                    shadows: textShadows,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.workout.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: metricLabelFontSize,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.4,
                                    shadows: textShadows,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: graphSpacerHeight),
                      if (routine.intervals.isNotEmpty) ...[
                        SizedBox(
                          width: double.infinity,
                          height: graphHeight,
                          child: CustomPaint(
                            painter: _ShareIntervalGraphPainter(
                              intervals: routine.intervals,
                              machineType: routine.machineType,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareIntervalGraphPainter extends CustomPainter {
  final List<Interval> intervals;
  final MachineType machineType;

  _ShareIntervalGraphPainter({
    required this.intervals,
    required this.machineType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (intervals.isEmpty) return;

    final totalDuration =
        intervals.fold<double>(0.0, (sum, i) => sum + i.durationSeconds);
    if (totalDuration <= 0) return;

    double maxVal = 1.0;
    for (final iv in intervals) {
      double val = 0;
      if (machineType == MachineType.treadmill) {
        val = iv.speedKmh ?? 0.0;
      } else if (machineType == MachineType.cycle) {
        val = (iv.rpm ?? 0).toDouble();
        if (val == 0) val = (iv.resistance ?? 0).toDouble();
      } else if (machineType == MachineType.stairmaster) {
        val = (iv.level ?? 0).toDouble();
      }
      if (val > maxVal) maxVal = val;
    }

    final path = Path();
    final fillPath = Path();

    double currentX = 0.0;
    fillPath.moveTo(0, size.height);

    for (int i = 0; i < intervals.length; i++) {
      final iv = intervals[i];
      double val = 0;
      if (machineType == MachineType.treadmill) {
        val = iv.speedKmh ?? 0.0;
      } else if (machineType == MachineType.cycle) {
        val = (iv.rpm ?? 0).toDouble();
        if (val == 0) val = (iv.resistance ?? 0).toDouble();
      } else if (machineType == MachineType.stairmaster) {
        val = (iv.level ?? 0).toDouble();
      }

      final segmentWidth = (iv.durationSeconds / totalDuration) * size.width;
      final y = size.height - (val / maxVal) * (size.height * 0.85);

      if (i == 0) {
        path.moveTo(0, y);
        fillPath.lineTo(0, y);
      } else {
        path.lineTo(currentX, y);
        fillPath.lineTo(currentX, y);
      }

      currentX += segmentWidth;
      path.lineTo(currentX, y);
      fillPath.lineTo(currentX, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ShareIntervalGraphPainter oldDelegate) {
    return oldDelegate.intervals != intervals ||
        oldDelegate.machineType != machineType;
  }
}

class _WorkoutChart extends StatefulWidget {
  final Routine routine;
  final int currentIntervalIndex;
  final int elapsedSecondsInCurrentSession;

  const _WorkoutChart({
    required this.routine,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
  });

  @override
  State<_WorkoutChart> createState() => _WorkoutChartState();
}

class _WorkoutChartState extends State<_WorkoutChart> {
  int? _hoveredIntervalIndex;

  void _updateHoveredIndex(double localX, double totalWidth) {
    if (widget.routine.intervals.isEmpty || totalWidth <= 0) return;

    final totalDuration = widget.routine.intervals
        .fold<int>(0, (sum, i) => sum + i.durationSeconds);
    if (totalDuration == 0) return;

    final progressPercent = (localX / totalWidth).clamp(0.0, 1.0);
    final elapsedSeconds = (progressPercent * totalDuration).round();

    int calculatedIndex = 0;
    int accumulated = 0;
    for (int i = 0; i < widget.routine.intervals.length; i++) {
      accumulated += widget.routine.intervals[i].durationSeconds;
      if (elapsedSeconds <= accumulated) {
        calculatedIndex = i;
        break;
      }
    }

    if (_hoveredIntervalIndex != calculatedIndex) {
      setState(() {
        _hoveredIntervalIndex = calculatedIndex;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _clearHoveredIndex() {
    if (_hoveredIntervalIndex != null) {
      setState(() {
        _hoveredIntervalIndex = null;
      });
    }
  }

  Widget _buildTooltip(
      Interval interval, double chartWidth, double chartHeight, int index) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final totalDuration = widget.routine.intervals
        .fold<int>(0, (sum, i) => sum + i.durationSeconds);
    if (totalDuration == 0) return const SizedBox.shrink();

    // Calculate center X of this interval
    int durationBefore = 0;
    for (int i = 0; i < index; i++) {
      durationBefore += widget.routine.intervals[i].durationSeconds;
    }
    final intervalDuration = interval.durationSeconds;
    final intervalCenterSeconds = durationBefore + (intervalDuration / 2);
    final pointX = (intervalCenterSeconds / totalDuration) * chartWidth;

    const tooltipWidth = 140.0;
    final leftPos =
        (pointX - tooltipWidth / 2).clamp(4.0, chartWidth - tooltipWidth - 4.0);

    // Format metrics based on machineType
    String metricText = '';
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    switch (widget.routine.machineType) {
      case MachineType.treadmill:
        final speed = settingsProvider.formatSpeed(interval.speedKmh ?? 0);
        final grade = LocalizedFormat.decimal(context, interval.grade ?? 0);
        metricText = '$speed • $grade%';
        break;
      case MachineType.cycle:
        final rpm = LocalizedFormat.decimal(
          context,
          interval.rpm ?? 0,
          decimalDigits: 0,
        );
        final res = LocalizedFormat.decimal(
          context,
          interval.resistance ?? 0,
          decimalDigits: 0,
        );
        metricText = '$rpm RPM • ${l10n.resistanceColon(res)}';
        break;
      case MachineType.stairmaster:
        final lvl = LocalizedFormat.decimal(
          context,
          interval.level ?? 0,
          decimalDigits: 0,
        );
        metricText = l10n.levelColon(lvl);
        break;
    }

    final intervalTitle = l10n.liveActivityIntervalFormat(
      LocalizedFormat.decimal(context, index + 1, decimalDigits: 0),
      LocalizedFormat.decimal(
        context,
        widget.routine.intervals.length,
        decimalDigits: 0,
      ),
    );
    final durationFormatted = interval.durationFormatted;

    return Positioned(
      left: leftPos,
      top: -56, // Floating above the card
      child: Container(
        width: tooltipWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              metricText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              '$intervalTitle ($durationFormatted)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColors>()!;

    if (widget.routine.intervals.isEmpty) return const SizedBox.shrink();

    // Map MachineType display names
    final machineName = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.treadmill,
      MachineType.cycle => l10n.cycle,
      MachineType.stairmaster => l10n.stairmaster,
    };

    return Container(
      height: 142,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color.fromARGB(245, 245, 245, 245),
        borderRadius: BorderRadius.circular(24),
        border: isDark
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.routineTab,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: appColors.mutedText,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  machineName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              final chartHeight = constraints.maxHeight;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onHorizontalDragStart: (details) {
                      _updateHoveredIndex(details.localPosition.dx, chartWidth);
                    },
                    onHorizontalDragUpdate: (details) {
                      _updateHoveredIndex(details.localPosition.dx, chartWidth);
                    },
                    onHorizontalDragEnd: (details) {
                      _clearHoveredIndex();
                    },
                    onHorizontalDragCancel: () {
                      _clearHoveredIndex();
                    },
                    onTapDown: (details) {
                      _updateHoveredIndex(details.localPosition.dx, chartWidth);
                    },
                    onTapUp: (details) {
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          _clearHoveredIndex();
                        }
                      });
                    },
                    onTapCancel: () {
                      _clearHoveredIndex();
                    },
                    child: Container(
                      color: Colors
                          .transparent, // Ensure gesture detector grabs touches
                      child: CustomPaint(
                        painter: _WorkoutChartPainter(
                          intervals: widget.routine.intervals,
                          currentIntervalIndex: widget.currentIntervalIndex,
                          elapsedSecondsInCurrentSession:
                              widget.elapsedSecondsInCurrentSession,
                          primaryColor: theme.colorScheme.primary,
                          secondaryColor: theme.colorScheme.secondary,
                          isDark: isDark,
                          machineType: widget.routine.machineType,
                          hoveredIntervalIndex: _hoveredIntervalIndex,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  if (_hoveredIntervalIndex != null &&
                      _hoveredIntervalIndex! < widget.routine.intervals.length)
                    _buildTooltip(
                      widget.routine.intervals[_hoveredIntervalIndex!],
                      chartWidth,
                      chartHeight,
                      _hoveredIntervalIndex!,
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _WorkoutChartPainter extends CustomPainter {
  final List<Interval> intervals;
  final int currentIntervalIndex;
  final int elapsedSecondsInCurrentSession;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;
  final MachineType machineType;
  final int? hoveredIntervalIndex;

  _WorkoutChartPainter({
    required this.intervals,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
    required this.machineType,
    this.hoveredIntervalIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (intervals.isEmpty) return;

    final width = size.width;
    final height = size.height;

    // Calculate total seconds and completed seconds
    final totalDuration =
        intervals.fold<int>(0, (sum, i) => sum + i.durationSeconds);
    if (totalDuration == 0) return;

    int completedSeconds = 0;
    for (int i = 0; i < currentIntervalIndex && i < intervals.length; i++) {
      completedSeconds += intervals[i].durationSeconds;
    }
    if (currentIntervalIndex < intervals.length) {
      completedSeconds += elapsedSecondsInCurrentSession;
    }
    completedSeconds = completedSeconds.clamp(0, totalDuration);

    final progressPercent = completedSeconds / totalDuration;
    final progressX = progressPercent * width;

    // Extract values
    final values = intervals.map((i) {
      switch (machineType) {
        case MachineType.treadmill:
          return i.speedKmh ?? 0.0;
        case MachineType.cycle:
          return (i.rpm ?? 0).toDouble();
        case MachineType.stairmaster:
          return (i.level ?? 0).toDouble();
      }
    }).toList();

    // Max/min limits
    double maxLimit = 10.0;
    double minLimit = 0.0;
    switch (machineType) {
      case MachineType.treadmill:
        maxLimit = 12.0;
        break;
      case MachineType.cycle:
        maxLimit = 100.0;
        break;
      case MachineType.stairmaster:
        maxLimit = 15.0;
        break;
    }

    double maxVal = maxLimit;
    double minVal = minLimit;
    for (final v in values) {
      if (v > maxVal) maxVal = v;
      if (v < minVal) minVal = v;
    }

    final valRange = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    // Grid Lines (Low/Medium/High boundaries)
    final gridPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw horizontal dividers
    canvas.drawLine(
        Offset(0, height * 0.25), Offset(width, height * 0.25), gridPaint);
    canvas.drawLine(
        Offset(0, height * 0.65), Offset(width, height * 0.65), gridPaint);

    // Build the step paths
    final fillPath = Path();
    final strokePath = Path();

    fillPath.moveTo(0, height);

    double currentX = 0;
    double? lastY;

    for (int i = 0; i < intervals.length; i++) {
      final interval = intervals[i];
      final val = values[i];
      final duration = interval.durationSeconds;
      final stepWidth = (duration / totalDuration) * width;
      final y = height - ((val - minVal) / valRange) * height * 0.85 - 2;

      if (i == 0) {
        fillPath.lineTo(0, y);
        strokePath.moveTo(0, y);
      } else {
        if (lastY != null) {
          fillPath.lineTo(currentX, lastY);
          fillPath.lineTo(currentX, y);
          strokePath.lineTo(currentX, y);
        }
      }

      fillPath.lineTo(currentX + stepWidth, y);
      strokePath.lineTo(currentX + stepWidth, y);

      lastY = y;
      currentX += stepWidth;
    }

    fillPath.lineTo(width, height);
    fillPath.close();

    // Shader for completed (active colors) vs skipped (muted gray)
    final gradientColors = [
      primaryColor,
      secondaryColor,
      isDark ? const Color(0xFF333336) : const Color(0xFFD1D1D6),
      isDark ? const Color(0xFF242426) : const Color(0xFFE5E5EA),
    ];
    final gradientStops = [
      0.0,
      progressPercent,
      progressPercent + 0.005,
      1.0,
    ].map((e) => e.clamp(0.0, 1.0)).toList();

    // Handle corner cases where progress is 0% or 100%
    if (progressPercent <= 0.0) {
      gradientColors.removeRange(0, 2);
      gradientStops.clear();
      gradientStops.addAll([0.0, 1.0]);
    } else if (progressPercent >= 1.0) {
      gradientColors.removeRange(2, 4);
      gradientStops.clear();
      gradientStops.addAll([0.0, 1.0]);
    }

    final shader = ui.Gradient.linear(
      Offset.zero,
      Offset(width, 0),
      gradientColors,
      gradientStops,
    );

    // Paint Area Fill
    final fillPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill
      ..color = Colors.grey;

    final fillShader = ui.Gradient.linear(
      Offset.zero,
      Offset(width, 0),
      gradientColors.map((c) => c.withValues(alpha: 0.18)).toList(),
      gradientStops,
    );
    fillPaint.shader = fillShader;
    canvas.drawPath(fillPath, fillPaint);

    // Paint Stroke Line
    final strokePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(strokePath, strokePaint);

    // Draw End Indicator vertical line
    if (hoveredIntervalIndex != null &&
        hoveredIntervalIndex! < intervals.length) {
      // Calculate center X of this interval
      int durationBefore = 0;
      for (int i = 0; i < hoveredIntervalIndex!; i++) {
        durationBefore += intervals[i].durationSeconds;
      }
      final intervalDuration = intervals[hoveredIntervalIndex!].durationSeconds;
      final intervalCenterSeconds = durationBefore + (intervalDuration / 2);
      final hoveredX = (intervalCenterSeconds / totalDuration) * width;

      final val = values[hoveredIntervalIndex!];
      final hoveredY = height - ((val - minVal) / valRange) * height * 0.85 - 2;

      final verticalLinePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      // Draw vertical dashed line
      double dashY = 0;
      const dashSpace = 4.0;
      while (dashY < height) {
        canvas.drawLine(Offset(hoveredX, dashY),
            Offset(hoveredX, dashY + dashSpace), verticalLinePaint);
        dashY += dashSpace * 2;
      }

      // Draw dot and shadow highlight like _WeightSparklinePainter
      final dotPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      final outerCirclePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      final centerCirclePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(hoveredX, hoveredY), 8.0, outerCirclePaint);
      canvas.drawCircle(Offset(hoveredX, hoveredY), 4.5, dotPaint);
      canvas.drawCircle(Offset(hoveredX, hoveredY), 2.2, centerCirclePaint);
    } else if (progressPercent > 0.0 && progressPercent < 1.0) {
      final verticalLinePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      // Draw vertical dashed line
      double dashY = 0;
      const dashSpace = 4.0;
      while (dashY < height) {
        canvas.drawLine(Offset(progressX, dashY),
            Offset(progressX, dashY + dashSpace), verticalLinePaint);
        dashY += dashSpace * 2;
      }

      // Find current interval y coordinate to draw dot
      double indicatorY = height;
      double indicatorXAcc = 0;
      for (int i = 0; i < intervals.length; i++) {
        final duration = intervals[i].durationSeconds;
        final stepWidth = (duration / totalDuration) * width;
        if (progressX >= indicatorXAcc &&
            progressX <= indicatorXAcc + stepWidth) {
          final val = values[i];
          indicatorY = height - ((val - minVal) / valRange) * height * 0.85 - 2;
          break;
        }
        indicatorXAcc += stepWidth;
      }

      // Draw dot
      final dotPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      final shadowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill
        ..imageFilter = ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0);

      canvas.drawCircle(Offset(progressX, indicatorY), 8, shadowPaint);
      canvas.drawCircle(Offset(progressX, indicatorY), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_WorkoutChartPainter oldDelegate) {
    return oldDelegate.currentIntervalIndex != currentIntervalIndex ||
        oldDelegate.elapsedSecondsInCurrentSession !=
            elapsedSecondsInCurrentSession ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.isDark != isDark ||
        oldDelegate.hoveredIntervalIndex != hoveredIntervalIndex;
  }
}

class _SharePreviewSheet extends StatefulWidget {
  final Routine routine;
  final int elapsedSeconds;
  final double? distanceMeters;
  final DateTime finishTime;
  final int currentIntervalIndex;
  final int elapsedSecondsInCurrentSession;
  final String? imagePath;

  const _SharePreviewSheet({
    required this.routine,
    required this.elapsedSeconds,
    this.distanceMeters,
    required this.finishTime,
    required this.currentIntervalIndex,
    required this.elapsedSecondsInCurrentSession,
    this.imagePath,
  });

  @override
  State<_SharePreviewSheet> createState() => _SharePreviewSheetState();
}

class _SharePreviewSheetState extends State<_SharePreviewSheet> {
  String _aspectRatio = '9:14'; // '9:14', '9:16', '1:1'
  final GlobalKey _cardKey = GlobalKey();
  bool _isSharing = false;

  double get _cardW => 360.0;
  double get _cardH {
    if (_aspectRatio == '9:16') return 640.0;
    if (_aspectRatio == '1:1') return 360.0;
    return 560.0; // '9:14'
  }

  Future<void> _shareCardImage() async {
    setState(() {
      _isSharing = true;
    });

    final shareErrorMessage =
        AppLocalizations.of(context)!.unableToShareWorkout;
    try {
      // Wait for layout/paint
      await Future.delayed(const Duration(milliseconds: 300));
      final renderObject = _cardKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        setState(() {
          _isSharing = false;
        });
        return;
      }

      final image = await renderObject.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        setState(() {
          _isSharing = false;
        });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/workout_result_${_aspectRatio.replaceAll(':', '_')}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Get share origin bounds
      Rect? shareOrigin;
      final mediaQuery = MediaQuery.of(context);
      shareOrigin = Rect.fromLTWH(
        0,
        mediaQuery.size.height - 100,
        mediaQuery.size.width,
        100,
      );

      // Dismiss preview sheet
      if (mounted) {
        Navigator.pop(context);
      }

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      debugLog('[SharePreviewSheet] Failed to share: $e');
      if (mounted) {
        showAppMessage(
          context,
          shareErrorMessage,
          type: AppMessageType.error,
        );
      }
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final machineTypeLabel = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.treadmill,
      MachineType.cycle => l10n.cycle,
      MachineType.stairmaster => l10n.stairmaster,
    };

    final defaultLabel = l10n.shareCardDefault;
    final storyLabel = l10n.shareCardStory;
    final squareLabel = l10n.shareCardSquare;

    return AppBottomSheetFrame(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.customizeShareCard,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            // Card Preview Area
            Container(
              height: 320,
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RepaintBoundary(
                    key: _cardKey,
                    child: _ShareCard(
                      routine: widget.routine,
                      elapsedSeconds: widget.elapsedSeconds,
                      distanceMeters: widget.distanceMeters,
                      finishTime: widget.finishTime,
                      currentIntervalIndex: widget.currentIntervalIndex,
                      elapsedSecondsInCurrentSession:
                          widget.elapsedSecondsInCurrentSession,
                      machineTypeLabel: machineTypeLabel,
                      totalTimeLabel: l10n.totalTime,
                      distanceLabel: l10n.totalDistance,
                      avgRpmLabel: l10n.averageRpm,
                      avgLevelLabel: l10n.averageLevel,
                      imagePath: widget.imagePath,
                      cardW: _cardW,
                      cardH: _cardH,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRatioOption('9:14', defaultLabel),
                const SizedBox(width: 8),
                _buildRatioOption('9:16', storyLabel),
                const SizedBox(width: 8),
                _buildRatioOption('1:1', squareLabel),
              ],
            ),
            const SizedBox(height: 32),
            // Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSharing ? null : _shareCardImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 0,
                ),
                child: _isSharing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.share,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildRatioOption(String ratio, String label) {
    final isSelected = _aspectRatio == ratio;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _aspectRatio = ratio;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.12)
                : Colors.transparent,
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : theme.dividerColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
