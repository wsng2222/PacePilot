import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/cupertino.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/routine.dart';
import '../storage/routine_provider.dart';
import '../utils/routine_sharing.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../workout/screens/workout_screen.dart';
import 'routine_edit_screen.dart';
import '../widgets/routine_shared_widgets.dart';
import '../widgets/qr_share_dialog.dart';
import '../../../services/ad_service.dart';
import '../../../services/workout_live_activity_service.dart';
import '../../../services/workout_reminder_service.dart';
import '../../../widgets/secondary_outlined_button.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/platform_icon.dart';

class RoutineDetailSheet {
  static void show(BuildContext context, Routine routine,
      AppSettingsProvider settingsProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isDismissible: true,
      builder: (context) => _RoutineDetailSheetContent(
        routine: routine,
        settingsProvider: settingsProvider,
      ),
    );
  }
}

class _RoutineDetailSheetContent extends StatelessWidget {
  final Routine routine;
  final AppSettingsProvider settingsProvider;

  const _RoutineDetailSheetContent({
    required this.routine,
    required this.settingsProvider,
  });

  // Guards the async Start-button handler below against a fast double-tap
  // pushing WorkoutScreen twice while it's awaiting the notification
  // permission prompt.
  static DateTime? _lastStartTapAt;

  int _calculateTotalDuration() {
    return routine.intervals
        .fold(0, (sum, interval) => sum + interval.durationSeconds);
  }

  void _showOverflowMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              final l10n = AppLocalizations.of(context)!;
              Navigator.pop(context); // Close action sheet
              final shareLink = await RoutineSharing.generateShareLink(routine);
              final message = l10n.shareRoutineMessage(routine.name, shareLink);
              if (!context.mounted) return;
              final mediaQuery = MediaQuery.of(context);
              await Share.share(
                message,
                sharePositionOrigin: Rect.fromLTWH(
                  0,
                  0,
                  mediaQuery.size.width,
                  mediaQuery.size.height / 2,
                ),
              );
            },
            child: Text(l10n.shareRoutine),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // Close action sheet
              QrShareDialog.show(context, routine);
            },
            child: Text(l10n.shareViaQrCode),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context); // Close action sheet
              _confirmDelete(context, routineProvider);
            },
            child: Text(l10n.delete),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, RoutineProvider routineProvider) {
    final l10n = AppLocalizations.of(context)!;

    showAppDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        icon: platformIconData(
          cupertino: CupertinoIcons.trash,
          material: Icons.delete_outline_rounded,
        ),
        iconColor: Theme.of(dialogContext).colorScheme.error,
        title: l10n.deleteRoutineTitle,
        message: l10n.deleteRoutineMessage,
        actions: [
          AppDialogAction(
            label: l10n.cancel,
            style: AppDialogActionStyle.secondary,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          AppDialogAction(
            label: l10n.delete,
            style: AppDialogActionStyle.destructive,
            onPressed: () {
              HapticFeedback.mediumImpact();
              routineProvider.deleteRoutine(routine.id);
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.9;
    final totalDuration = _calculateTotalDuration();

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const AppBottomSheetHandle(),
          // Header
          RoutineHeader(
            title: routine.name,
            totalDurationSeconds: totalDuration,
            intervalCount: routine.intervals.length,
            difficulty: routine.difficulty,
            onOverflowTap: () => _showOverflowMenu(context),
          ),
          // Intervals list
          Flexible(
            child: SingleChildScrollView(
              child: IntervalList(
                intervals: routine.intervals,
                machineType: routine.machineType,
                settingsProvider: settingsProvider,
                isEditable: false,
              ),
            ),
          ),
          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Edit button (secondary)
                  Expanded(
                    child: SecondaryOutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RoutineEditScreen(routine: routine),
                          ),
                        );
                      },
                      borderRadius: 999,
                      child: Text(
                        AppLocalizations.of(context)!.editRoutine,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Start button (primary)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final tapTime = DateTime.now();
                        final lastTap = _lastStartTapAt;
                        if (lastTap != null &&
                            tapTime.difference(lastTap) <
                                const Duration(milliseconds: 800)) {
                          return;
                        }
                        _lastStartTapAt = tapTime;
                        HapticFeedback.lightImpact();

                        // Check if user is premium - premium users don't see ads
                        final isPremium = settingsProvider.isPremium;

                        if (isPremium) {
                          final navigator = Navigator.of(context);
                          var notificationsAuthorized = false;
                          if (settingsProvider
                              .backgroundIntervalNotificationsEnabled) {
                            notificationsAuthorized =
                                await WorkoutReminderService.instance
                                    .requestPermissions();
                            if (!notificationsAuthorized) {
                              final liveActivitiesEnabled =
                                  await WorkoutLiveActivityService.instance
                                      .areActivitiesEnabled();
                              if (!liveActivitiesEnabled) {
                                await settingsProvider
                                    .updateBackgroundIntervalNotifications(
                                  false,
                                );
                              }
                            }
                          }
                          if (!context.mounted) return;
                          // Premium user: close bottom sheet and navigate directly without ads
                          navigator.pop();
                          navigator.push(
                            MaterialPageRoute(
                              builder: (context) => WorkoutScreen(
                                routine: routine,
                                backgroundNotificationsAuthorized:
                                    notificationsAuthorized,
                              ),
                            ),
                          );
                          return;
                        }

                        // Save navigator context before closing bottom sheet
                        final navigatorContext =
                            Navigator.of(context, rootNavigator: true);

                        // Show interstitial ad if available, then navigate to workout
                        // Don't close bottom sheet yet - close it when ad is dismissed
                        final adService = AdService();
                        final wasAdShown = adService.showAd(
                          onAdClosed: () {
                            // Close bottom sheet and navigate to workout screen
                            if (context.mounted) {
                              Navigator.pop(context); // Close bottom sheet
                            }
                            // Use root navigator to push workout screen
                            navigatorContext.push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutScreen(routine: routine),
                              ),
                            );
                          },
                        );

                        // If ad wasn't shown, close bottom sheet and navigate immediately
                        if (!wasAdShown) {
                          if (context.mounted) {
                            Navigator.pop(context); // Close bottom sheet
                          }
                          navigatorContext.push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutScreen(routine: routine),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.start,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
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
    );
  }
}
