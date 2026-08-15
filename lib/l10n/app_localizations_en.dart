// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Workout Screen Size';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Enlarges key workout numbers and the timer.';

  @override
  String get workoutDisplaySizeStandard => 'Default';

  @override
  String get workoutDisplaySizeLarge => 'Large';

  @override
  String get workoutDisplaySizeExtraLarge => 'Largest';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get system => 'System';

  @override
  String get voiceGuide => 'Voice Guide';

  @override
  String get audioNavigator => 'Audio Navigator';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get unitSetting => 'Units';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Appearance';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get smartwatchSync => 'Smartwatch Sync';

  @override
  String get connectSmartwatch => 'Connect to smartwatch';

  @override
  String get connect => 'Connect';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get translationComingSoon =>
      'Translation will be available in a future update.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get delete => 'Delete';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get start => 'Start';

  @override
  String get editRoutine => 'Edit Routine';

  @override
  String get routineEdit => 'Routine Edit';

  @override
  String get name => 'Name';

  @override
  String get unnamedRoutine => 'Unnamed Routine';

  @override
  String get difficulty => 'Difficulty';

  @override
  String difficultyColon(String difficulty) {
    return 'Difficulty : $difficulty';
  }

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get interval => 'Interval';

  @override
  String get addInterval => 'Add Interval';

  @override
  String get quickTools => 'Quick Tools';

  @override
  String get addDefault => 'Add Default';

  @override
  String get duplicateLast => 'Copy Last';

  @override
  String get repeatPattern => 'Repeat Pattern';

  @override
  String get reorderIntervals => 'Reorder';

  @override
  String get reorderMode => 'Reorder Mode';

  @override
  String get reorderModeHint => 'Press and hold a card to move it into place.';

  @override
  String get patternLength => 'Pattern Size';

  @override
  String get repeatCount => 'Copies';

  @override
  String get noIntervals => 'No intervals';

  @override
  String get addIntervalPrompt => 'Add an interval';

  @override
  String get intervalEdit => 'Interval Edit';

  @override
  String get timeMinutes => 'Time (minutes)';

  @override
  String get duration => 'Duration';

  @override
  String get speed => 'Speed';

  @override
  String get speedKmh => 'Speed (km/h)';

  @override
  String get incline => 'Incline';

  @override
  String get level => 'Level';

  @override
  String levelColon(String level) {
    return 'Level $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPM shows how many times your pedals turn in one minute. A higher RPM means you are pedaling with a faster cadence.';

  @override
  String get resistance => 'Resistance';

  @override
  String get resistanceLevel => 'Resistance (Level)';

  @override
  String resistanceColon(String resistance) {
    return 'Resistance $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (steps/min)';

  @override
  String get saved => 'Saved';

  @override
  String get deleted => 'Deleted';

  @override
  String get deleteRoutineTitle => 'Delete Routine';

  @override
  String get deleteRoutineMessage =>
      'Are you sure you want to delete this routine? This cannot be undone.';

  @override
  String get deleteError => 'An error occurred while deleting';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get nameMaxLength => 'Name must be 50 characters or less';

  @override
  String get minIntervalsRequired => 'At least one interval is required';

  @override
  String get intervalMinDuration =>
      'Interval duration must be at least 1 second';

  @override
  String get intervalMaxDuration =>
      'Interval duration must be at most 3 hours (10800 seconds)';

  @override
  String get speedRange => 'Speed must be greater than 0 (0.5-25.0 km/h)';

  @override
  String get inclineRange => 'Incline must be in range 0-15.0';

  @override
  String get rpmRange => 'RPM must be in range 30-200';

  @override
  String get resistanceRange => 'Resistance must be in range 1-20';

  @override
  String get levelRange => 'Level must be in range 1-20';

  @override
  String get spmRange => 'SPM must be in range 50-200';

  @override
  String get noRoutinesSaved => 'No routines saved';

  @override
  String get tapToCreate => 'Tap to create';

  @override
  String get tapButtonToCreate => 'Tap the button to create';

  @override
  String get premiumRoutineSettings => 'Premium Routine Settings';

  @override
  String get viewMembership => 'See Premium';

  @override
  String get freeLimitTitle => '2 free routines';

  @override
  String get freeLimitMessage => 'Go Premium for unlimited routines';

  @override
  String get treadmill => 'Treadmill';

  @override
  String get cycle => 'Cycle';

  @override
  String get stairmaster => 'Stairmaster';

  @override
  String get selectLanguage => 'Languages';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectDifficulty => 'Select Difficulty';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get endWorkout => 'End Workout';

  @override
  String get endWorkoutConfirm => 'Do you want to end the workout?';

  @override
  String get end => 'End';

  @override
  String get share => 'Share';

  @override
  String get rotate => 'Rotate';

  @override
  String get paused => 'PAUSED';

  @override
  String get pausedTitle => 'Paused';

  @override
  String get pausedSubtitle => 'You can continue or end the workout';

  @override
  String get endWorkoutConfirmationMessage =>
      'If you end now, the current workout will finish and you will move to the summary screen.';

  @override
  String get workoutComplete => 'Workout Complete';

  @override
  String get backgroundIntervalNotificationTitle => 'New interval';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Alerts when screen is off';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Preparing';

  @override
  String get liveActivityInProgress => 'Workout in progress';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Interval $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'For $duration';
  }

  @override
  String get totalWorkoutTime => 'Total Time';

  @override
  String get totalDistance => 'Total distance';

  @override
  String get totalTime => 'Total Time';

  @override
  String get averageRpm => 'Average RPM';

  @override
  String get averageLevel => 'Average Level';

  @override
  String get holdToStop => 'Hold to Stop';

  @override
  String get continueWorkout => 'Continue';

  @override
  String get endWorkoutQuestion => 'Do you want to end the workout?';

  @override
  String get workoutPaused => 'Workout has been paused';

  @override
  String get lvlIncline => 'Incline';

  @override
  String get lvlResistance => 'Lvl Resistance';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String get purchase => 'Purchase';

  @override
  String get later => 'Later';

  @override
  String get premiumActivated => 'Premium has been activated';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Cycle, Stairmaster feature';

  @override
  String get benefitVoiceGuide => 'Session voice guide feature';

  @override
  String get benefitUnlimitedRoutines => 'Unlimited routine saves';

  @override
  String get noAds => 'No Ads';

  @override
  String get benefitFutureFeatures => 'Unlimited access to future features';

  @override
  String get voiceGuideBenefit1 => 'Voice guidance during workout';

  @override
  String get voiceGuideBenefit2 => 'Automatic session transition announcements';

  @override
  String get voiceGuideBenefit3 => 'Hands-free routine focus';

  @override
  String get routineLimitBenefit1 => 'Unlimited routine saves';

  @override
  String get routineLimitBenefit2 => 'Save routines for multiple goals';

  @override
  String get routineLimitBenefit3 =>
      'Use all machine types (treadmill/cycle/stairmaster)';

  @override
  String get premium_benefit_1 => '<red>Bike & StairMaster</red> workouts';

  @override
  String get premium_benefit_2 => 'Session <red>voice guide</red>';

  @override
  String get premium_benefit_3 => '<red>Unlimited</red> routine saves';

  @override
  String get premium_benefit_4 =>
      '<red>Unlimited access</red> to future features';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/month';
  }

  @override
  String get premiumSubheadline =>
      'Unlock voice guidance, bike & stairmaster workouts, and unlimited routines';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get lifetime => 'Lifetime';

  @override
  String get freeTrial7Days => '7-day free trial';

  @override
  String get perMonth => '/month';

  @override
  String get perYear => '/year';

  @override
  String get oneTime => 'One time';

  @override
  String savePercent(String percent) {
    return 'Save $percent';
  }

  @override
  String get bestValue => 'Best Value';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get autoRenewableSubscription => 'Auto-renews';

  @override
  String get terms => 'Terms';

  @override
  String get privacy => 'Privacy';

  @override
  String get restore => 'Restore';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Routine';

  @override
  String get settingsTab => 'Settings';

  @override
  String get myTab => 'My';

  @override
  String get close => 'Close';

  @override
  String get premiumFeature => 'Premium only';

  @override
  String get usePremiumTest => 'Test Premium';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$month/$day/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Preview & Start';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get viewRecommendedRoutines => 'Picks →';

  @override
  String get recommendedRoutinesTreadmill => 'Treadmill picks';

  @override
  String get recommendedRoutinesCycle => 'Bike picks';

  @override
  String get recommendedRoutinesStairmaster => 'Stairmaster picks';

  @override
  String get alreadySaved => 'Already saved';

  @override
  String get routineSaved => 'Routine saved';

  @override
  String get checkRoutine => 'Preview';

  @override
  String get saveRoutine => 'Save Routine';

  @override
  String get routineAlreadySaved => 'Routine already saved';

  @override
  String get noTemplatesFound => 'No templates found';

  @override
  String get avg => 'Avg';

  @override
  String get avgRpm => 'Avg RPM';

  @override
  String get avgLevel => 'Avg level';

  @override
  String get templateTreadmillBeginner1Title => 'Beginner Treadmill 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 walk and run after 3 min warm-up';

  @override
  String get templateTreadmillBeginner2Title =>
      'Beginner Treadmill 2 (Incline)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Incline walking with low joint impact';

  @override
  String get templateTreadmillIntermediate1Title => 'Intermediate Treadmill 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      '1:1 running interval for fat burning';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Intermediate Treadmill 2 (Speed)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Pyramid speed building run';

  @override
  String get templateTreadmillAdvanced1Title => 'Advanced Treadmill 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'High-intensity cardio blast interval';

  @override
  String get templateTreadmillAdvanced2Title => 'Advanced Treadmill 2 (Sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Short high-intensity sprint repeats';

  @override
  String get templateCycleBeginner1Title => 'Beginner Cycle 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Pedaling intro by adjusting RPM';

  @override
  String get templateCycleBeginner2Title => 'Beginner Cycle 2 (Steady)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Constant resistance endurance ride';

  @override
  String get templateCycleIntermediate1Title => 'Intermediate Cycle 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 min high speed / 1 min recovery spin';

  @override
  String get templateCycleIntermediate2Title => 'Intermediate Cycle 2 (Hill)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'High resistance lower body hill climb';

  @override
  String get templateCycleAdvanced1Title => 'Advanced Cycle 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      '30s high resistance power intervals';

  @override
  String get templateCycleAdvanced2Title => 'Advanced Cycle 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      '20s/10s Tabata circuit for fat burning';

  @override
  String get templateStairmasterBeginner1Title => 'Beginner Stairmaster 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Safe adaptation pace stair walking';

  @override
  String get templateStairmasterBeginner2Title =>
      'Beginner Stairmaster 2 (Steady)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Steady tempo aerobic stair climbing';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Intermediate Stairmaster 1 (Climb)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 min climb / 1 min recovery glute sculpt';

  @override
  String get templateStairmasterIntermediate2Title =>
      'Intermediate Stairmaster 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Alternating fast and slow tempo intervals';

  @override
  String get templateStairmasterAdvanced1Title => 'Advanced Stairmaster 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'High-intensity 2 min block training';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Advanced Stairmaster 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s high speed climb / 60s recovery intervals';

  @override
  String get historyTab => 'History';

  @override
  String get calendarTab => 'Calendar';

  @override
  String get weightTab => 'Weight';

  @override
  String get bike => 'Bike';

  @override
  String get thisWeek => 'This week';

  @override
  String get trend => 'Trend';

  @override
  String get timeframe7D => '7D';

  @override
  String get timeframe30D => '30D';

  @override
  String get timeframe90D => '90D';

  @override
  String get timeframeAll => 'ALL';

  @override
  String get history => 'History';

  @override
  String get seeAll => 'See all';

  @override
  String get weightEntryDeleted => 'Weight entry deleted';

  @override
  String get weightUpdated => 'Weight updated';

  @override
  String get editWeight => 'Edit weight';

  @override
  String get recordWeight => 'Log weight';

  @override
  String get quickAdjust => 'Quick edit';

  @override
  String get goalWeightSet => 'Goal weight set';

  @override
  String get goalWeightRemoved => 'Goal weight removed';

  @override
  String get goalAchieved => 'Goal achieved!';

  @override
  String get goalMatchesCurrentWeight => 'Goal matches current weight';

  @override
  String get setGoal => 'Set target';

  @override
  String get suggested => 'Suggested';

  @override
  String get removeGoal => 'Clear target';

  @override
  String get addOneMoreRecordToSeeTrend => 'Add 1 more weigh-in to see trends';

  @override
  String get noWeightRecorded => 'No weight recorded yet';

  @override
  String get startTrackingYourWeight => 'Log weight to track progress';

  @override
  String get treadmillSession => 'Treadmill Session';

  @override
  String get bikeSession => 'Bike Session';

  @override
  String get stairmasterSession => 'Stairmaster Session';

  @override
  String get treadmillWorkout => 'Treadmill Workout';

  @override
  String get bikeWorkout => 'Bike Workout';

  @override
  String get stairmasterWorkout => 'Stairmaster Workout';

  @override
  String get startAWorkoutToSeeItHere => 'Your workouts will appear here';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get sessions => 'Sessions';

  @override
  String get distance => 'Distance';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get startYourFirstWorkout =>
      'Start your first workout to see your history here';

  @override
  String get goToRoutines => 'Go to Routines';

  @override
  String get weightRecorded => 'Weight recorded';

  @override
  String get workout => 'workout';

  @override
  String get workouts => 'workouts';

  @override
  String get goal => 'Goal';

  @override
  String get toGo => 'to go';

  @override
  String get over => 'over';

  @override
  String get last => 'Last';

  @override
  String get newLabel => 'New';

  @override
  String youNeed(String amount, String goal) {
    return 'You need $amount to reach $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'You need +$amount to reach $goal';
  }

  @override
  String get current => 'Current';

  @override
  String get premiumHeadline => 'Same 30 minutes, different results';

  @override
  String get premiumSubheadlineNew =>
      'Don\'t just run, exercise the fat-burning way';

  @override
  String get mostPopular => 'Most Popular';

  @override
  String dailyPrice(int price) {
    return '$price per day';
  }

  @override
  String get benefitVoiceCoaching => 'Premium Voice Coaching System';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Interval alerts while using other apps';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Full Support for All Cardio Equipment';

  @override
  String get benefitUnlimitedRoutinesNew => 'Unlimited Routine Library';

  @override
  String get benefitWeightFeature => 'Smart Weight Tracking & Analysis';

  @override
  String get benefitNoAdsFocus => 'Ad-Free Premium Experience';

  @override
  String get benefitFutureFeaturesNew => 'All future premium features included';

  @override
  String get mostChosen => 'Top pick';

  @override
  String get canChangeAnytime => 'Change anytime';

  @override
  String get startPremium => 'Go Premium';

  @override
  String get cancelAnytimeKeepAccess => 'Cancel anytime, keep access';

  @override
  String workoutDays(String count) {
    return 'Workout days: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Rest days: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Reminders';

  @override
  String get workoutReminderOff => 'Off';

  @override
  String get workoutReminderEveryDay => 'Every day';

  @override
  String get workoutReminderSelectTime => 'Select time';

  @override
  String get workoutReminderPermissionRequired =>
      'Notification permission is required.';

  @override
  String get workoutReminderTimeLabel => 'Time';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Try this interval workout routine on Valcue!\n\nRoutine: $routineName\n\nCopy or tap the link to import it:\n$shareLink';
  }

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get invalidQrCode => 'This QR code isn\'t a Valcue routine.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get placeQrInside => 'Place the QR code inside the target area.';

  @override
  String get customRoutineBuilder => 'Custom Routine Builder';

  @override
  String get customRoutineGenerating => 'Designing your custom routine...';

  @override
  String get customRoutineLoadingTarget =>
      'Setting your cardio intensity target...';

  @override
  String get customRoutineLoadingStructure =>
      'Building warm-up and cool-down intervals...';

  @override
  String get customRoutineLoadingPace => 'Calculating your interval pace...';

  @override
  String get customRoutineLoadingVoice => 'Preparing voice coaching...';

  @override
  String get generationComplete => 'Generation Complete!';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get caloriesEstimateByWeight =>
      'Calories are estimates based on the entered weight.';

  @override
  String get commonBack => 'Back';

  @override
  String get adjustGoals => 'Adjust goals';

  @override
  String get targetCalories => 'Target Calories';

  @override
  String get targetStairs => 'Target Floors';

  @override
  String get targetDistance => 'Target Distance';

  @override
  String get currentWeight => 'Current weight';

  @override
  String get includeIncline => 'Include Incline';

  @override
  String get includeWarmupCooldown => 'Include Warmup & Cooldown';

  @override
  String get generateCustomRoutine => 'Generate Custom Routine';

  @override
  String durationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String floorCount(String count) {
    return 'Floors: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Custom Run $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Custom Cycle $distance $distanceUnit ($calories kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Build-Up Run $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Pyramid Run $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Build-Up Cycle $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Pyramid Cycle $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Custom Stairs ${floors}F ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Your custom routine is ready. Aim for about $calories calories!';
  }

  @override
  String get weightDeleteTitle => 'Delete Entry';

  @override
  String get weightDeleteConfirm =>
      'Are you sure you want to delete this weight entry?';

  @override
  String get achievementUnlocked => '🏆 Achievement Unlocked!';

  @override
  String get achievementCongratulations =>
      'Congratulations! You earned a new badge!';

  @override
  String get awesome => 'Awesome!';

  @override
  String get shareCardDefault => '9:14 (Default)';

  @override
  String get shareCardStory => '9:16 (Story)';

  @override
  String get shareCardSquare => '1:1 (Square)';

  @override
  String get customizeShareCard => 'Customize Share Card';

  @override
  String get shareRoutine => 'Share Routine';

  @override
  String get shareViaQrCode => 'Share via QR Code';

  @override
  String get routineLimitReached => 'Routine Limit Reached';

  @override
  String get routineLimitMessage =>
      'Free users can save up to 2 treadmill routines. Upgrade to Premium or delete an existing routine.';

  @override
  String get importSharedRoutine => 'Import Shared Routine';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'A routine was detected in the scanned QR code.\n\n• Name: $name\n• Difficulty: $difficulty\n• Intervals: $count\n\nWould you like to save this routine to your library?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'A shared routine was detected in your clipboard.\n\n• Name: $name\n• Difficulty: $difficulty\n• Intervals: $count\n\nWould you like to save this routine to your library?';
  }

  @override
  String importRoutineSuccess(String name) {
    return 'Successfully imported \'$name\'!';
  }

  @override
  String get importAction => 'Import';

  @override
  String get addRoutineOption => 'Choose How to Add a Routine';

  @override
  String get createCustomRoutine => 'Create Custom Routine';

  @override
  String get importFromClipboard => 'Import from Clipboard';

  @override
  String get countdownTiming => 'Countdown Timing';

  @override
  String get noAnnouncements => 'No announcements';

  @override
  String secondsShort(String seconds) {
    return '${seconds}s';
  }

  @override
  String get selectCountdownTimings => 'Select Countdown Timings';

  @override
  String get countdownTimingMessage =>
      'Select when to hear remaining-time announcements before intervals change.';

  @override
  String secondsLeft(String seconds) {
    return '${seconds}s left';
  }

  @override
  String get qrShareInstruction =>
      'Scan this QR code from another Valcue app\nto import this routine instantly.';

  @override
  String get quickStart => 'Quick start';

  @override
  String get sessionRepeatBlock => 'Session Repeat Block';

  @override
  String repeatTimes(String count) {
    return 'Repeats: $count';
  }

  @override
  String get addRepeatBlock => 'Add Repeat Block';

  @override
  String get unableToShareWorkout => 'Unable to share workout';

  @override
  String get unableToOpenPrivacyPolicy => 'Unable to open privacy policy';

  @override
  String get unableToOpenLink => 'Unable to open link';

  @override
  String get less => 'Less';

  @override
  String get more => 'More';

  @override
  String inclineValue(String value) {
    return 'Incline $value%';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return 'Next: $value';
  }

  @override
  String get weightCalendar => 'Weight calendar';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText intervals · $difficulty',
      one: '$duration · $countText interval · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Goal $goalWeight • Goal achieved!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Goal $goalWeight • $difference to go';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Goal $goalWeight • $difference over';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Avg $value km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Avg $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Avg $value RPM';
  }

  @override
  String averageLevelValue(String value) {
    return 'Avg level $value';
  }

  @override
  String get purchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get restoreSuccess => 'Your purchases have been restored.';

  @override
  String get restoreNothingToRestore => 'No previous purchases were found.';

  @override
  String get plansUnavailable =>
      'Unable to load plans. Please try again later.';
}
