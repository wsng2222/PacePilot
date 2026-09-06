// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Größe der Trainingsanzeige';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Vergrößert wichtige Trainingswerte und den Timer.';

  @override
  String get workoutDisplaySizeStandard => 'Standard';

  @override
  String get workoutDisplaySizeLarge => 'Groß';

  @override
  String get workoutDisplaySizeExtraLarge => 'Maximal';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get system => 'System';

  @override
  String get voiceGuide => 'Sprachführung';

  @override
  String get audioNavigator => 'Audio-Navigator';

  @override
  String get soundEffects => 'Soundeffekte';

  @override
  String get unitSetting => 'Einheiten';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Design';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get smartwatchSync => 'Smartwatch-Synchronisation';

  @override
  String get connectSmartwatch => 'Mit Smartwatch verbinden';

  @override
  String get connect => 'Verbinden';

  @override
  String get about => 'Über';

  @override
  String get adPrivacyOptions => 'Anzeigen-Datenschutzoptionen';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get translationComingSoon =>
      'Die Übersetzung wird in einem zukünftigen Update verfügbar sein.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get done => 'Fertig';

  @override
  String get delete => 'Löschen';

  @override
  String get duplicate => 'Duplizieren';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get start => 'Starten';

  @override
  String get editRoutine => 'Routine Bearbeiten';

  @override
  String get routineEdit => 'Routine Bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get unnamedRoutine => 'Unbenannte Routine';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String difficultyColon(String difficulty) {
    return 'Schwierigkeit : $difficulty';
  }

  @override
  String get easy => 'Einfach';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get interval => 'Intervall';

  @override
  String get addInterval => 'Intervall Hinzufügen';

  @override
  String get quickTools => 'Schnellaktionen';

  @override
  String get addDefault => 'Standard hinzu';

  @override
  String get duplicateLast => 'Letzte kopieren';

  @override
  String get repeatPattern => 'Muster wiederholen';

  @override
  String get reorderIntervals => 'Reihenfolge ändern';

  @override
  String get reorderMode => 'Modus zum Ändern der Reihenfolge';

  @override
  String get reorderModeHint =>
      'Halte eine Karte gedrückt, um sie an die gewünschte Position zu verschieben.';

  @override
  String get patternLength => 'Musterlänge';

  @override
  String get repeatCount => 'Wiederholungen';

  @override
  String get noIntervals => 'Keine Intervalle';

  @override
  String get addIntervalPrompt => 'Ein Intervall hinzufügen';

  @override
  String get intervalEdit => 'Intervall Bearbeiten';

  @override
  String get timeMinutes => 'Zeit (Minuten)';

  @override
  String get duration => 'Dauer';

  @override
  String get speed => 'Geschwindigkeit';

  @override
  String get speedKmh => 'Geschwindigkeit (km/h)';

  @override
  String get incline => 'Steigung';

  @override
  String get level => 'Stufe';

  @override
  String levelColon(String level) {
    return 'Stufe $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPM zeigt an, wie oft sich deine Pedale pro Minute drehen. Je höher der Wert, desto schneller ist deine Trittfrequenz.';

  @override
  String get resistance => 'Widerstand';

  @override
  String get resistanceLevel => 'Widerstand (Stufe)';

  @override
  String resistanceColon(String resistance) {
    return 'Widerstand $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (Schritte/min)';

  @override
  String get saved => 'Gespeichert';

  @override
  String get deleted => 'Gelöscht';

  @override
  String get deleteRoutineTitle => 'Routine Löschen';

  @override
  String get deleteRoutineMessage =>
      'Möchtest du diese Routine wirklich löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String get deleteError => 'Beim Löschen ist ein Fehler aufgetreten';

  @override
  String get nameRequired => 'Bitte gib einen Namen ein';

  @override
  String get nameMaxLength => 'Der Name muss 50 Zeichen oder weniger haben';

  @override
  String get minIntervalsRequired =>
      'Mindestens ein Intervall ist erforderlich';

  @override
  String get intervalMinDuration =>
      'Die Intervall-Dauer muss mindestens 1 Sekunde betragen';

  @override
  String get intervalMaxDuration =>
      'Die Intervall-Dauer darf höchstens 3 Stunden (10800 Sekunden) betragen';

  @override
  String get speedRange =>
      'Die Geschwindigkeit muss größer als 0 sein (0.5-25.0 km/h)';

  @override
  String get inclineRange => 'Die Steigung muss im Bereich 0-15.0 liegen';

  @override
  String get rpmRange => 'RPM muss im Bereich 30-200 liegen';

  @override
  String get resistanceRange => 'Der Widerstand muss im Bereich 1-20 liegen';

  @override
  String get levelRange => 'Die Stufe muss im Bereich 1-20 liegen';

  @override
  String get spmRange => 'SPM muss im Bereich 50-200 liegen';

  @override
  String get noRoutinesSaved => 'Keine Routinen gespeichert';

  @override
  String get tapToCreate => 'Tippen zum Erstellen';

  @override
  String get tapButtonToCreate => 'Tippe zum Erstellen auf die Schaltfläche';

  @override
  String get premiumRoutineSettings => 'Premium-Routinen-Einstellungen';

  @override
  String get viewMembership => 'Premium ansehen';

  @override
  String get freeLimitTitle => '2 Gratis-Routinen';

  @override
  String get freeLimitMessage => 'Mit Premium unbegrenzt Routinen nutzen';

  @override
  String get treadmill => 'Laufband';

  @override
  String get cycle => 'Fahrrad';

  @override
  String get stairmaster => 'Treppensteiger';

  @override
  String get selectLanguage => 'Sprachen';

  @override
  String get selectTheme => 'Thema Auswählen';

  @override
  String get selectDifficulty => 'Schwierigkeit Auswählen';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get endWorkout => 'Training Beenden';

  @override
  String get endWorkoutConfirm => 'Möchtest du das Training beenden?';

  @override
  String get end => 'Beenden';

  @override
  String get share => 'Teilen';

  @override
  String get rotate => 'Drehen';

  @override
  String get paused => 'PAUSIERT';

  @override
  String get pausedTitle => 'Pausiert';

  @override
  String get pausedSubtitle => 'Du kannst fortfahren oder das Training beenden';

  @override
  String get endWorkoutConfirmationMessage =>
      'Wenn du jetzt aufhörst, wird das Training beendet und die Zusammenfassung geöffnet.';

  @override
  String get workoutComplete => 'Training abgeschlossen';

  @override
  String get backgroundIntervalNotificationTitle => 'Neues Intervall';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Hinweise bei ausgeschaltetem Display';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Vorbereitung';

  @override
  String get liveActivityInProgress => 'Training läuft';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Intervall $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'Für $duration';
  }

  @override
  String get totalWorkoutTime => 'Gesamtzeit';

  @override
  String get totalDistance => 'Gesamte Distanz';

  @override
  String get totalTime => 'Gesamtzeit';

  @override
  String get averageRpm => 'Durchschnittliche RPM';

  @override
  String get averageLevel => 'Durchschnittliches Level';

  @override
  String get holdToStop => 'Gedrückt halten zum Stoppen';

  @override
  String get continueWorkout => 'Fortsetzen';

  @override
  String get endWorkoutQuestion => 'Möchtest du das Training beenden?';

  @override
  String get workoutPaused => 'Das Training wurde pausiert';

  @override
  String get lvlIncline => 'Steigung';

  @override
  String get lvlResistance => 'Stufe Widerstand';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Jetzt Upgraden';

  @override
  String get purchase => 'Kaufen';

  @override
  String get later => 'Später';

  @override
  String get premiumActivated => 'Premium wurde aktiviert';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Routinen für Fahrrad und StairMaster';

  @override
  String get benefitVoiceGuide => 'Sprachanleitung für jede Session';

  @override
  String get benefitUnlimitedRoutines => 'Unbegrenztes Speichern von Routinen';

  @override
  String get noAds => 'Keine Werbung';

  @override
  String get benefitFutureFeatures => 'Alle zukünftigen Funktionen inklusive';

  @override
  String get voiceGuideBenefit1 => 'Sprachgeführtes Training';

  @override
  String get voiceGuideBenefit2 => 'Automatische Ansage bei Session-Wechsel';

  @override
  String get voiceGuideBenefit3 =>
      'Fokussiere dich freihändig auf dein Training';

  @override
  String get routineLimitBenefit1 => 'Unbegrenztes Speichern von Routinen';

  @override
  String get routineLimitBenefit2 => 'Personalisierte Routinen nach Ziel';

  @override
  String get routineLimitBenefit3 =>
      'Unterstützung für Laufband, Fahrrad und StairMaster';

  @override
  String get premium_benefit_1 =>
      'Unterstützung für <red>Fahrrad & StairMaster</red>';

  @override
  String get premium_benefit_2 =>
      '<red>Sprachanleitung</red> während des Trainings';

  @override
  String get premium_benefit_3 => 'Routinen speichern <red>ohne Limit</red>';

  @override
  String get premium_benefit_4 =>
      'Alle zukünftigen Funktionen <red>lebenslang inklusive</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/Monat';
  }

  @override
  String get premiumSubheadline =>
      'Schalte Sprachführung, Fahrrad- und StairMaster-Workouts sowie unbegrenzte Routinen frei';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get lifetime => 'Lebenslang';

  @override
  String get freeTrial7Days => '7 Tage kostenlos testen';

  @override
  String get perMonth => '/Monat';

  @override
  String get perYear => '/Jahr';

  @override
  String get oneTime => 'Einmalige Zahlung';

  @override
  String savePercent(String percent) {
    return 'Spare $percent';
  }

  @override
  String get bestValue => 'Bester Wert';

  @override
  String get cancelAnytime => 'Jederzeit kündbar';

  @override
  String get autoRenewableSubscription => 'Verlängert sich automatisch';

  @override
  String get terms => 'Bedingungen';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Routine';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get myTab => 'Ich';

  @override
  String get close => 'Schließen';

  @override
  String get premiumFeature => 'Nur Premium';

  @override
  String get usePremiumTest => 'Premium testen';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day.$month.$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Vorschau & Start';

  @override
  String get beginner => 'Anfänger';

  @override
  String get intermediate => 'Fortgeschritten';

  @override
  String get advanced => 'Experte';

  @override
  String get viewRecommendedRoutines => 'Tipps →';

  @override
  String get recommendedRoutinesTreadmill => 'Laufband-Tipps';

  @override
  String get recommendedRoutinesCycle => 'Rad-Tipps';

  @override
  String get recommendedRoutinesStairmaster =>
      'Empfohlene Treppensteiger-Trainings';

  @override
  String get alreadySaved => 'Bereits gespeichert';

  @override
  String get routineSaved => 'Routine gespeichert';

  @override
  String get checkRoutine => 'Vorschau';

  @override
  String get saveRoutine => 'Routine Speichern';

  @override
  String get routineAlreadySaved => 'Routine bereits gespeichert';

  @override
  String get noTemplatesFound => 'Keine Vorlagen gefunden';

  @override
  String get avg => 'Ø';

  @override
  String get avgRpm => 'Ø RPM';

  @override
  String get avgLevel => 'Ø Stufe';

  @override
  String get templateTreadmillBeginner1Title => 'Laufband Anfänger 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 Gehen/Laufen nach 3 Min. Aufwärmen';

  @override
  String get templateTreadmillBeginner2Title =>
      'Laufband Anfänger 2 (Steigung)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Steigungsgehen mit geringer Gelenkbelastung';

  @override
  String get templateTreadmillIntermediate1Title =>
      'Laufband Fortgeschritten 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      '1:1 Laufintervall zur Fettverbrennung';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Laufband Fortgeschritten 2 (Tempo)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Pyramidenförmiges Tempolauftraining';

  @override
  String get templateTreadmillAdvanced1Title => 'Laufband Profi 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Hochintensives Cardio-Blast-Intervall';

  @override
  String get templateTreadmillAdvanced2Title => 'Laufband Profi 2 (Sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Kurze Sprintwiederholungen bei hoher Intensität';

  @override
  String get templateCycleBeginner1Title => 'Fahrrad Anfänger 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Einführung ins Pedalieren durch RPM-Anpassung';

  @override
  String get templateCycleBeginner2Title => 'Fahrrad Anfänger 2 (Konstant)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Ausdauertraining bei festem Widerstand';

  @override
  String get templateCycleIntermediate1Title => 'Fahrrad Fortgeschritten 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 Min. hohes Tempo / 1 Min. Erholung';

  @override
  String get templateCycleIntermediate2Title =>
      'Fahrrad Fortgeschritten 2 (Hügel)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Hügelaufwärtsfahren bei hohem Widerstand';

  @override
  String get templateCycleAdvanced1Title => 'Fahrrad Profi 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      '30s Kraftintervalle bei hohem Widerstand';

  @override
  String get templateCycleAdvanced2Title => 'Fahrrad Profi 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      '20s/10s Tabata-Zirkel zur Fettverbrennung';

  @override
  String get templateStairmasterBeginner1Title => 'Stairmaster Anfänger 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Sicheres Gewöhnen durch langsames Treppensteigen';

  @override
  String get templateStairmasterBeginner2Title =>
      'Stairmaster Anfänger 2 (Konstant)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Aerobes Treppensteigen bei konstantem Tempo';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Stairmaster Fortgeschritten 1 (Anstieg)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 Min. Anstieg / 1 Min. Erholung für Gesäßmuskeln';

  @override
  String get templateStairmasterIntermediate2Title =>
      'Stairmaster Fortgeschritten 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Intervalle mit abwechselnd schnellem/langsamem Tempo';

  @override
  String get templateStairmasterAdvanced1Title => 'Stairmaster Profi 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Intensives 2-Minuten-Blocktraining';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Stairmaster Profi 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s schneller Aufstieg / 60s Erholung';

  @override
  String get historyTab => 'Verlauf';

  @override
  String get calendarTab => 'Kalender';

  @override
  String get weightTab => 'Gewicht';

  @override
  String get bike => 'Fahrrad';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get trend => 'Gewichtsverlauf';

  @override
  String get timeframe7D => '7T';

  @override
  String get timeframe30D => '30T';

  @override
  String get timeframe90D => '90T';

  @override
  String get timeframeAll => 'ALLE';

  @override
  String get history => 'Verlauf';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get weightEntryDeleted => 'Gewichtseintrag gelöscht';

  @override
  String get weightUpdated => 'Gewicht aktualisiert';

  @override
  String get editWeight => 'Gewicht bearbeiten';

  @override
  String get recordWeight => 'Gewicht erfassen';

  @override
  String get quickAdjust => 'Schnell anpassen';

  @override
  String get goalWeightSet => 'Zielgewicht festgelegt';

  @override
  String get goalWeightRemoved => 'Zielgewicht deaktiviert';

  @override
  String get goalAchieved => 'Ziel erreicht!';

  @override
  String get goalMatchesCurrentWeight =>
      'Ziel entspricht dem aktuellen Gewicht';

  @override
  String get setGoal => 'Ziel setzen';

  @override
  String get suggested => 'Vorgeschlagen';

  @override
  String get removeGoal => 'Ziel löschen';

  @override
  String get addOneMoreRecordToSeeTrend => 'Noch 1 Eintrag für den Trend';

  @override
  String get noWeightRecorded => 'Bisher kein Gewicht eingetragen';

  @override
  String get startTrackingYourWeight => 'Gewicht erfassen, Fortschritt sehen';

  @override
  String get treadmillSession => 'Laufband-Session';

  @override
  String get bikeSession => 'Fahrrad-Session';

  @override
  String get stairmasterSession => 'Treppensteiger-Einheit';

  @override
  String get treadmillWorkout => 'Laufband-Training';

  @override
  String get bikeWorkout => 'Fahrrad-Training';

  @override
  String get stairmasterWorkout => 'Treppensteiger-Training';

  @override
  String get startAWorkoutToSeeItHere => 'Deine Trainings erscheinen hier';

  @override
  String get mon => 'Mo';

  @override
  String get tue => 'Di';

  @override
  String get wed => 'Mi';

  @override
  String get thu => 'Do';

  @override
  String get fri => 'Fr';

  @override
  String get sat => 'Sa';

  @override
  String get sun => 'So';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get distance => 'Distanz';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get noWorkoutsYet => 'Noch keine Trainings';

  @override
  String get startYourFirstWorkout =>
      'Starte dein erstes Training, um hier deinen Verlauf zu sehen';

  @override
  String get goToRoutines => 'Zu Routinen gehen';

  @override
  String get weightRecorded => 'Gewicht aufgezeichnet';

  @override
  String get workout => 'Training';

  @override
  String get workouts => 'Trainings';

  @override
  String get goal => 'Ziel';

  @override
  String get toGo => 'verbleibend';

  @override
  String get over => 'überschritten';

  @override
  String get last => 'Letzte';

  @override
  String get newLabel => 'Neu';

  @override
  String youNeed(String amount, String goal) {
    return 'Dir fehlen $amount bis $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'Dir fehlen +$amount bis $goal';
  }

  @override
  String get current => 'Aktuell';

  @override
  String get premiumHeadline => 'Gleiche 30 Minuten, andere Ergebnisse';

  @override
  String get premiumSubheadlineNew =>
      'Trainiere gezielt statt einfach nur zu laufen';

  @override
  String get mostPopular => 'Am Beliebtesten';

  @override
  String dailyPrice(int price) {
    return '$price pro Tag';
  }

  @override
  String get benefitVoiceCoaching => 'Premium-Sprachcoaching-System';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Intervallhinweise bei Nutzung anderer Apps';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Vollständige Unterstützung für Alle Cardio-Geräte';

  @override
  String get benefitUnlimitedRoutinesNew => 'Unbegrenzte Routinenbibliothek';

  @override
  String get benefitWeightFeature =>
      'Intelligente Gewichtsverfolgung & Analyse';

  @override
  String get benefitNoAdsFocus => 'Werbefreies Premium-Erlebnis';

  @override
  String get benefitFutureFeaturesNew =>
      'Alle zukünftigen Premium-Funktionen enthalten';

  @override
  String get mostChosen => 'Topwahl';

  @override
  String get canChangeAnytime => 'Jederzeit wechseln';

  @override
  String get startPremium => 'Premium holen';

  @override
  String get cancelAnytimeKeepAccess => 'Jederzeit kündbar, Zugriff bleibt';

  @override
  String workoutDays(String count) {
    return 'Trainingstage: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Ruhetage: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Erinnerungen';

  @override
  String get workoutReminderOff => 'Aus';

  @override
  String get workoutReminderEveryDay => 'Jeden Tag';

  @override
  String get workoutReminderSelectTime => 'Zeit auswählen';

  @override
  String get workoutReminderPermissionRequired =>
      'Benachrichtigungsberechtigung erforderlich.';

  @override
  String get workoutReminderTimeLabel => 'Uhrzeit';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Probiere dieses Intervall-Workout in Valcue aus!\n\nRoutine: $routineName\n\nKopiere oder tippe auf den Link, um es zu importieren:\n$shareLink';
  }

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get invalidQrCode => 'Dieser QR-Code ist keine Valcue-Routine.';

  @override
  String get previousMonth => 'Vorheriger Monat';

  @override
  String get nextMonth => 'Nächster Monat';

  @override
  String get placeQrInside => 'Platziere den QR-Code innerhalb des Rahmens.';

  @override
  String get customRoutineBuilder => 'Individuelles Training erstellen';

  @override
  String get customRoutineAccuracyNoticeTitle =>
      'Werte können leicht abweichen';

  @override
  String get customRoutineAccuracyPointRounding =>
      'Geschwindigkeiten werden auf ganze Zahlen gerundet';

  @override
  String get customRoutineAccuracyPointVariation =>
      'Jede Routine fällt etwas anders aus';

  @override
  String get customRoutineAccuracyPointRange =>
      'Die Werte bleiben im sicheren Bereich der Schwierigkeit';

  @override
  String get customRoutineAccuracyResultNote =>
      'Die tatsächlichen Werte können um einige Prozent vom Ziel abweichen';

  @override
  String get customRoutineGenerating =>
      'Dein individuelles Training wird erstellt…';

  @override
  String get customRoutineLoadingTarget => 'Intensitätsziel wird festgelegt…';

  @override
  String get customRoutineLoadingStructure =>
      'Aufwärmen und Abkühlen werden geplant…';

  @override
  String get customRoutineLoadingPace => 'Intervalltempo wird berechnet…';

  @override
  String get customRoutineLoadingVoice => 'Sprachcoaching wird vorbereitet…';

  @override
  String get generationComplete => 'Training erstellt!';

  @override
  String get regenerate => 'Neu erstellen';

  @override
  String get caloriesEstimateByWeight =>
      'Die Kalorien sind ein Schätzwert basierend auf dem eingegebenen Gewicht.';

  @override
  String get commonBack => 'Zurück';

  @override
  String get adjustGoals => 'Ziele anpassen';

  @override
  String get targetCalories => 'Kalorienziel';

  @override
  String get targetStairs => 'Zieletagen';

  @override
  String get targetDistance => 'Zieldistanz';

  @override
  String get currentWeight => 'Aktuelles Gewicht';

  @override
  String get includeIncline => 'Steigung einbeziehen';

  @override
  String get includeWarmupCooldown => 'Aufwärmen und Abkühlen einbeziehen';

  @override
  String get generateCustomRoutine => 'Individuelles Training erstellen';

  @override
  String durationMinutes(String minutes) {
    return '$minutes Min.';
  }

  @override
  String floorCount(String count) {
    return 'Etagen: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Individueller Lauf $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Individuelles Radtraining $distance $distanceUnit ($calories kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Aufbaulauf $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Pyramidenlauf $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Aufbau-Radtraining $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Pyramiden-Radtraining $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Individuelles Treppentraining $floors Etagen ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Dein individuelles Training ist fertig. Ziele auf etwa $calories Kalorien!';
  }

  @override
  String get weightDeleteTitle => 'Eintrag löschen';

  @override
  String get weightDeleteConfirm =>
      'Möchtest du diesen Gewichtseintrag wirklich löschen?';

  @override
  String get achievementUnlocked => '🏆 Erfolg freigeschaltet!';

  @override
  String get achievementCongratulations =>
      'Glückwunsch! Du hast ein neues Abzeichen erhalten.';

  @override
  String get awesome => 'Klasse!';

  @override
  String get shareCardDefault => '9:14 (Standard)';

  @override
  String get shareCardStory => '9:16 (Story)';

  @override
  String get shareCardSquare => '1:1 (Quadratisch)';

  @override
  String get customizeShareCard => 'Teilen-Karte anpassen';

  @override
  String get shareRoutine => 'Training teilen';

  @override
  String get shareViaQrCode => 'Per QR-Code teilen';

  @override
  String get routineLimitReached => 'Trainingslimit erreicht';

  @override
  String get routineLimitMessage =>
      'Kostenlose Nutzer können bis zu 2 Laufbandtrainings speichern. Upgrade auf Premium oder lösche ein vorhandenes Training.';

  @override
  String get importSharedRoutine => 'Geteiltes Training importieren';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'Im QR-Code wurde ein Training gefunden.\n\n• Name: $name\n• Schwierigkeit: $difficulty\n• Intervalle: $count\n\nMöchtest du es in deiner Sammlung speichern?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'In der Zwischenablage wurde ein geteiltes Training gefunden.\n\n• Name: $name\n• Schwierigkeit: $difficulty\n• Intervalle: $count\n\nMöchtest du es in deiner Sammlung speichern?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '„$name“ wurde importiert!';
  }

  @override
  String get importAction => 'Importieren';

  @override
  String get addRoutineOption => 'Training hinzufügen';

  @override
  String get createCustomRoutine => 'Eigenes Training erstellen';

  @override
  String get importFromClipboard => 'Aus Zwischenablage importieren';

  @override
  String get countdownTiming => 'Countdown-Ansagen';

  @override
  String get noAnnouncements => 'Keine Ansagen';

  @override
  String secondsShort(String seconds) {
    return '$seconds s vorher';
  }

  @override
  String get selectCountdownTimings => 'Countdown-Zeiten auswählen';

  @override
  String get countdownTimingMessage =>
      'Wähle, wann vor einem Intervallwechsel die Restzeit angesagt werden soll.';

  @override
  String secondsLeft(String seconds) {
    return 'Noch $seconds Sek.';
  }

  @override
  String get qrShareInstruction =>
      'Scanne diesen QR-Code mit einer anderen Valcue-App,\num das Training sofort zu importieren.';

  @override
  String get quickStart => 'Schnellstart';

  @override
  String get sessionRepeatBlock => 'Wiederholungsblock';

  @override
  String repeatTimes(String count) {
    return 'Wiederholungen: $count';
  }

  @override
  String get addRepeatBlock => 'Wiederholungsblock hinzufügen';

  @override
  String get unableToShareWorkout => 'Training konnte nicht geteilt werden.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'Datenschutzerklärung konnte nicht geöffnet werden.';

  @override
  String get unableToOpenLink => 'Link konnte nicht geöffnet werden.';

  @override
  String get less => 'Weniger';

  @override
  String get more => 'Mehr';

  @override
  String inclineValue(String value) {
    return 'Steigung: $value %';
  }

  @override
  String rpmValue(String value) {
    return '$value U/min';
  }

  @override
  String nextMetric(String value) {
    return 'Als Nächstes: $value';
  }

  @override
  String get weightCalendar => 'Gewichtskalender';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText Intervalle · $difficulty',
      one: '$duration · $countText Intervall · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Ziel: $goalWeight • Ziel erreicht!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Ziel: $goalWeight • Noch $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Ziel: $goalWeight • Um $difference überschritten';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Ø $value km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Ø $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Ø $value U/min';
  }

  @override
  String averageLevelValue(String value) {
    return 'Ø Stufe $value';
  }

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get restoreSuccess => 'Deine Käufe wurden wiederhergestellt.';

  @override
  String get restoreNothingToRestore =>
      'Es wurden keine früheren Käufe gefunden.';

  @override
  String get plansUnavailable =>
      'Pläne konnten nicht geladen werden. Bitte versuche es später erneut.';
}
