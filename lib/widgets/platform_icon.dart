import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

/// Returns [cupertino] on iOS and [material] everywhere else. Use this where
/// an API takes a raw [IconData] (e.g. [AppDialog.icon]) rather than a widget.
IconData platformIconData({
  required IconData cupertino,
  required IconData material,
}) {
  return PlatformInfo.isIOS ? cupertino : material;
}

/// Renders [cupertino] on iOS and [material] everywhere else, matching the
/// platform-aware icon pattern already used by the app's bottom tab bar.
class PlatformIcon extends StatelessWidget {
  final IconData cupertino;
  final IconData material;
  final double? size;
  final Color? color;

  const PlatformIcon({
    super.key,
    required this.cupertino,
    required this.material,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      PlatformInfo.isIOS ? cupertino : material,
      size: size,
      color: color,
    );
  }
}
