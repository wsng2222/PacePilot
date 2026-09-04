import 'package:flutter/material.dart';
import 'package:valcue/l10n/app_localizations.dart';
import '../../../app_shell/app_shell.dart';
import '../../../theme/app_theme.dart';
import '../../../services/analytics_service.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/bottom_sheet_action_bar.dart';

/// Reusable premium bottom sheet with consistent styling
/// Used for premium gates, membership promotions, etc.
class PremiumBottomSheet {
  static void show(
    BuildContext context, {
    required String title,
    String? description,
    required List<String> bulletItems,
    String? primaryButtonText,
    VoidCallback? onPrimary,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    AnalyticsService.instance.logEvent(
      'paywall_viewed',
      {'source': 'premium_gate'},
    );

    final primaryAction = onPrimary ??
        () {
          Navigator.pop(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            AppShell.navigateToPremiumTab();
          });
        };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      isDismissible: true,
      builder: (context) => _PremiumBottomSheetContent(
        title: title,
        description: description,
        bulletItems: bulletItems,
        primaryButtonText: primaryButtonText ?? l10n.viewMembership,
        onPrimary: () {
          AnalyticsService.instance.logEvent(
            'premium_clicked',
            {'source': 'premium_gate'},
          );
          primaryAction();
        },
      ),
    );
  }
}

class _PremiumBottomSheetContent extends StatelessWidget {
  final String title;
  final String? description;
  final List<String> bulletItems;
  final String primaryButtonText;
  final VoidCallback onPrimary;

  const _PremiumBottomSheetContent({
    required this.title,
    this.description,
    required this.bulletItems,
    required this.primaryButtonText,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBottomSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                // Description (optional)
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.extension<AppColors>()!.mutedText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                // Benefits list
                ...bulletItems.asMap().entries.map((entry) {
                  final isLast = entry.key == bulletItems.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: _buildBenefitItem(context, entry.value),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
          BottomSheetPrimaryActionBar(
            label: primaryButtonText,
            onPressed: onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
