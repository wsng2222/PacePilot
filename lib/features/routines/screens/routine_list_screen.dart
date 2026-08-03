import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/routine.dart';
import '../models/interval.dart' as interval_model;
import '../models/machine_type.dart';
import '../models/difficulty.dart';
import '../models/routine_template.dart';
import '../data/routine_templates.dart';
import '../storage/routine_provider.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../app_shell/app_shell.dart';
import '../../../onboarding/onboarding_storage.dart';
import '../../../widgets/bidi_safe_text.dart';
import 'routine_bottom_sheet.dart';
import 'ai_routine_generator_sheet.dart';
import '../utils/routine_sharing.dart';
import 'qr_scanner_screen.dart';
import 'recommended_routines_screen.dart';
import 'routine_preview_sheet.dart';
import '../../../theme/app_theme.dart';
import '../../membership/widgets/premium_bottom_sheet.dart';
import '../../../widgets/bounceable.dart';
import '../../../widgets/app_dialog.dart';
import '../../../services/analytics_service.dart';
import '../../../widgets/app_segmented_control.dart';
import '../../../widgets/app_message.dart';

Color _segmentedSelectedBackground(BuildContext context) {
  return appSegmentedSelectedBackground(context);
}

SegmentedButtonThemeData _segmentedThemeData(
  BuildContext context,
  Color selectedBackground,
) {
  return appSegmentedThemeData(context, selectedBackground);
}

Widget _buildPlatformSegmentedControl({
  required Key key,
  required List<String> labels,
  required int selectedIndex,
  required ValueChanged<int> onValueChanged,
  required double height,
  Color? color,
}) {
  return AppSegmentedControl(
    key: key,
    labels: labels,
    selectedIndex: selectedIndex,
    onValueChanged: onValueChanged,
    height: height,
    color: color,
  );
}

class _MachineTabItem {
  final IconData icon;
  final String label;

  const _MachineTabItem({
    required this.icon,
    required this.label,
  });
}

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});

  // Global key to access RoutineListScreen state from anywhere
  static final GlobalKey<State<RoutineListScreen>> globalKey =
      GlobalKey<State<RoutineListScreen>>();

  // Static variable to store the target machine type for navigation
  static MachineType? targetMachineType;

  static void navigateToMachineTypeIfReady(MachineType machineType) {
    final state = globalKey.currentState;
    if (state is _RoutineListScreenState) {
      state.navigateToMachineType(machineType);
    }
  }

  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Difficulty? _preferredDifficulty;

  @override
  void initState() {
    super.initState();
    _loadPreferredDifficulty();
    // Check if there's a target machine type to navigate to
    final targetType = RoutineListScreen.targetMachineType;
    int initialPage = 0;
    if (targetType != null) {
      switch (targetType) {
        case MachineType.treadmill:
          initialPage = 0;
          break;
        case MachineType.cycle:
          initialPage = 1;
          break;
        case MachineType.stairmaster:
          initialPage = 2;
          break;
      }
      RoutineListScreen.targetMachineType = null; // Clear after use
    }
    _currentPage = initialPage;
    _pageController = PageController(initialPage: initialPage);
  }

  Future<void> _loadPreferredDifficulty() async {
    final level = await OnboardingStorage.getLevel();
    if (!mounted) return;
    setState(() {
      _preferredDifficulty = _mapLevelToDifficulty(
        level ?? OnboardingLevel.intermediate,
      );
    });
  }

  Difficulty _mapLevelToDifficulty(OnboardingLevel level) {
    switch (level) {
      case OnboardingLevel.beginner:
        return Difficulty.beginner;
      case OnboardingLevel.intermediate:
        return Difficulty.intermediate;
      case OnboardingLevel.advanced:
        return Difficulty.advanced;
    }
  }

  Future<void> _scanQrCode(BuildContext context) async {
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    final scannedLink = await QrScannerScreen.startScanner(context);
    if (scannedLink == null || !context.mounted) return;

    // Parse the scanned link and show the import dialog
    final routine = await RoutineSharing.parseShareLink(scannedLink);
    if (routine == null || !context.mounted) return;

    // Limit check for Treadmill free users
    if (routine.machineType == MachineType.treadmill &&
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

    // Show import confirmation dialog
    showAppDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        icon: Icons.download_rounded,
        title: l10n.importSharedRoutine,
        message: l10n.importQrRoutinePrompt(
          routine.name,
          _getLocalizedDifficulty(context, routine.difficulty),
          LocalizedFormat.decimal(
            context,
            routine.intervals.length,
            decimalDigits: 0,
          ),
        ),
        actions: [
          AppDialogAction(
            label: l10n.cancel,
            style: AppDialogActionStyle.secondary,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          AppDialogAction(
            label: l10n.importAction,
            onPressed: () async {
              await routineProvider.addRoutine(routine);
              AnalyticsService.instance.logEvent(
                'routine_imported',
                {
                  'method': 'qr',
                  'machine_type': routine.machineType.name,
                  'interval_count': routine.intervals.length,
                },
              );
              if (!context.mounted || !dialogContext.mounted) return;
              Navigator.of(dialogContext).pop();

              showAppMessage(
                context,
                l10n.importRoutineSuccess(routine.name),
                type: AppMessageType.success,
              );
            },
          ),
        ],
      ),
    );
  }

  // Method to navigate to specific machine type page
  void navigateToMachineType(MachineType machineType) {
    int pageIndex;
    switch (machineType) {
      case MachineType.treadmill:
        pageIndex = 0;
        break;
      case MachineType.cycle:
        pageIndex = 1;
        break;
      case MachineType.stairmaster:
        pageIndex = 2;
        break;
    }
    _pageController.jumpToPage(pageIndex);
    setState(() {
      _currentPage = pageIndex;
    });
  }

  List<String> _getMachineTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.treadmill,
      l10n.cycle,
      l10n.stairmaster,
    ];
  }

  Widget _buildMachineSegmentedControl(BuildContext context) {
    if (PlatformInfo.isIOS) {
      final titles = _getMachineTitles(context);
      final selectedIndex = _currentPage.clamp(0, titles.length - 1);
      final selectedBg = _segmentedSelectedBackground(context);

      final brightnessKey = Theme.of(context).brightness;
      final localeKey = Localizations.localeOf(context).toLanguageTag();
      return SegmentedButtonTheme(
        data: _segmentedThemeData(context, selectedBg),
        child: SizedBox(
          width: double.infinity,
          child: _buildPlatformSegmentedControl(
            key: ValueKey('machine_segment_${brightnessKey.name}_$localeKey'),
            labels: titles,
            selectedIndex: selectedIndex,
            onValueChanged: (index) {
              if (_currentPage == index) return;
              final currentPage = _pageController.hasClients
                  ? (_pageController.page ?? _currentPage.toDouble())
                  : _currentPage.toDouble();
              final distance = (currentPage - index).abs();
              final durationMs =
                  (220 + (120 * distance)).clamp(260, 420).round();
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: durationMs),
                curve: Curves.easeInOutCubic,
              );
            },
            height: 44,
            color: selectedBg,
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final titles = _getMachineTitles(context);
    final items = [
      _MachineTabItem(icon: Icons.directions_run, label: titles[0]),
      _MachineTabItem(icon: Icons.pedal_bike, label: titles[1]),
      _MachineTabItem(icon: Icons.stairs, label: titles[2]),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const outerPadding = 4.0;
        final innerWidth = (constraints.maxWidth - (outerPadding * 2))
            .clamp(0.0, double.infinity)
            .toDouble();
        final segmentWidth = innerWidth / items.length;

        return Container(
          padding: const EdgeInsets.all(outerPadding),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : appColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _pageController,
            builder: (context, _) {
              final page = _pageController.hasClients
                  ? (_pageController.page ?? _currentPage.toDouble())
                  : _currentPage.toDouble();
              final clampedPage =
                  page.clamp(0.0, (items.length - 1).toDouble()).toDouble();
              final indicatorLeft = segmentWidth * clampedPage;

              return Stack(
                children: [
                  Positioned(
                    left: indicatorLeft,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.04),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final rawT =
                          (1 - (clampedPage - index).abs()).clamp(0.0, 1.0);
                      final t = Curves.easeOutCubic.transform(rawT);
                      final iconColor = Color.lerp(
                        appColors.mutedText,
                        theme.colorScheme.primary,
                        t,
                      );
                      final textColor = Color.lerp(
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        theme.colorScheme.primary,
                        t,
                      );
                      final fontWeight = FontWeight.lerp(
                            FontWeight.w600,
                            FontWeight.w700,
                            t,
                          ) ??
                          (_currentPage == index
                              ? FontWeight.w700
                              : FontWeight.w600);

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (_currentPage == index) return;
                            final currentPage = _pageController.hasClients
                                ? (_pageController.page ??
                                    _currentPage.toDouble())
                                : _currentPage.toDouble();
                            final distance = (currentPage - index).abs();
                            final durationMs = (220 + (120 * distance))
                                .clamp(260, 420)
                                .round();
                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: durationMs),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 17,
                                  color: iconColor,
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: fontWeight,
                                      color: textColor,
                                      letterSpacing: -0.25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAddRoutine(BuildContext context, MachineType machineType) {
    final routineProvider =
        Provider.of<RoutineProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Check free limit when adding new treadmill routine
    if (machineType == MachineType.treadmill &&
        !settingsProvider.isPremium &&
        routineProvider.routines
                .where((r) => r.machineType == MachineType.treadmill)
                .length >=
            2) {
      _showFreeLimitSheet(context);
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.addRoutineOption),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              RoutineBottomSheet.show(
                context,
                initialEditing: true,
                isNew: true,
                machineType: machineType,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit_outlined, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.createCustomRoutine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              AiRoutineGeneratorSheet.show(context, machineType);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome,
                    size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.customRoutineBuilder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Trigger manual check
              RoutineSharing
                  .resetLastProcessedLink(); // Reset tracking so it always triggers
              RoutineSharing.checkClipboardAndImport(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.content_paste_go, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.importFromClipboard,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _navigateToRecommendedRoutines(
      BuildContext context, MachineType machineType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendedRoutinesScreen(
          machineType: machineType,
        ),
      ),
    );
  }

  Widget _buildRecommendedButton(
      BuildContext context, MachineType machineType) {
    final l10n = AppLocalizations.of(context)!;
    final buttonText = l10n.viewRecommendedRoutines;
    return Center(
      child: TextButton(
        onPressed: () => _navigateToRecommendedRoutines(context, machineType),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }

  void _showFreeLimitSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    PremiumBottomSheet.show(
      context,
      title: l10n.premiumMembership,
      bulletItems: [
        l10n.routineLimitBenefit1,
        l10n.routineLimitBenefit2,
        l10n.routineLimitBenefit3,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assign global key to this widget's state
    if (widget.key != RoutineListScreen.globalKey) {
      // This is a workaround - we'll use a different approach
    }
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: null, // Explicitly no AppBar
      body: SafeArea(
        bottom: false,
        child: Consumer2<RoutineProvider, AppSettingsProvider>(
          builder: (context, routineProvider, settingsProvider, child) {
            if (routineProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.10,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.directions_run,
                              size: 22,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.routineTab,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -0.9,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            color: theme.colorScheme.onSurface,
                            iconSize: 26,
                            alignment: AlignmentDirectional.centerEnd,
                            padding: const EdgeInsetsDirectional.only(end: 4),
                            constraints: const BoxConstraints(
                              minWidth: 42,
                              minHeight: 42,
                            ),
                            tooltip: l10n.scanQrCode,
                            onPressed: () => _scanQrCode(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildMachineSegmentedControl(context),
                    ],
                  ),
                ),
                // PageView with 3 pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Page 0: 러닝머신 routines
                      _buildRoutinePage(
                        context,
                        routineProvider.routines
                            .where(
                                (r) => r.machineType == MachineType.treadmill)
                            .toList(),
                        settingsProvider,
                        MachineType.treadmill,
                      ),
                      // Page 1: 사이클 (premium gated)
                      _buildMachinePage(
                        context,
                        MachineType.cycle,
                        settingsProvider.isPremium,
                        routineProvider,
                        settingsProvider,
                      ),
                      // Page 2: 천국의 계단 (premium gated)
                      _buildMachinePage(
                        context,
                        MachineType.stairmaster,
                        settingsProvider.isPremium,
                        routineProvider,
                        settingsProvider,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoutinePage(
    BuildContext context,
    List<Routine> routines,
    AppSettingsProvider settingsProvider,
    MachineType machineType,
  ) {
    return Column(
      children: [
        Expanded(
          child: routines.isEmpty
              ? _buildEmptyState(context, machineType, settingsProvider)
              : _buildRoutineList(
                  context, routines, settingsProvider, machineType),
        ),
      ],
    );
  }

  Widget _buildMachinePage(
    BuildContext context,
    MachineType machineType,
    bool isPremium,
    RoutineProvider routineProvider,
    AppSettingsProvider settingsProvider,
  ) {
    return Column(
      children: [
        Expanded(
          child: !isPremium
              ? _buildLockedScreen(context)
              : _buildContentForMachine(
                  context, machineType, routineProvider, settingsProvider),
        ),
      ],
    );
  }

  Widget _buildContentForMachine(
    BuildContext context,
    MachineType machineType,
    RoutineProvider routineProvider,
    AppSettingsProvider settingsProvider,
  ) {
    final routines = routineProvider.routines
        .where((r) => r.machineType == machineType)
        .toList();
    if (routines.isEmpty) {
      return _buildEmptyState(context, machineType, settingsProvider);
    }
    return _buildRoutineList(context, routines, settingsProvider, machineType);
  }

  Widget _buildLockedScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 80,
            color: context.appColors.mutedText,
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.premium,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.premiumFeature,
            style: TextStyle(
              fontSize: 16,
              color: context.appColors.mutedText,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              // Close any open bottom sheets/dialogs
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigate to Premium tab (index 0) in AppShell after frame completes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AppShell.navigateToPremiumTab();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context)!.viewMembership,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    MachineType machineType,
    AppSettingsProvider settingsProvider,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final templates = RoutineTemplates.getTemplatesByMachine(machineType);
    final preferredDifficulty = _preferredDifficulty ?? Difficulty.intermediate;
    final difficultyTemplates = templates
        .where((template) => template.difficulty == preferredDifficulty)
        .toList();
    final previewTemplates =
        (difficultyTemplates.isNotEmpty ? difficultyTemplates : templates)
            .take(2)
            .toList();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 156, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              l10n.noRoutinesSaved,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tapButtonToCreate,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.appColors.mutedText,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => _handleAddRoutine(context, machineType),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.25),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: theme.colorScheme.surface,
                    size: 38,
                  ),
                ),
              ),
            ),
            if (previewTemplates.isNotEmpty) ...[
              const SizedBox(height: 160),
              Text(
                l10n.quickStart,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              for (final template in previewTemplates)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTemplatePreviewCard(
                    context,
                    template,
                    settingsProvider,
                  ),
                ),
            ],
            const SizedBox(height: 20),
            _buildRecommendedButton(context, machineType),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplatePreviewCard(
    BuildContext context,
    RoutineTemplate template,
    AppSettingsProvider settingsProvider,
  ) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    void openPreview() {
      RoutinePreviewSheet.show(
        context,
        template,
        settingsProvider,
        closeParentOnSave: false,
      );
    }

    return Bounceable(
      onTap: openPreview,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: appColors.border),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTemplateTitle(l10n, template),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _getTemplateSubtitle(l10n, template),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: appColors.mutedText,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 14,
                  color: appColors.mutedText,
                ),
                const SizedBox(width: 6),
                BidiSafeText(
                  template.totalDurationFormatted,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  forceLTR: true,
                ),
                const Spacer(),
                PlatformInfo.isIOS
                    ? AdaptiveButton.icon(
                        onPressed: openPreview,
                        icon: Icons.chevron_right,
                        iconColor: appColors.mutedText,
                        style: AdaptiveButtonStyle.glass,
                        size: AdaptiveButtonSize.small,
                        color: appColors.mutedText,
                        padding: const EdgeInsets.all(6),
                        minSize: const Size(32, 32),
                        borderRadius: BorderRadius.circular(999),
                        useSmoothRectangleBorder: false,
                      )
                    : Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTemplateTitle(AppLocalizations l10n, RoutineTemplate template) {
    try {
      switch (template.titleKey) {
        case 'template_treadmill_beginner_1_title':
          return l10n.templateTreadmillBeginner1Title;
        case 'template_treadmill_beginner_2_title':
          return l10n.templateTreadmillBeginner2Title;
        case 'template_treadmill_intermediate_1_title':
          return l10n.templateTreadmillIntermediate1Title;
        case 'template_treadmill_intermediate_2_title':
          return l10n.templateTreadmillIntermediate2Title;
        case 'template_treadmill_advanced_1_title':
          return l10n.templateTreadmillAdvanced1Title;
        case 'template_treadmill_advanced_2_title':
          return l10n.templateTreadmillAdvanced2Title;
        case 'template_cycle_beginner_1_title':
          return l10n.templateCycleBeginner1Title;
        case 'template_cycle_beginner_2_title':
          return l10n.templateCycleBeginner2Title;
        case 'template_cycle_intermediate_1_title':
          return l10n.templateCycleIntermediate1Title;
        case 'template_cycle_intermediate_2_title':
          return l10n.templateCycleIntermediate2Title;
        case 'template_cycle_advanced_1_title':
          return l10n.templateCycleAdvanced1Title;
        case 'template_cycle_advanced_2_title':
          return l10n.templateCycleAdvanced2Title;
        case 'template_stairmaster_beginner_1_title':
          return l10n.templateStairmasterBeginner1Title;
        case 'template_stairmaster_beginner_2_title':
          return l10n.templateStairmasterBeginner2Title;
        case 'template_stairmaster_intermediate_1_title':
          return l10n.templateStairmasterIntermediate1Title;
        case 'template_stairmaster_intermediate_2_title':
          return l10n.templateStairmasterIntermediate2Title;
        case 'template_stairmaster_advanced_1_title':
          return l10n.templateStairmasterAdvanced1Title;
        case 'template_stairmaster_advanced_2_title':
          return l10n.templateStairmasterAdvanced2Title;
        default:
          return l10n.unnamedRoutine;
      }
    } catch (e) {
      return l10n.unnamedRoutine;
    }
  }

  String _getTemplateSubtitle(AppLocalizations l10n, RoutineTemplate template) {
    try {
      switch (template.subtitleKey) {
        case 'template_treadmill_beginner_1_subtitle':
          return l10n.templateTreadmillBeginner1Subtitle;
        case 'template_treadmill_beginner_2_subtitle':
          return l10n.templateTreadmillBeginner2Subtitle;
        case 'template_treadmill_intermediate_1_subtitle':
          return l10n.templateTreadmillIntermediate1Subtitle;
        case 'template_treadmill_intermediate_2_subtitle':
          return l10n.templateTreadmillIntermediate2Subtitle;
        case 'template_treadmill_advanced_1_subtitle':
          return l10n.templateTreadmillAdvanced1Subtitle;
        case 'template_treadmill_advanced_2_subtitle':
          return l10n.templateTreadmillAdvanced2Subtitle;
        case 'template_cycle_beginner_1_subtitle':
          return l10n.templateCycleBeginner1Subtitle;
        case 'template_cycle_beginner_2_subtitle':
          return l10n.templateCycleBeginner2Subtitle;
        case 'template_cycle_intermediate_1_subtitle':
          return l10n.templateCycleIntermediate1Subtitle;
        case 'template_cycle_intermediate_2_subtitle':
          return l10n.templateCycleIntermediate2Subtitle;
        case 'template_cycle_advanced_1_subtitle':
          return l10n.templateCycleAdvanced1Subtitle;
        case 'template_cycle_advanced_2_subtitle':
          return l10n.templateCycleAdvanced2Subtitle;
        case 'template_stairmaster_beginner_1_subtitle':
          return l10n.templateStairmasterBeginner1Subtitle;
        case 'template_stairmaster_beginner_2_subtitle':
          return l10n.templateStairmasterBeginner2Subtitle;
        case 'template_stairmaster_intermediate_1_subtitle':
          return l10n.templateStairmasterIntermediate1Subtitle;
        case 'template_stairmaster_intermediate_2_subtitle':
          return l10n.templateStairmasterIntermediate2Subtitle;
        case 'template_stairmaster_advanced_1_subtitle':
          return l10n.templateStairmasterAdvanced1Subtitle;
        case 'template_stairmaster_advanced_2_subtitle':
          return l10n.templateStairmasterAdvanced2Subtitle;
        default:
          return l10n.templateTreadmillBeginner1Subtitle;
      }
    } catch (e) {
      return l10n.templateTreadmillBeginner1Subtitle;
    }
  }

  Widget _buildRoutineList(
    BuildContext context,
    List<Routine> routines,
    AppSettingsProvider settingsProvider,
    MachineType machineType,
  ) {
    final isPremium = settingsProvider.isPremium;
    final shouldShowAddButton =
        machineType == MachineType.treadmill || isPremium;

    // Reserve just a small safe-area gap at the bottom (AdaptiveScaffold already pads)
    final bottomReserved = 16.0 + MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        // Routine cards
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final routine = routines[index];
                return _buildRoutineCard(context, routine, settingsProvider);
              },
              childCount: routines.length,
            ),
          ),
        ),
        // "+" button as last scrollable item
        if (shouldShowAddButton)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _handleAddRoutine(context, machineType),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.25),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.surface,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Recommended routines link below + button
        if (shouldShowAddButton)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 42,
                bottom: bottomReserved,
              ),
              child: _buildRecommendedButton(context, machineType),
            ),
          )
        else
          // If no add button, just add bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: bottomReserved),
          ),
        // Fill remaining space when content is short (pushes "+" button to bottom)
        // Only fill when there are routines (not empty), to push button down
        if (shouldShowAddButton && routines.isNotEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildRoutineCard(BuildContext context, Routine routine,
      AppSettingsProvider settingsProvider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // Convert stored Korean difficulty to localized value
    String localizedDifficulty =
        _getLocalizedDifficulty(context, routine.difficulty);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  routine.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _MetaPill(
                icon: Icons.bolt,
                text: localizedDifficulty,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Big duration text (always LTR for timers)
          BidiSafeText(
            routine.totalDurationFormatted,
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -1.0,
            ),
            forceLTR: true, // Timers must always be LTR
          ),
          const SizedBox(height: 14),
          _buildIntervalPatternBar(context, routine),
          const SizedBox(height: 16),
          Row(
            children: [
              if (routine.machineType == MachineType.cycle) ...[
                _MetaPill(
                  icon: Icons.repeat,
                  text: '${routine.intervals.length} ${l10n.sessions}',
                ),
                const SizedBox(width: 8),
              ],
              if (routine.machineType == MachineType.stairmaster) ...[
                _MetaPill(
                  icon: Icons.repeat,
                  text: '${routine.intervals.length} ${l10n.sessions}',
                ),
                const SizedBox(width: 8),
              ],
              if (routine.machineType == MachineType.treadmill) ...[
                _MetaPill(
                  icon: Icons.straighten,
                  text: _buildTotalDistanceText(
                    context,
                    routine,
                    settingsProvider,
                  ),
                ),
                const SizedBox(width: 8),
                _MetaPill(
                  icon: Icons.repeat,
                  text: '${routine.intervals.length} ${l10n.sessions}',
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                RoutineBottomSheet.show(context, routine: routine);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 19),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.checkRoutineStart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildTotalDistanceText(
    BuildContext context,
    Routine routine,
    AppSettingsProvider settings,
  ) {
    double totalKm = 0;
    for (final interval in routine.intervals) {
      if (interval.speedKmh != null) {
        totalKm += interval.speedKmh! * (interval.durationSeconds / 3600.0);
      }
    }
    if (settings.measurement == 'kmh') {
      return '${LocalizedFormat.decimal(context, totalKm, decimalDigits: 2)} km';
    } else {
      return '${LocalizedFormat.decimal(context, totalKm / 1.609344, decimalDigits: 2)} mi';
    }
  }

  Widget _buildIntervalPatternBar(BuildContext context, Routine routine) {
    final theme = Theme.of(context);
    final totalSeconds = routine.intervals.fold<int>(
      0,
      (sum, interval) => sum + interval.durationSeconds,
    );
    if (totalSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final baseColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;

    double metricForInterval(interval_model.Interval interval) {
      switch (routine.machineType) {
        case MachineType.treadmill:
          return (interval.speedKmh ?? 0).toDouble();
        case MachineType.cycle:
          return (interval.resistance ?? 0).toDouble();
        case MachineType.stairmaster:
          return (interval.level ?? 0).toDouble();
      }
    }

    final metrics = routine.intervals.map(metricForInterval).toList();
    final minMetric = metrics.reduce((a, b) => a < b ? a : b);
    final maxMetric = metrics.reduce((a, b) => a > b ? a : b);
    final hasVariation = (maxMetric - minMetric).abs() > 0.001;

    Color segmentColor(int index) {
      if (!hasVariation) {
        // When intensity is identical, keep all segments the same color.
        const uniformMix = 0.28;
        return Color.lerp(baseColor, surfaceColor, uniformMix) ?? baseColor;
      }

      final value = metrics[index];
      final normalized =
          ((value - minMetric) / (maxMetric - minMetric)).clamp(0.0, 1.0);
      final eased = Curves.easeInOutCubic.transform(normalized);
      // Higher intensity -> closer to primary (darker), lower -> closer to surface.
      const mixLow = 0.62;
      const mixHigh = 0.08;
      final mix = (mixLow - (mixLow - mixHigh) * eased).clamp(0.06, 0.7);
      return Color.lerp(baseColor, surfaceColor, mix) ?? baseColor;
    }

    return Row(
      children: [
        for (int i = 0; i < routine.intervals.length; i++) ...[
          Expanded(
            flex: (routine.intervals[i].durationSeconds / totalSeconds * 100)
                .clamp(1, 100)
                .round(),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: segmentColor(i),
                borderRadius: BorderRadius.horizontal(
                  left: i == 0 ? const Radius.circular(999) : Radius.zero,
                  right: i == routine.intervals.length - 1
                      ? const Radius.circular(999)
                      : Radius.zero,
                ),
              ),
            ),
          ),
          if (i < routine.intervals.length - 1) const SizedBox(width: 3),
        ],
      ],
    );
  }

  String _getLocalizedDifficulty(
      BuildContext context, String storedDifficulty) {
    final l10n = AppLocalizations.of(context)!;
    final difficultyStorageValues = ['쉬움', '중간', '높음'];
    final difficultyDisplayValues = [l10n.easy, l10n.medium, l10n.hard];

    final index = difficultyStorageValues.indexOf(storedDifficulty);
    if (index >= 0 && index < difficultyDisplayValues.length) {
      return difficultyDisplayValues[index];
    }
    // Fallback to stored value if not found
    return storedDifficulty;
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: appColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: appColors.mutedText,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
