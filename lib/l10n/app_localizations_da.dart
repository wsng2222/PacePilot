// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Størrelse på træningsvisning';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Forstørrer vigtige træningstal og timeren.';

  @override
  String get workoutDisplaySizeStandard => 'Standard';

  @override
  String get workoutDisplaySizeLarge => 'Stor';

  @override
  String get workoutDisplaySizeExtraLarge => 'Maks.';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get language => 'Sprog';

  @override
  String get system => 'System';

  @override
  String get voiceGuide => 'Stemmeguide';

  @override
  String get audioNavigator => 'Lydnavigator';

  @override
  String get soundEffects => 'Lydeffekter';

  @override
  String get unitSetting => 'Enheder';

  @override
  String get kmh => 'km/t';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Udseende';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get smartwatchSync => 'Synkronisering af smartwatch';

  @override
  String get connectSmartwatch => 'Forbind til smartwatch';

  @override
  String get connect => 'Forbind';

  @override
  String get about => 'Om';

  @override
  String get adPrivacyOptions => 'Annonce-privatlivsindstillinger';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get translationComingSoon =>
      'Oversættelse bliver tilgængelig i en fremtidig opdatering.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuller';

  @override
  String get done => 'Færdig';

  @override
  String get delete => 'Slet';

  @override
  String get duplicate => 'Dupliker';

  @override
  String get save => 'Gem';

  @override
  String get edit => 'Rediger';

  @override
  String get start => 'Start';

  @override
  String get editRoutine => 'Rediger rutine';

  @override
  String get routineEdit => 'Rediger rutine';

  @override
  String get name => 'Navn';

  @override
  String get unnamedRoutine => 'Unavngiven rutine';

  @override
  String get difficulty => 'Sværhedsgrad';

  @override
  String difficultyColon(String difficulty) {
    return 'Sværhedsgrad : $difficulty';
  }

  @override
  String get easy => 'Let';

  @override
  String get medium => 'Mellem';

  @override
  String get hard => 'Hård';

  @override
  String get interval => 'Interval';

  @override
  String get addInterval => 'Tilføj interval';

  @override
  String get quickTools => 'Hurtige værktøjer';

  @override
  String get addDefault => 'Tilføj standard';

  @override
  String get duplicateLast => 'Kopiér sidste';

  @override
  String get repeatPattern => 'Gentag mønster';

  @override
  String get reorderIntervals => 'Omarranger';

  @override
  String get reorderMode => 'Omarrangeringstilstand';

  @override
  String get reorderModeHint =>
      'Tryk og hold på et kort for at flytte det til den ønskede placering.';

  @override
  String get patternLength => 'Mønsterlængde';

  @override
  String get repeatCount => 'Antal kopier';

  @override
  String get noIntervals => 'Ingen intervaller';

  @override
  String get addIntervalPrompt => 'Tilføj et interval';

  @override
  String get intervalEdit => 'Rediger interval';

  @override
  String get timeMinutes => 'Tid (minutter)';

  @override
  String get duration => 'Varighed';

  @override
  String get speed => 'Hastighed';

  @override
  String get speedKmh => 'Hastighed (km/t)';

  @override
  String get incline => 'Hældning';

  @override
  String get level => 'Niveau';

  @override
  String levelColon(String level) {
    return 'Niveau $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPM viser, hvor mange gange dine pedaler drejer rundt på ét minut. En højere RPM betyder, at du træder med en hurtigere kadence.';

  @override
  String get resistance => 'Modstand';

  @override
  String get resistanceLevel => 'Modstand (niveau)';

  @override
  String resistanceColon(String resistance) {
    return 'Modstand $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (trin/min)';

  @override
  String get saved => 'Gemt';

  @override
  String get deleted => 'Slettet';

  @override
  String get deleteRoutineTitle => 'Slet rutine';

  @override
  String get deleteRoutineMessage =>
      'Er du sikker på, at du vil slette denne rutine? Dette kan ikke fortrydes.';

  @override
  String get deleteError => 'Der opstod en fejl under sletning';

  @override
  String get nameRequired => 'Indtast et navn';

  @override
  String get nameMaxLength => 'Navnet skal være 50 tegn eller mindre';

  @override
  String get minIntervalsRequired => 'Mindst ét interval er påkrævet';

  @override
  String get intervalMinDuration =>
      'Intervalvarighed skal være mindst 1 sekund';

  @override
  String get intervalMaxDuration =>
      'Intervalvarighed må højst være 3 timer (10800 sekunder)';

  @override
  String get speedRange => 'Hastighed skal være større end 0 (0.5-25.0 km/t)';

  @override
  String get inclineRange => 'Hældning skal være i intervallet 0-15.0';

  @override
  String get rpmRange => 'RPM skal være i intervallet 30-200';

  @override
  String get resistanceRange => 'Modstand skal være i intervallet 1-20';

  @override
  String get levelRange => 'Niveau skal være i intervallet 1-20';

  @override
  String get spmRange => 'SPM skal være i intervallet 50-200';

  @override
  String get noRoutinesSaved => 'Ingen rutiner gemt';

  @override
  String get tapToCreate => 'Tryk for at oprette';

  @override
  String get tapButtonToCreate => 'Tryk på knappen for at oprette';

  @override
  String get premiumRoutineSettings => 'Premium rutineindstillinger';

  @override
  String get viewMembership => 'Se Premium';

  @override
  String get freeLimitTitle => '2 gratis rutiner';

  @override
  String get freeLimitMessage => 'Få ubegrænsede rutiner med Premium';

  @override
  String get treadmill => 'Løbebånd';

  @override
  String get cycle => 'Cykel';

  @override
  String get stairmaster => 'Stairmaster';

  @override
  String get selectLanguage => 'Sprog';

  @override
  String get selectTheme => 'Vælg tema';

  @override
  String get selectDifficulty => 'Vælg sværhedsgrad';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Genoptag';

  @override
  String get endWorkout => 'Afslut træning';

  @override
  String get endWorkoutConfirm => 'Vil du afslutte træningen?';

  @override
  String get end => 'Afslut';

  @override
  String get share => 'Del';

  @override
  String get rotate => 'Roter';

  @override
  String get paused => 'PAUSET';

  @override
  String get pausedTitle => 'Pauset';

  @override
  String get pausedSubtitle => 'Du kan fortsætte eller afslutte træningen';

  @override
  String get endWorkoutConfirmationMessage =>
      'Hvis du afslutter nu, afsluttes den aktuelle træning, og du går til opsummeringsskærmen.';

  @override
  String get workoutComplete => 'Træning fuldført';

  @override
  String get backgroundIntervalNotificationTitle => 'Nyt interval starter';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Beskeder når skærmen er slukket';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Forbereder';

  @override
  String get liveActivityInProgress => 'Træning i gang';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Interval $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'I $duration';
  }

  @override
  String get totalWorkoutTime => 'Samlet tid';

  @override
  String get totalDistance => 'Samlet distance';

  @override
  String get totalTime => 'Samlet tid';

  @override
  String get averageRpm => 'Gennemsnitlig RPM';

  @override
  String get averageLevel => 'Gennemsnitligt niveau';

  @override
  String get holdToStop => 'Hold for at stoppe';

  @override
  String get continueWorkout => 'Fortsæt';

  @override
  String get endWorkoutQuestion => 'Vil du afslutte træningen?';

  @override
  String get workoutPaused => 'Træningen er sat på pause';

  @override
  String get lvlIncline => 'Hældning';

  @override
  String get lvlResistance => 'Nivå modstand';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Opgrader nu';

  @override
  String get purchase => 'Køb';

  @override
  String get later => 'Senere';

  @override
  String get premiumActivated => 'Premium er aktiveret';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Rutiner til cykel og StairMaster';

  @override
  String get benefitVoiceGuide => 'Stemmeguide til hver session';

  @override
  String get benefitUnlimitedRoutines => 'Ubegrænset lagring af rutiner';

  @override
  String get noAds => 'Ingen annoncer';

  @override
  String get benefitFutureFeatures => 'Alle fremtidige funktioner inkluderet';

  @override
  String get voiceGuideBenefit1 => 'Lydbaseret trænervejledning';

  @override
  String get voiceGuideBenefit2 => 'Automatisk besked ved skift af session';

  @override
  String get voiceGuideBenefit3 => 'Fokuser håndfrit på din træning';

  @override
  String get routineLimitBenefit1 => 'Ubegrænset lagring af rutiner';

  @override
  String get routineLimitBenefit2 => 'Målrettede rutiner til dine mål';

  @override
  String get routineLimitBenefit3 =>
      'Fuld support til løbebånd, cykel og StairMaster';

  @override
  String get premium_benefit_1 =>
      'Understøttelse af <red>cykel & StairMaster</red>';

  @override
  String get premium_benefit_2 => '<red>Stemmeguide</red> under træningen';

  @override
  String get premium_benefit_3 => 'Gem rutiner <red>uden grænser</red>';

  @override
  String get premium_benefit_4 =>
      'Alle fremtidige funktioner <red>inkluderet på livstid</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/måned';
  }

  @override
  String get premiumSubheadline =>
      'Lås op for stemmeguide, cykel- & stairmastertræning og ubegrænsede rutiner';

  @override
  String get monthly => 'Månedligt';

  @override
  String get yearly => 'Årligt';

  @override
  String get lifetime => 'Livstid';

  @override
  String get freeTrial7Days => '7 dages gratis prøveperiode';

  @override
  String get perMonth => '/måned';

  @override
  String get perYear => '/år';

  @override
  String get oneTime => 'Engangsbetalin';

  @override
  String savePercent(String percent) {
    return 'Spar $percent';
  }

  @override
  String get bestValue => 'Bedste værdi';

  @override
  String get cancelAnytime => 'Annuller når som helst';

  @override
  String get autoRenewableSubscription => 'Fornyes automatisk';

  @override
  String get terms => 'Vilkår';

  @override
  String get privacy => 'Privatliv';

  @override
  String get restore => 'Gendan';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Rutine';

  @override
  String get settingsTab => 'Indstillinger';

  @override
  String get myTab => 'Min';

  @override
  String get close => 'Luk';

  @override
  String get premiumFeature => 'Kun Premium';

  @override
  String get usePremiumTest => 'Test Premium';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day/$month/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Se & start';

  @override
  String get beginner => 'Begynder';

  @override
  String get intermediate => 'Mellem';

  @override
  String get advanced => 'Avanceret';

  @override
  String get viewRecommendedRoutines => 'Udvalgte →';

  @override
  String get recommendedRoutinesTreadmill => 'Løbebåndsforslag';

  @override
  String get recommendedRoutinesCycle => 'Cykelforslag';

  @override
  String get recommendedRoutinesStairmaster => 'Stairmaster-forslag';

  @override
  String get alreadySaved => 'Allerede gemt';

  @override
  String get routineSaved => 'Rutine gemt';

  @override
  String get checkRoutine => 'Se';

  @override
  String get saveRoutine => 'Gem rutine';

  @override
  String get routineAlreadySaved => 'Rutinen er allerede gemt';

  @override
  String get noTemplatesFound => 'Ingen skabeloner fundet';

  @override
  String get avg => 'Gns.';

  @override
  String get avgRpm => 'Gns. RPM';

  @override
  String get avgLevel => 'Gns. niveau';

  @override
  String get templateTreadmillBeginner1Title => 'Begynder Løbebånd 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 gang og løb efter 3 min. opvarmning';

  @override
  String get templateTreadmillBeginner2Title =>
      'Begynder Løbebånd 2 (Hældning)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Hældningsgang med lav ledbelastning';

  @override
  String get templateTreadmillIntermediate1Title => 'Øvet Løbebånd 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      '1:1 løbeinterval til fedtforbrænding';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Øvet Løbebånd 2 (Hastighed)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Pyramide hastighedstræning løb';

  @override
  String get templateTreadmillAdvanced1Title => 'Avanceret Løbebånd 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Højintensiv cardio-blast interval';

  @override
  String get templateTreadmillAdvanced2Title => 'Avanceret Løbebånd 2 (Sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Korte sprintgentagelser med høj intensitet';

  @override
  String get templateCycleBeginner1Title => 'Begynder Cykel 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Pedaltræning ved at justere RPM';

  @override
  String get templateCycleBeginner2Title => 'Begynder Cykel 2 (Stabil)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Udholdenhedstræning ved konstant modstand';

  @override
  String get templateCycleIntermediate1Title => 'Øvet Cykel 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 min. højt tempo / 1 min. restitution';

  @override
  String get templateCycleIntermediate2Title => 'Øvet Cykel 2 (Bakke)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Bakkekørsel ved høj modstand';

  @override
  String get templateCycleAdvanced1Title => 'Avanceret Cykel 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      '30s styrkeintervaller ved høj modstand';

  @override
  String get templateCycleAdvanced2Title => 'Avanceret Cykel 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      '20s/10s Tabata-cirkel til fedtforbrænding';

  @override
  String get templateStairmasterBeginner1Title => 'Begynder Stairmaster 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Sikker trappegang i tilpasningstempo';

  @override
  String get templateStairmasterBeginner2Title =>
      'Begynder Stairmaster 2 (Stabil)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Aerob trappesimulering i konstant tempo';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Øvet Stairmaster 1 (Klim)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 min. klim / 1 min. restitution af balder';

  @override
  String get templateStairmasterIntermediate2Title => 'Øvet Stairmaster 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Intervaller med skiftevis hurtigt/langsomt tempo';

  @override
  String get templateStairmasterAdvanced1Title => 'Avanceret Stairmaster 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Intensiv 2-minutters bloktræning';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Avanceret Stairmaster 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s hurtig klatring / 60s restitution';

  @override
  String get historyTab => 'Historik';

  @override
  String get calendarTab => 'Kalender';

  @override
  String get weightTab => 'Vægt';

  @override
  String get bike => 'Cykel';

  @override
  String get thisWeek => 'Denne uge';

  @override
  String get trend => 'Vægtudvikling';

  @override
  String get timeframe7D => '7D';

  @override
  String get timeframe30D => '30D';

  @override
  String get timeframe90D => '90D';

  @override
  String get timeframeAll => 'ALLE';

  @override
  String get history => 'Historik';

  @override
  String get seeAll => 'Se alle';

  @override
  String get weightEntryDeleted => 'Vægtregistrering slettet';

  @override
  String get weightUpdated => 'Vægt opdateret';

  @override
  String get editWeight => 'Rediger vægt';

  @override
  String get recordWeight => 'Log vægt';

  @override
  String get quickAdjust => 'Hurtigjustering';

  @override
  String get goalWeightSet => 'Målvægt sat';

  @override
  String get goalWeightRemoved => 'Målvægt er deaktiveret';

  @override
  String get goalAchieved => 'Mål nået!';

  @override
  String get goalMatchesCurrentWeight => 'Målet matcher nuværende vægt';

  @override
  String get setGoal => 'Sæt mål';

  @override
  String get suggested => 'Foreslået';

  @override
  String get removeGoal => 'Fjern mål';

  @override
  String get addOneMoreRecordToSeeTrend =>
      'Tilføj 1 måling mere for at se udviklingen';

  @override
  String get noWeightRecorded => 'Ingen vægt registreret endnu';

  @override
  String get startTrackingYourWeight => 'Log vægt for at følge din udvikling';

  @override
  String get treadmillSession => 'Løbebåndssession';

  @override
  String get bikeSession => 'Cykelsession';

  @override
  String get stairmasterSession => 'Stairmaster-session';

  @override
  String get treadmillWorkout => 'Løbebåndstræning';

  @override
  String get bikeWorkout => 'Cykeltræning';

  @override
  String get stairmasterWorkout => 'Stairmaster-træning';

  @override
  String get startAWorkoutToSeeItHere => 'Dine træninger vises her';

  @override
  String get mon => 'man';

  @override
  String get tue => 'tir';

  @override
  String get wed => 'ons';

  @override
  String get thu => 'tor';

  @override
  String get fri => 'fre';

  @override
  String get sat => 'lør';

  @override
  String get sun => 'søn';

  @override
  String get sessions => 'Sessioner';

  @override
  String get distance => 'Distance';

  @override
  String get today => 'I dag';

  @override
  String get yesterday => 'I går';

  @override
  String get noWorkoutsYet => 'Ingen træninger endnu';

  @override
  String get startYourFirstWorkout =>
      'Start din første træning for at se din historik';

  @override
  String get goToRoutines => 'Gå til rutiner';

  @override
  String get weightRecorded => 'Vægt registreret';

  @override
  String get workout => 'træning';

  @override
  String get workouts => 'træninger';

  @override
  String get goal => 'Mål';

  @override
  String get toGo => 'tilbage';

  @override
  String get over => 'over';

  @override
  String get last => 'Sidste';

  @override
  String get newLabel => 'Ny';

  @override
  String youNeed(String amount, String goal) {
    return 'Du mangler $amount for at nå $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'Du mangler +$amount for at nå $goal';
  }

  @override
  String get current => 'Nuværende';

  @override
  String get premiumHeadline => 'Samme 30 minutter, anderledes resultater';

  @override
  String get premiumSubheadlineNew =>
      'Løb ikke bare – træn på den fedtforbrændende måde';

  @override
  String get mostPopular => 'Mest populær';

  @override
  String dailyPrice(int price) {
    return '$price pr. dag';
  }

  @override
  String get benefitVoiceCoaching => 'Premium Stemmecoaching System';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Intervaladvarsler, mens du bruger andre apps';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Fuld Support til Alt Cardio-udstyr';

  @override
  String get benefitUnlimitedRoutinesNew => 'Ubegrænset Rutine-bibliotek';

  @override
  String get benefitWeightFeature => 'Smart Vægtsporing & Analyse';

  @override
  String get benefitNoAdsFocus => 'Reklamefri Premium Oplevelse';

  @override
  String get benefitFutureFeaturesNew =>
      'Alle fremtidige premiumfunktioner inkluderet';

  @override
  String get mostChosen => 'Topvalg';

  @override
  String get canChangeAnytime => 'Skift når som helst';

  @override
  String get startPremium => 'Få Premium';

  @override
  String get cancelAnytimeKeepAccess => 'Annuller når som helst, behold adgang';

  @override
  String workoutDays(String count) {
    return 'Træningsdage: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Hviledage: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Påmindelser';

  @override
  String get workoutReminderOff => 'Slukket';

  @override
  String get workoutReminderEveryDay => 'Hver dag';

  @override
  String get workoutReminderSelectTime => 'Vælg tid';

  @override
  String get workoutReminderPermissionRequired =>
      'Notifikationstilladelse kræves.';

  @override
  String get workoutReminderTimeLabel => 'Tidspunkt';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Prøv dette intervaltræningsprogram på Valcue!\n\nProgram: $routineName\n\nKopier eller tryk på linket for at importere det:\n$shareLink';
  }

  @override
  String get scanQrCode => 'Scan QR-kode';

  @override
  String get invalidQrCode => 'Denne QR-kode er ikke en Valcue-rutine.';

  @override
  String get previousMonth => 'Forrige måned';

  @override
  String get nextMonth => 'Næste måned';

  @override
  String get placeQrInside => 'Placer QR-koden inden for rammen.';

  @override
  String get customRoutineBuilder => 'Lav personlig rutine';

  @override
  String get customRoutineAccuracyNoticeTitle =>
      'De faktiske værdier kan afvige lidt';

  @override
  String get customRoutineAccuracyNoticeMessage =>
      'Hastighed og kadence rundes til hele tal, hver generering tilføjer en lille, bevidst variation, og værdierne holder sig inden for et sikkert interval for dit sværhedsniveau. Derfor kan den faktiske rutine afvige fra dit mål med nogle få procent.';

  @override
  String get customRoutineGenerating => 'Din personlige rutine bliver lavet…';

  @override
  String get customRoutineLoadingTarget => 'Dit intensitetsmål indstilles…';

  @override
  String get customRoutineLoadingStructure =>
      'Opvarmning og nedkøling planlægges…';

  @override
  String get customRoutineLoadingPace => 'Dit intervaltempo beregnes…';

  @override
  String get customRoutineLoadingVoice => 'Stemmevejledning forberedes…';

  @override
  String get generationComplete => 'Rutinen er klar!';

  @override
  String get regenerate => 'Lav igen';

  @override
  String get caloriesEstimateByWeight =>
      'Kalorier er et estimat baseret på den indtastede vægt.';

  @override
  String get commonBack => 'Tilbage';

  @override
  String get adjustGoals => 'Juster mål';

  @override
  String get targetCalories => 'Kaloriemål';

  @override
  String get targetStairs => 'Mål for etager';

  @override
  String get targetDistance => 'Distancemål';

  @override
  String get currentWeight => 'Nuværende vægt';

  @override
  String get includeIncline => 'Medtag stigning';

  @override
  String get includeWarmupCooldown => 'Medtag opvarmning og nedkøling';

  @override
  String get generateCustomRoutine => 'Lav personlig rutine';

  @override
  String durationMinutes(String minutes) {
    return '$minutes min.';
  }

  @override
  String floorCount(String count) {
    return 'Etager: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Personligt løb $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Personlig cykling $distance $distanceUnit ($calories kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Opbygningsløb $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Pyramideløb $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Opbygningscykling $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Pyramidecykling $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Personlig trappetræning $floors etager ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Din personlige rutine er klar. Sigt efter cirka $calories kalorier!';
  }

  @override
  String get weightDeleteTitle => 'Slet registrering';

  @override
  String get weightDeleteConfirm =>
      'Er du sikker på, at du vil slette denne vægtregistrering?';

  @override
  String get achievementUnlocked => '🏆 Præstation låst op!';

  @override
  String get achievementCongratulations =>
      'Tillykke! Du har fået et nyt badge.';

  @override
  String get awesome => 'Fantastisk!';

  @override
  String get shareCardDefault => '9:14 (Standard)';

  @override
  String get shareCardStory => '9:16 (Story)';

  @override
  String get shareCardSquare => '1:1 (Kvadrat)';

  @override
  String get customizeShareCard => 'Tilpas delingskort';

  @override
  String get shareRoutine => 'Del rutine';

  @override
  String get shareViaQrCode => 'Del via QR-kode';

  @override
  String get routineLimitReached => 'Rutinegrænse nået';

  @override
  String get routineLimitMessage =>
      'Gratis brugere kan gemme op til 2 løbebåndsrutiner. Opgrader til Premium, eller slet en eksisterende rutine.';

  @override
  String get importSharedRoutine => 'Importér delt rutine';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'Der blev fundet en rutine i QR-koden.\n\n• Navn: $name\n• Sværhedsgrad: $difficulty\n• Intervaller: $count\n\nVil du gemme den i dit bibliotek?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'Der blev fundet en delt rutine i udklipsholderen.\n\n• Navn: $name\n• Sværhedsgrad: $difficulty\n• Intervaller: $count\n\nVil du gemme den i dit bibliotek?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '“$name” blev importeret!';
  }

  @override
  String get importAction => 'Importér';

  @override
  String get addRoutineOption => 'Vælg, hvordan du tilføjer en rutine';

  @override
  String get createCustomRoutine => 'Opret personlig rutine';

  @override
  String get importFromClipboard => 'Importér fra udklipsholder';

  @override
  String get countdownTiming => 'Nedtællingsbeskeder';

  @override
  String get noAnnouncements => 'Ingen beskeder';

  @override
  String secondsShort(String seconds) {
    return '$seconds sek. før';
  }

  @override
  String get selectCountdownTimings => 'Vælg nedtællingstider';

  @override
  String get countdownTimingMessage =>
      'Vælg, hvornår resttiden skal læses op før et intervalskift.';

  @override
  String secondsLeft(String seconds) {
    return '$seconds sek. tilbage';
  }

  @override
  String get qrShareInstruction =>
      'Scan QR-koden fra en anden Valcue-app\nfor at importere rutinen med det samme.';

  @override
  String get quickStart => 'Hurtig start';

  @override
  String get sessionRepeatBlock => 'Gentaget sessionsblok';

  @override
  String repeatTimes(String count) {
    return 'Gentagelser: $count';
  }

  @override
  String get addRepeatBlock => 'Tilføj gentagelsesblok';

  @override
  String get unableToShareWorkout => 'Træningen kunne ikke deles.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'Privatlivspolitikken kunne ikke åbnes.';

  @override
  String get unableToOpenLink => 'Linket kunne ikke åbnes.';

  @override
  String get less => 'Mindre';

  @override
  String get more => 'Mere';

  @override
  String inclineValue(String value) {
    return 'Stigning: $value %';
  }

  @override
  String rpmValue(String value) {
    return '$value o/min';
  }

  @override
  String nextMetric(String value) {
    return 'Næste: $value';
  }

  @override
  String get weightCalendar => 'Vægtkalender';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText intervaller · $difficulty',
      one: '$duration · $countText interval · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Mål: $goalWeight • Mål nået!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Mål: $goalWeight • $difference tilbage';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Mål: $goalWeight • $difference over';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Gns. $value km/t';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Gns. $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Gns. $value o/min';
  }

  @override
  String averageLevelValue(String value) {
    return 'Gns. niveau $value';
  }

  @override
  String get purchaseFailed => 'Købet mislykkedes. Prøv igen.';

  @override
  String get restoreSuccess => 'Dine køb er blevet gendannet.';

  @override
  String get restoreNothingToRestore => 'Der blev ikke fundet tidligere køb.';

  @override
  String get plansUnavailable => 'Kunne ikke indlæse planer. Prøv igen senere.';
}
