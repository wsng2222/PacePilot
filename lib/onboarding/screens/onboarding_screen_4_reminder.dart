import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/workout_reminder_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/workout_reminder_time_picker_sheet.dart';
import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

class OnboardingScreen4Reminder extends StatefulWidget {
  final VoidCallback onNext;

  const OnboardingScreen4Reminder({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingScreen4Reminder> createState() =>
      _OnboardingScreen4ReminderState();
}

class _OnboardingScreen4ReminderState extends State<OnboardingScreen4Reminder> {
  final List<int> _selectedWeekdays = [1, 3, 5]; // Default: Mon, Wed, Fri
  TimeOfDay _selectedTime =
      const TimeOfDay(hour: 7, minute: 30); // Default: 07:30 AM
  bool _isScheduling = false;

  void _toggleWeekday(int day) {
    setState(() {
      if (_selectedWeekdays.contains(day)) {
        _selectedWeekdays.remove(day);
      } else {
        _selectedWeekdays.add(day);
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showWorkoutReminderTimePickerSheet(
      context: context,
      initialTime: _selectedTime,
    );
    if (!mounted || picked == null || picked == _selectedTime) return;
    setState(() => _selectedTime = picked);
  }

  Future<void> _saveAndNext() async {
    if (_isScheduling) return;
    final locale = Localizations.localeOf(context).languageCode;
    setState(() => _isScheduling = true);

    try {
      // 1. Request notification permissions
      await WorkoutReminderService.instance.requestPermissions();

      // 2. Sync reminder schedule if days are selected
      await WorkoutReminderService.instance.syncSchedule(
        enabled: _selectedWeekdays.isNotEmpty,
        weekdays: _selectedWeekdays,
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        languageCode: locale,
      );
    } catch (e) {
      debugPrint('Failed to save workout reminder: $e');
    } finally {
      setState(() => _isScheduling = false);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = OnboardingStrings.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizedWeekdays = MaterialLocalizations.of(context).narrowWeekdays;
    final weekdayNames = [
      ...localizedWeekdays.skip(1),
      localizedWeekdays.first,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 60),
                OnboardingRichTitle(spans: s.reminderTitleSpans()),
                const SizedBox(height: 18),
                Text(
                  s.reminderBody(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 1.45,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 40),

                // Reminder Settings Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius:
                        BorderRadius.circular(OnboardingTheme.radiusLarge),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3C3C3C)
                          : const Color(0xFFE5E5EA),
                      width: 0.8,
                    ),
                    boxShadow: [OnboardingTheme.mediumShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.reminderDaysLabel(),
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Weekday selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final dayValue = index + 1;
                          final isSelected =
                              _selectedWeekdays.contains(dayValue);
                          return GestureDetector(
                            onTap: () => _toggleWeekday(dayValue),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? OnboardingTheme.primaryRed
                                    : (isDark
                                        ? const Color(0xFF1C1C1E)
                                        : const Color(0xFFF2F2F7)),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  weekdayNames[index],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        s.reminderTimeLabel(),
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Time button
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1C1C1E)
                                : const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(
                                OnboardingTheme.radiusMedium),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTime.format(context),
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const Icon(
                                Icons.access_time_filled,
                                color: OnboardingTheme.primaryRed,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: OnboardingTheme.ctaHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnboardingTheme.primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.buttonRadius),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _saveAndNext,
                    child: _isScheduling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            s.ctaSetReminder(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.onNext,
                  child: Text(
                    s.ctaSkipReminder(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
