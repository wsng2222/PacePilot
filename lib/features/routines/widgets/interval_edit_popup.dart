import 'package:flutter/cupertino.dart' hide Interval;
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../models/interval.dart';
import '../models/machine_type.dart';
import '../../../app_settings/app_settings_provider.dart';
import 'dart:ui' as ui;

enum IntervalEditField {
  duration,
  speed,
  incline,
  rpm,
  resistance,
  level,
}

class IntervalEditPopup {
  static void show(
    BuildContext context, {
    required Interval interval,
    required MachineType machineType,
    required IntervalEditField field,
    required Function(Interval) onSave,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _IntervalEditPopupContent(
        interval: interval,
        machineType: machineType,
        field: field,
        onSave: onSave,
      ),
    );
  }
}

class _IntervalEditPopupContent extends StatefulWidget {
  final Interval interval;
  final MachineType machineType;
  final IntervalEditField field;
  final Function(Interval) onSave;

  const _IntervalEditPopupContent({
    required this.interval,
    required this.machineType,
    required this.field,
    required this.onSave,
  });

  @override
  State<_IntervalEditPopupContent> createState() =>
      _IntervalEditPopupContentState();
}

class _IntervalEditPopupContentState extends State<_IntervalEditPopupContent> {
  late int _selectedValue;
  late double _selectedDoubleValue;
  late double _pickerHeight;

  @override
  void initState() {
    super.initState();
    switch (widget.field) {
      case IntervalEditField.duration:
        _selectedValue = widget.interval.durationSeconds ~/ 60; // minutes
        break;
      case IntervalEditField.speed:
        final settingsProvider =
            Provider.of<AppSettingsProvider>(context, listen: false);
        final speedKmh = widget.interval.speedKmh ?? 5.0;
        // Convert to display unit if needed
        _selectedDoubleValue = settingsProvider.measurement == 'mph'
            ? (speedKmh * 0.621371)
            : speedKmh;
        break;
      case IntervalEditField.incline:
        _selectedDoubleValue = widget.interval.grade ?? 0.0;
        break;
      case IntervalEditField.rpm:
        // Round to nearest 5-step value
        final currentRpm = widget.interval.rpm ?? 60;
        _selectedValue = ((currentRpm / 5).round() * 5).clamp(30, 200);
        break;
      case IntervalEditField.resistance:
        _selectedValue = widget.interval.resistance ?? 5;
        break;
      case IntervalEditField.level:
        _selectedValue = widget.interval.level ?? 5;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Adaptive picker height: between 240 and 360, ~42% of screen height
    _pickerHeight = (screenHeight * 0.42).clamp(240.0, 360.0);

    return CupertinoActionSheet(
      actions: [
        SizedBox(
          height: _pickerHeight + 64, // header (~64) + picker height
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          minimumSize: const Size(0, 0),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _getFieldLabel(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _save,
                          minimumSize: const Size(0, 0),
                          child: Text(
                            AppLocalizations.of(context)!.done,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _pickerHeight,
                child: _buildPicker(_pickerHeight),
              ),
            ],
          ),
        ),
      ],
      cancelButton: const SizedBox.shrink(),
    );
  }

  void _save() {
    Interval updatedInterval;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    switch (widget.machineType) {
      case MachineType.treadmill:
        double speedKmh = widget.interval.speedKmh ?? 5.0;
        double grade = widget.interval.grade ?? 0.0;
        int durationSeconds = widget.interval.durationSeconds;

        if (widget.field == IntervalEditField.duration) {
          durationSeconds = _selectedValue * 60;
        } else if (widget.field == IntervalEditField.speed) {
          // Convert back to km/h if needed
          speedKmh = settingsProvider.measurement == 'mph'
              ? (_selectedDoubleValue / 0.621371)
              : _selectedDoubleValue;
        } else if (widget.field == IntervalEditField.incline) {
          grade = _selectedDoubleValue;
        }

        updatedInterval = Interval.treadmill(
          id: widget.interval.id,
          durationSeconds: durationSeconds,
          speedKmh: speedKmh.clamp(0.0, 30.0),
          grade: grade.clamp(0.0, 20.0),
        );
        break;
      case MachineType.cycle:
        int rpm = widget.interval.rpm ?? 60;
        int resistance = widget.interval.resistance ?? 5;
        int durationSeconds = widget.interval.durationSeconds;

        if (widget.field == IntervalEditField.duration) {
          durationSeconds = _selectedValue * 60;
        } else if (widget.field == IntervalEditField.rpm) {
          // Ensure RPM is in 5-step increments
          rpm = ((_selectedValue / 5).round() * 5).clamp(30, 200);
        } else if (widget.field == IntervalEditField.resistance) {
          resistance = _selectedValue;
        }

        updatedInterval = Interval.cycle(
          id: widget.interval.id,
          durationSeconds: durationSeconds,
          rpm: rpm.clamp(30, 200),
          resistance: resistance.clamp(1, 20),
        );
        break;
      case MachineType.stairmaster:
        int level = widget.interval.level ?? 5;
        int durationSeconds = widget.interval.durationSeconds;

        if (widget.field == IntervalEditField.duration) {
          durationSeconds = _selectedValue * 60;
        } else if (widget.field == IntervalEditField.level) {
          level = _selectedValue;
        }

        updatedInterval = Interval.stairmaster(
          id: widget.interval.id,
          durationSeconds: durationSeconds,
          level: level.clamp(1, 20),
        );
        break;
    }

    widget.onSave(updatedInterval);
    Navigator.pop(context);
  }

  Widget _buildPicker(double height) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    switch (widget.field) {
      case IntervalEditField.duration:
        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedValue.clamp(1, 999) - 1,
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedValue = index + 1;
              });
            },
            children: List.generate(999, (index) {
              final minutes = index + 1;
              return Center(
                child: Text(
                  '$minutes ${l10n.timeMinutes.split('(')[0].trim()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }),
          ),
        );

      case IntervalEditField.speed:
        final isMph = settingsProvider.measurement == 'mph';
        final minSpeed = isMph ? 0.5 : 0.5;
        final maxSpeed = isMph ? 18.6 : 30.0; // ~30 km/h = ~18.6 mph
        const step = 0.1;
        final items = <double>[];
        for (double v = minSpeed; v <= maxSpeed; v += step) {
          items.add(double.parse(v.toStringAsFixed(1)));
        }
        final initialIndex = items.indexWhere(
          (v) => v >= _selectedDoubleValue,
        );

        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: initialIndex >= 0 ? initialIndex : 0,
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedDoubleValue = items[index];
              });
            },
            children: items.map((speed) {
              return Center(
                child: Text(
                  '${LocalizedFormat.decimal(context, speed)} ${isMph ? "mph" : "km/h"}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }).toList(),
          ),
        );

      case IntervalEditField.incline:
        final items = <double>[];
        for (double v = 0.0; v <= 20.0; v += 0.1) {
          items.add(double.parse(v.toStringAsFixed(1)));
        }
        final initialIndex = items.indexWhere(
          (v) => v >= _selectedDoubleValue,
        );

        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: initialIndex >= 0 ? initialIndex : 0,
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedDoubleValue = items[index];
              });
            },
            children: items.map((incline) {
              return Center(
                child: Text(
                  '${LocalizedFormat.decimal(context, incline)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }).toList(),
          ),
        );

      case IntervalEditField.rpm:
        // Generate RPM values in steps of 5: 30, 35, 40, ..., 195, 200
        final rpms =
            List.generate(35, (i) => 30 + i * 5); // 30 to 200 in steps of 5
        // Find closest 5-step value to current selection
        final currentRpm = _selectedValue;
        final roundedRpm = ((currentRpm / 5).round() * 5).clamp(30, 200);
        final initialIndex = rpms.indexWhere((r) => r >= roundedRpm);

        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: initialIndex >= 0 ? initialIndex : 0,
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedValue = rpms[index];
              });
            },
            children: rpms.map((rpm) {
              return Center(
                child: Text(
                  '$rpm ${l10n.rpm}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }).toList(),
          ),
        );

      case IntervalEditField.resistance:
        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: (_selectedValue - 1).clamp(0, 19),
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedValue = index + 1;
              });
            },
            children: List.generate(20, (index) {
              final level = index + 1;
              return Center(
                child: Text(
                  l10n.levelColon(
                    LocalizedFormat.decimal(
                      context,
                      level,
                      decimalDigits: 0,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }),
          ),
        );

      case IntervalEditField.level:
        return SizedBox(
          height: height,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: (_selectedValue - 1).clamp(0, 19),
            ),
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedValue = index + 1;
              });
            },
            children: List.generate(20, (index) {
              final level = index + 1;
              return Center(
                child: Text(
                  l10n.levelColon(
                    LocalizedFormat.decimal(
                      context,
                      level,
                      decimalDigits: 0,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              );
            }),
          ),
        );
    }
  }

  String _getFieldLabel() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.field) {
      case IntervalEditField.duration:
        return l10n.timeMinutes.split('(')[0].trim();
      case IntervalEditField.speed:
        return l10n.speed;
      case IntervalEditField.incline:
        return l10n.incline;
      case IntervalEditField.rpm:
        return l10n.rpm;
      case IntervalEditField.resistance:
        return l10n.level;
      case IntervalEditField.level:
        return l10n.level;
    }
  }
}
