import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valcue/utils/responsive.dart';

/// A crisp modern pill-shaped bottom navigation bar.
/// Features a solid white pill with a gray inset capsule for the selected item.
class LiquidGlassPillNavBar extends StatelessWidget {
  /// The current selected index (0-based).
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int> onTap;

  /// List of navigation items. Each item should have an icon and label.
  final List<LiquidGlassNavItem> items;

  /// Maximum width for the navigation bar (default: 640, centers on larger screens).
  final double maxWidth;

  /// Height of the navigation bar (default: 70).
  final double height;

  /// Bottom margin from safe area (default: 10).
  final double bottomMargin;

  const LiquidGlassPillNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.maxWidth = 300.0, // Reduced for tighter layout
    this.height = 70.0,
    this.bottomMargin = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isReducedMotion = mediaQuery.disableAnimations;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // We control spacing ourselves: if device has a bottom inset (iOS home
    // indicator), position the bar just above it with a small extra gap.
    final bottomInset = mediaQuery.padding.bottom;
    const desiredGap = 10.0; // base visual gap under the bar

    // Responsive height based on screen size
    final responsiveHeight = ResponsiveUtils.getNavbarHeight(context);

    // Separate last item (My tab) from others
    final mainItems = items.length > 3 ? items.sublist(0, 3) : items;
    final lastItem = items.length > 3 ? items.last : null;
    final mainItemCount = mainItems.length;

    // Check if last item is selected
    final isLastItemSelected =
        lastItem != null && currentIndex == items.length - 1;

    // Animation duration (240ms, reduced motion: 0-50ms)
    final animationDuration = isReducedMotion
        ? const Duration(milliseconds: 0)
        : const Duration(milliseconds: 240);

    // Outer pill padding - reduced to eliminate empty space around selected tab
    const horizontalPadding = 1.0; // Reduced from 8.0
    const verticalPadding = 8.0;
    const lensInset = 4.0; // Reduced from 8.0 to make lens taller
    const itemSpacing = 8.0; // Spacing between circular button and pill

    // Slightly reduce pill size
    final pillHeight = responsiveHeight * 0.92; // Reduce pill by 8%

    return Container(
      // Place the bar closer to the bottom: half the previous gap.
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom:
            ((bottomInset > 0 ? bottomInset + desiredGap : desiredGap) * 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main pill with first 3 items
          Flexible(
            flex: 3,
            child: Container(
              height: pillHeight,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.65, // Limit pill width to 70% of screen
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final availableHeight = constraints.maxHeight;
                  final textDirection = Directionality.of(context);

                  // Calculate item width with tighter spacing
                  const totalWidthFactor = 0.95;
                  final totalItemWidth = availableWidth * totalWidthFactor;
                  final itemWidth = totalItemWidth / mainItemCount;
                  final startOffset = (availableWidth - totalItemWidth) / 2;

                  // Calculate lens (selected capsule) dimensions
                  final lensHeight = pillHeight - (lensInset * 2);
                  final lensWidth =
                      itemWidth - 0; // Reduced from 8 to make lens wider
                  final lensBorderRadius = lensHeight / 2;

                  // Calculate lens position: centered within the selected item's slot
                  // Adjust index if last item is selected (it's not in the pill)
                  final adjustedIndex = isLastItemSelected ? -1 : currentIndex;
                  final visualIndex =
                      adjustedIndex >= 0 && adjustedIndex < mainItemCount
                          ? (textDirection == TextDirection.rtl
                              ? (mainItemCount - 1 - adjustedIndex)
                              : adjustedIndex)
                          : -1;

                  final lensLeft = visualIndex >= 0
                      ? startOffset +
                          visualIndex * itemWidth +
                          (itemWidth - lensWidth) / 2
                      : 0.0;
                  final lensRight = visualIndex >= 0
                      ? availableWidth - lensLeft - lensWidth
                      : 0.0;
                  final lensTop = (availableHeight - lensHeight) / 2;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // INNER SELECTED CAPSULE: Gray background (bottom layer)
                      if (visualIndex >= 0)
                        AnimatedPositioned(
                          duration: animationDuration,
                          curve: Curves.easeOutBack,
                          left: textDirection == TextDirection.ltr
                              ? lensLeft
                              : null,
                          right: textDirection == TextDirection.rtl
                              ? lensRight
                              : null,
                          top: lensTop,
                          width: lensWidth,
                          height: lensHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2E)
                                  : const Color(0xFFECECEC),
                              borderRadius:
                                  BorderRadius.circular(lensBorderRadius),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.06),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 14,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // NAVIGATION ITEMS: Row with tighter spacing
                      Row(
                        children: [
                          SizedBox(width: startOffset),
                          ...List.generate(
                            mainItemCount,
                            (index) => SizedBox(
                              width: itemWidth,
                              child: _NavItem(
                                item: mainItems[index],
                                isSelected: currentIndex == index,
                                onTap: () => onTap(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // Circular "나" button on the right (if exists)
          if (lastItem != null) const SizedBox(width: itemSpacing),
          if (lastItem != null)
            _CircularNavItem(
              item: lastItem,
              isSelected: isLastItemSelected,
              onTap: () => onTap(items.length - 1),
              size: height * 0.75, // Make "나" tab smaller (75% of original)
            ),
        ],
      ),
    );
  }
}

/// Individual navigation item for the pill navbar.
class LiquidGlassNavItem {
  /// Icon to display.
  final IconData icon;

  /// Label text to display below the icon.
  final String label;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// Optional custom icon size.
  final double? iconSize;

  const LiquidGlassNavItem({
    required this.icon,
    required this.label,
    this.semanticLabel,
    this.iconSize,
  });
}

/// Internal widget for individual navigation items.
class _NavItem extends StatelessWidget {
  final LiquidGlassNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Selected: use app primary
    // Unselected: near-black/white with 0.85 alpha
    final iconColor = isSelected
        ? theme.colorScheme.primary
        : (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : Colors.black.withValues(alpha: 0.85));

    final textColor = isSelected
        ? theme.colorScheme.primary
        : (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : Colors.black.withValues(alpha: 0.85));

    return Semantics(
      label: item.semanticLabel ?? item.label,
      selected: isSelected,
      button: true,
      child: _BouncyTabItem(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 70.0,
            minWidth: 44.0, // Accessibility minimum tap target
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: item.iconSize ??
                    (isSelected ? 28.0 : 26.0), // Icon size: normal or custom
                color: iconColor,
              ),
              const SizedBox(height: 4), // Spacing between icon and label
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize:
                          isSelected ? 12.0 : 11.0, // Label font: normal size
                      fontWeight: FontWeight.w600, // Semi-bold
                      color: textColor,
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular navigation item for the last tab (My/Profile)
class _CircularNavItem extends StatelessWidget {
  final LiquidGlassNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const _CircularNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Selected: use app primary
    // Unselected: near-black/white with 0.85 alpha
    final iconColor = isSelected
        ? theme.colorScheme.primary
        : (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : Colors.black.withValues(alpha: 0.85));

    final textColor = isSelected
        ? theme.colorScheme.primary
        : (isDark
            ? Colors.white.withValues(alpha: 0.85)
            : Colors.black.withValues(alpha: 0.85));

    return Semantics(
      label: item.semanticLabel ?? item.label,
      selected: isSelected,
      button: true,
      child: _BouncyTabItem(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: item.label.isEmpty
              ? Icon(
                  item.icon,
                  size: item.iconSize ?? (isSelected ? 20.0 : 18.0),
                  color: iconColor,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: item.iconSize ??
                          (isSelected
                              ? 20.0
                              : 18.0), // Use custom iconSize if provided
                      color: iconColor,
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: isSelected
                                ? 9.0
                                : 8.5, // Smaller text for smaller button
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: -0.2,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _BouncyTabItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyTabItem({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyTabItem> createState() => _BouncyTabItemState();
}

class _BouncyTabItemState extends State<_BouncyTabItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.disableAnimations) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
