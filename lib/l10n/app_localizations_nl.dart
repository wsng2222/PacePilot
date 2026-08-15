// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Grootte van trainingsscherm';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Vergroot belangrijke trainingswaarden en de timer.';

  @override
  String get workoutDisplaySizeStandard => 'Standaard';

  @override
  String get workoutDisplaySizeLarge => 'Groot';

  @override
  String get workoutDisplaySizeExtraLarge => 'Maximaal';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get system => 'Systeem';

  @override
  String get voiceGuide => 'Spraakgids';

  @override
  String get audioNavigator => 'Audio-navigator';

  @override
  String get soundEffects => 'Geluidseffecten';

  @override
  String get unitSetting => 'Eenheden';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Weergave';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get smartwatchSync => 'Smartwatch synchroniseren';

  @override
  String get connectSmartwatch => 'Koppel met smartwatch';

  @override
  String get connect => 'Koppelen';

  @override
  String get about => 'Over';

  @override
  String version(String version) {
    return 'Versie $version';
  }

  @override
  String get comingSoon => 'Binnenkort';

  @override
  String get translationComingSoon =>
      'Vertaling wordt beschikbaar in een toekomstige update.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuleren';

  @override
  String get done => 'Gereed';

  @override
  String get delete => 'Verwijderen';

  @override
  String get duplicate => 'Dupliceren';

  @override
  String get save => 'Opslaan';

  @override
  String get edit => 'Bewerken';

  @override
  String get start => 'Start';

  @override
  String get editRoutine => 'Routine bewerken';

  @override
  String get routineEdit => 'Routine bewerken';

  @override
  String get name => 'Naam';

  @override
  String get unnamedRoutine => 'Naamloze routine';

  @override
  String get difficulty => 'Moeilijkheid';

  @override
  String difficultyColon(String difficulty) {
    return 'Moeilijkheid : $difficulty';
  }

  @override
  String get easy => 'Makkelijk';

  @override
  String get medium => 'Midden';

  @override
  String get hard => 'Zwaar';

  @override
  String get interval => 'Interval';

  @override
  String get addInterval => 'Interval toevoegen';

  @override
  String get quickTools => 'Snelle acties';

  @override
  String get addDefault => 'Standaard toe';

  @override
  String get duplicateLast => 'Laatste kopiëren';

  @override
  String get repeatPattern => 'Patroon herhalen';

  @override
  String get reorderIntervals => 'Volgorde wijzigen';

  @override
  String get reorderMode => 'Modus voor volgorde wijzigen';

  @override
  String get reorderModeHint =>
      'Houd een kaart ingedrukt om deze naar de gewenste plek te verplaatsen.';

  @override
  String get patternLength => 'Patroonlengte';

  @override
  String get repeatCount => 'Herhalingen';

  @override
  String get noIntervals => 'Geen intervallen';

  @override
  String get addIntervalPrompt => 'Voeg een interval toe';

  @override
  String get intervalEdit => 'Interval bewerken';

  @override
  String get timeMinutes => 'Tijd (minuten)';

  @override
  String get duration => 'Duur';

  @override
  String get speed => 'Snelheid';

  @override
  String get speedKmh => 'Snelheid (km/h)';

  @override
  String get incline => 'Helling';

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
      'RPM laat zien hoe vaak je pedalen in één minuut ronddraaien. Een hogere RPM betekent dat je met een snellere cadans fietst.';

  @override
  String get resistance => 'Weerstand';

  @override
  String get resistanceLevel => 'Weerstand (niveau)';

  @override
  String resistanceColon(String resistance) {
    return 'Weerstand $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (stappen/min)';

  @override
  String get saved => 'Opgeslagen';

  @override
  String get deleted => 'Verwijderd';

  @override
  String get deleteRoutineTitle => 'Routine verwijderen';

  @override
  String get deleteRoutineMessage =>
      'Weet je zeker dat je deze routine wilt verwijderen? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get deleteError => 'Er is een fout opgetreden bij het verwijderen';

  @override
  String get nameRequired => 'Voer een naam in';

  @override
  String get nameMaxLength => 'Naam moet 50 tekens of minder zijn';

  @override
  String get minIntervalsRequired => 'Minstens één interval is vereist';

  @override
  String get intervalMinDuration => 'Intervalduur moet minimaal 1 seconde zijn';

  @override
  String get intervalMaxDuration =>
      'Intervalduur mag maximaal 3 uur zijn (10800 seconden)';

  @override
  String get speedRange => 'Snelheid moet groter zijn dan 0 (0.5-25.0 km/h)';

  @override
  String get inclineRange => 'Helling moet tussen 0-15.0 liggen';

  @override
  String get rpmRange => 'RPM moet tussen 30-200 liggen';

  @override
  String get resistanceRange => 'Weerstand moet tussen 1-20 liggen';

  @override
  String get levelRange => 'Niveau moet tussen 1-20 liggen';

  @override
  String get spmRange => 'SPM moet tussen 50-200 liggen';

  @override
  String get noRoutinesSaved => 'Geen routines opgeslagen';

  @override
  String get tapToCreate => 'Tik om te maken';

  @override
  String get tapButtonToCreate => 'Tik op de knop om te maken';

  @override
  String get premiumRoutineSettings => 'Premium routine-instellingen';

  @override
  String get viewMembership => 'Bekijk Premium';

  @override
  String get freeLimitTitle => '2 gratis routines';

  @override
  String get freeLimitMessage => 'Ga Premium voor onbeperkte routines';

  @override
  String get treadmill => 'Loopband';

  @override
  String get cycle => 'Fiets';

  @override
  String get stairmaster => 'Stairmaster';

  @override
  String get selectLanguage => 'Talen';

  @override
  String get selectTheme => 'Thema kiezen';

  @override
  String get selectDifficulty => 'Moeilijkheid kiezen';

  @override
  String get pause => 'Pauze';

  @override
  String get resume => 'Hervatten';

  @override
  String get endWorkout => 'Workout beëindigen';

  @override
  String get endWorkoutConfirm => 'Wil je de workout beëindigen?';

  @override
  String get end => 'Stoppen';

  @override
  String get share => 'Delen';

  @override
  String get rotate => 'Draaien';

  @override
  String get paused => 'GEPAUZEERD';

  @override
  String get pausedTitle => 'Gepauzeerd';

  @override
  String get pausedSubtitle => 'Je kunt doorgaan of de workout beëindigen';

  @override
  String get endWorkoutConfirmationMessage =>
      'Als je nu stopt, wordt de huidige workout beëindigd en ga je naar het overzichtsscherm.';

  @override
  String get workoutComplete => 'Workout voltooid';

  @override
  String get backgroundIntervalNotificationTitle => 'Nieuw interval';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Meldingen bij uitgeschakeld scherm';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Voorbereiden';

  @override
  String get liveActivityInProgress => 'Training bezig';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Interval $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'Voor $duration';
  }

  @override
  String get totalWorkoutTime => 'Totale tijd';

  @override
  String get totalDistance => 'Totale afstand';

  @override
  String get totalTime => 'Totale tijd';

  @override
  String get averageRpm => 'Gemiddelde RPM';

  @override
  String get averageLevel => 'Gemiddeld niveau';

  @override
  String get holdToStop => 'Vasthouden om te stoppen';

  @override
  String get continueWorkout => 'Doorgaan';

  @override
  String get endWorkoutQuestion => 'Wil je de workout beëindigen?';

  @override
  String get workoutPaused => 'De workout is gepauzeerd';

  @override
  String get lvlIncline => 'Helling';

  @override
  String get lvlResistance => 'Niv. weerstand';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Nu upgraden';

  @override
  String get purchase => 'Kopen';

  @override
  String get later => 'Later';

  @override
  String get premiumActivated => 'Premium is geactiveerd';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Routines voor fiets en StairMaster';

  @override
  String get benefitVoiceGuide => 'Gesproken begeleiding per sessie';

  @override
  String get benefitUnlimitedRoutines => 'Onbeperkt routines opslaan';

  @override
  String get noAds => 'Geen advertenties';

  @override
  String get benefitFutureFeatures => 'Alle toekomstige functies inbegrepen';

  @override
  String get voiceGuideBenefit1 => 'In-app gesproken coaching';

  @override
  String get voiceGuideBenefit2 =>
      'Automatische melding bij wisseling van sessie';

  @override
  String get voiceGuideBenefit3 => 'Handsfree focussen op je training';

  @override
  String get routineLimitBenefit1 => 'Onbeperkt routines opslaan';

  @override
  String get routineLimitBenefit2 => 'Gepersonaliseerde routines per doel';

  @override
  String get routineLimitBenefit3 =>
      'Ondersteuning voor loopband, fiets en StairMaster';

  @override
  String get premium_benefit_1 =>
      'Ondersteuning voor <red>fiets & StairMaster</red>';

  @override
  String get premium_benefit_2 => '<red>Gesproken gids</red> per sessie';

  @override
  String get premium_benefit_3 => 'Routines opslaan <red>zonder limiet</red>';

  @override
  String get premium_benefit_4 =>
      'Toekomstige functies <red>levenslang inbegrepen</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/maand';
  }

  @override
  String get premiumSubheadline =>
      'Ontgrendel spraakbegeleiding, fiets- & stairmasterworkouts en onbeperkte routines';

  @override
  String get monthly => 'Maandelijks';

  @override
  String get yearly => 'Jaarlijks';

  @override
  String get lifetime => 'Levenslang';

  @override
  String get freeTrial7Days => '7 dagen gratis proef';

  @override
  String get perMonth => '/maand';

  @override
  String get perYear => '/jaar';

  @override
  String get oneTime => 'Eenmalig';

  @override
  String savePercent(String percent) {
    return 'Bespaar $percent';
  }

  @override
  String get bestValue => 'Beste waarde';

  @override
  String get cancelAnytime => 'Altijd opzegbaar';

  @override
  String get autoRenewableSubscription => 'Automatische verlenging';

  @override
  String get terms => 'Voorwaarden';

  @override
  String get privacy => 'Privacy';

  @override
  String get restore => 'Herstellen';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Routine';

  @override
  String get settingsTab => 'Instellingen';

  @override
  String get myTab => 'Mijn';

  @override
  String get close => 'Sluiten';

  @override
  String get premiumFeature => 'Alleen Premium';

  @override
  String get usePremiumTest => 'Premium testen';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day/$month/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Bekijk en start';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Gemiddeld';

  @override
  String get advanced => 'Geavanceerd';

  @override
  String get viewRecommendedRoutines => 'Tips →';

  @override
  String get recommendedRoutinesTreadmill => 'Loopband-tips';

  @override
  String get recommendedRoutinesCycle => 'Fiets-tips';

  @override
  String get recommendedRoutinesStairmaster => 'Stairmaster-tips';

  @override
  String get alreadySaved => 'Al opgeslagen';

  @override
  String get routineSaved => 'Routine opgeslagen';

  @override
  String get checkRoutine => 'Bekijk';

  @override
  String get saveRoutine => 'Routine opslaan';

  @override
  String get routineAlreadySaved => 'Routine al opgeslagen';

  @override
  String get noTemplatesFound => 'Geen sjablonen gevonden';

  @override
  String get avg => 'Gem.';

  @override
  String get avgRpm => 'Gem. RPM';

  @override
  String get avgLevel => 'Gem. niveau';

  @override
  String get templateTreadmillBeginner1Title => 'Loopband Beginner 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 wandelen en hardlopen na 3 min warming-up';

  @override
  String get templateTreadmillBeginner2Title => 'Loopband Beginner 2 (Helling)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Hellingwandelen met lage gewrichtsbelasting';

  @override
  String get templateTreadmillIntermediate1Title => 'Loopband Gevorderd 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      '1:1 hardloopinterval voor vetverbranding';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Loopband Gevorderd 2 (Snelheid)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Piramide snelheidstraining run';

  @override
  String get templateTreadmillAdvanced1Title => 'Loopband Expert 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Cardio-blast interval met hoge intensiteit';

  @override
  String get templateTreadmillAdvanced2Title => 'Loopband Expert 2 (Sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Korte sprintherhalingen met hoge intensiteit';

  @override
  String get templateCycleBeginner1Title => 'Fiets Beginner 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Pedaaltraining door RPM aan te passen';

  @override
  String get templateCycleBeginner2Title => 'Fiets Beginner 2 (Constant)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Duurtraining bij constante weerstand';

  @override
  String get templateCycleIntermediate1Title => 'Fiets Gevorderd 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 min hoog tempo / 1 min herstel spin';

  @override
  String get templateCycleIntermediate2Title => 'Fiets Gevorderd 2 (Heuvel)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Heuvelopwaarts fietsen bij hoge weerstand';

  @override
  String get templateCycleAdvanced1Title => 'Fiets Expert 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      '30s krachtintervallen bij hoge weerstand';

  @override
  String get templateCycleAdvanced2Title => 'Fiets Expert 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      '20s/10s Tabata-circuit voor vetverbranding';

  @override
  String get templateStairmasterBeginner1Title => 'Stairmaster Beginner 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Veilig traplopen op aanpassingssnelheid';

  @override
  String get templateStairmasterBeginner2Title =>
      'Stairmaster Beginner 2 (Constant)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Aerobe trapsimulatie op constant tempo';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Stairmaster Gevorderd 1 (Klim)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 min klim / 1 min herstel bilspieren';

  @override
  String get templateStairmasterIntermediate2Title => 'Stairmaster Gevorderd 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Intervallen met afwisselend snel/langzaam tempo';

  @override
  String get templateStairmasterAdvanced1Title => 'Stairmaster Expert 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Intensieve 2-minuten bloktraining';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Stairmaster Expert 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s snelle klim / 60s herstel';

  @override
  String get historyTab => 'Geschiedenis';

  @override
  String get calendarTab => 'Kalender';

  @override
  String get weightTab => 'Gewicht';

  @override
  String get bike => 'Fiets';

  @override
  String get thisWeek => 'Deze week';

  @override
  String get trend => 'Gewichtsverloop';

  @override
  String get timeframe7D => '7D';

  @override
  String get timeframe30D => '30D';

  @override
  String get timeframe90D => '90D';

  @override
  String get timeframeAll => 'ALLES';

  @override
  String get history => 'Geschiedenis';

  @override
  String get seeAll => 'Alles bekijken';

  @override
  String get weightEntryDeleted => 'Gewichtmeting verwijderd';

  @override
  String get weightUpdated => 'Gewicht bijgewerkt';

  @override
  String get editWeight => 'Gewicht bewerken';

  @override
  String get recordWeight => 'Gewicht invoeren';

  @override
  String get quickAdjust => 'Snel aanpassen';

  @override
  String get goalWeightSet => 'Doelgewicht ingesteld';

  @override
  String get goalWeightRemoved => 'Doelgewicht uitgeschakeld';

  @override
  String get goalAchieved => 'Doel bereikt!';

  @override
  String get goalMatchesCurrentWeight => 'Doel is gelijk aan huidig gewicht';

  @override
  String get setGoal => 'Doel instellen';

  @override
  String get suggested => 'Aanbevolen';

  @override
  String get removeGoal => 'Doel wissen';

  @override
  String get addOneMoreRecordToSeeTrend =>
      'Voeg 1 meting toe om de trend te zien';

  @override
  String get noWeightRecorded => 'Nog geen gewicht geregistreerd';

  @override
  String get startTrackingYourWeight => 'Log je gewicht om voortgang te volgen';

  @override
  String get treadmillSession => 'Loopbandsessie';

  @override
  String get bikeSession => 'Fietssessie';

  @override
  String get stairmasterSession => 'Stairmaster-sessie';

  @override
  String get treadmillWorkout => 'Loopband-workout';

  @override
  String get bikeWorkout => 'Fietstraining';

  @override
  String get stairmasterWorkout => 'Stairmaster-workout';

  @override
  String get startAWorkoutToSeeItHere => 'Je workouts verschijnen hier';

  @override
  String get mon => 'ma';

  @override
  String get tue => 'di';

  @override
  String get wed => 'wo';

  @override
  String get thu => 'do';

  @override
  String get fri => 'vr';

  @override
  String get sat => 'za';

  @override
  String get sun => 'zo';

  @override
  String get sessions => 'Sessies';

  @override
  String get distance => 'Afstand';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get noWorkoutsYet => 'Nog geen workouts';

  @override
  String get startYourFirstWorkout =>
      'Start je eerste workout om je geschiedenis te zien';

  @override
  String get goToRoutines => 'Naar routines';

  @override
  String get weightRecorded => 'Gewicht geregistreerd';

  @override
  String get workout => 'workout';

  @override
  String get workouts => 'workouts';

  @override
  String get goal => 'Doel';

  @override
  String get toGo => 'te gaan';

  @override
  String get over => 'over';

  @override
  String get last => 'Laatste';

  @override
  String get newLabel => 'Nieuw';

  @override
  String youNeed(String amount, String goal) {
    return 'Je hebt $amount nodig om $goal te bereiken';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'Je hebt +$amount nodig om $goal te bereiken';
  }

  @override
  String get current => 'Huidig';

  @override
  String get premiumHeadline => 'Dezelfde 30 minuten, andere resultaten';

  @override
  String get premiumSubheadlineNew =>
      'Ren niet zomaar, train op de vetverbrandingsmanier';

  @override
  String get mostPopular => 'Meest populair';

  @override
  String dailyPrice(int price) {
    return '$price per dag';
  }

  @override
  String get benefitVoiceCoaching => 'Premium Spraakcoaching Systeem';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Intervalmeldingen terwijl je andere apps gebruikt';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Volledige Ondersteuning voor Alle Cardio-apparatuur';

  @override
  String get benefitUnlimitedRoutinesNew => 'Onbeperkte Routine-bibliotheek';

  @override
  String get benefitWeightFeature => 'Slimme Gewichtstracking & Analyse';

  @override
  String get benefitNoAdsFocus => 'Advertentievrije Premium Ervaring';

  @override
  String get benefitFutureFeaturesNew =>
      'Alle toekomstige premiumfuncties inbegrepen';

  @override
  String get mostChosen => 'Topkeuze';

  @override
  String get canChangeAnytime => 'Altijd wijzigbaar';

  @override
  String get startPremium => 'Ga Premium';

  @override
  String get cancelAnytimeKeepAccess => 'Altijd opzegbaar, toegang blijft';

  @override
  String workoutDays(String count) {
    return 'Trainingsdagen: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Rustdagen: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Herinneringen';

  @override
  String get workoutReminderOff => 'Uit';

  @override
  String get workoutReminderEveryDay => 'Elke dag';

  @override
  String get workoutReminderSelectTime => 'Tijd kiezen';

  @override
  String get workoutReminderPermissionRequired =>
      'Meldingtoestemming is vereist.';

  @override
  String get workoutReminderTimeLabel => 'Tijd';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Probeer deze intervaltraining op Valcue!\n\nRoutine: $routineName\n\nKopieer of tik op de link om te importeren:\n$shareLink';
  }

  @override
  String get scanQrCode => 'QR-code scannen';

  @override
  String get invalidQrCode => 'Deze QR-code is geen Valcue-routine.';

  @override
  String get previousMonth => 'Vorige maand';

  @override
  String get nextMonth => 'Volgende maand';

  @override
  String get placeQrInside => 'Plaats de QR-code binnen het kader.';

  @override
  String get customRoutineBuilder => 'Persoonlijke routine maken';

  @override
  String get customRoutineGenerating =>
      'Je persoonlijke routine wordt gemaakt…';

  @override
  String get customRoutineLoadingTarget =>
      'Je intensiteitsdoel wordt ingesteld…';

  @override
  String get customRoutineLoadingStructure =>
      'Warming-up en cooling-down worden opgebouwd…';

  @override
  String get customRoutineLoadingPace => 'Je intervaltempo wordt berekend…';

  @override
  String get customRoutineLoadingVoice => 'Stemcoaching wordt voorbereid…';

  @override
  String get generationComplete => 'Routine gemaakt!';

  @override
  String get regenerate => 'Opnieuw maken';

  @override
  String get caloriesEstimateByWeight =>
      'Calorieën zijn een schatting op basis van het ingevoerde gewicht.';

  @override
  String get commonBack => 'Terug';

  @override
  String get adjustGoals => 'Doelen aanpassen';

  @override
  String get targetCalories => 'Doelcalorieën';

  @override
  String get targetStairs => 'Doelverdiepingen';

  @override
  String get targetDistance => 'Doelafstand';

  @override
  String get currentWeight => 'Huidig gewicht';

  @override
  String get includeIncline => 'Helling gebruiken';

  @override
  String get includeWarmupCooldown => 'Warming-up en cooling-down opnemen';

  @override
  String get generateCustomRoutine => 'Persoonlijke routine maken';

  @override
  String durationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String floorCount(String count) {
    return 'Verdiepingen: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Persoonlijke hardlooptraining $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Persoonlijke fietstraining $distance $distanceUnit ($calories kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Opbouwloop $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Piramideloop $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Opbouwfietstraining $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Piramidefietstraining $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Persoonlijke traptraining $floors verdiepingen ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Je persoonlijke routine is klaar. Richt je op ongeveer $calories calorieën!';
  }

  @override
  String get weightDeleteTitle => 'Item verwijderen';

  @override
  String get weightDeleteConfirm =>
      'Weet je zeker dat je deze gewichtsmeting wilt verwijderen?';

  @override
  String get achievementUnlocked => '🏆 Prestatie ontgrendeld!';

  @override
  String get achievementCongratulations =>
      'Gefeliciteerd! Je hebt een nieuwe badge verdiend.';

  @override
  String get awesome => 'Geweldig!';

  @override
  String get shareCardDefault => '9:14 (Standaard)';

  @override
  String get shareCardStory => '9:16 (Verhaal)';

  @override
  String get shareCardSquare => '1:1 (Vierkant)';

  @override
  String get customizeShareCard => 'Deelkaart aanpassen';

  @override
  String get shareRoutine => 'Routine delen';

  @override
  String get shareViaQrCode => 'Delen via QR-code';

  @override
  String get routineLimitReached => 'Routinelimiet bereikt';

  @override
  String get routineLimitMessage =>
      'Gratis gebruikers kunnen maximaal 2 loopbandroutines opslaan. Upgrade naar Premium of verwijder een bestaande routine.';

  @override
  String get importSharedRoutine => 'Gedeelde routine importeren';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'Er is een routine gevonden in de QR-code.\n\n• Naam: $name\n• Moeilijkheid: $difficulty\n• Intervallen: $count\n\nWil je deze in je bibliotheek opslaan?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'Er is een gedeelde routine gevonden op het klembord.\n\n• Naam: $name\n• Moeilijkheid: $difficulty\n• Intervallen: $count\n\nWil je deze in je bibliotheek opslaan?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '‘$name’ is geïmporteerd!';
  }

  @override
  String get importAction => 'Importeren';

  @override
  String get addRoutineOption => 'Kies hoe je een routine toevoegt';

  @override
  String get createCustomRoutine => 'Eigen routine maken';

  @override
  String get importFromClipboard => 'Importeren van klembord';

  @override
  String get countdownTiming => 'Countdownmeldingen';

  @override
  String get noAnnouncements => 'Geen meldingen';

  @override
  String secondsShort(String seconds) {
    return '$seconds s vooraf';
  }

  @override
  String get selectCountdownTimings => 'Countdownmomenten kiezen';

  @override
  String get countdownTimingMessage =>
      'Kies wanneer je de resterende tijd wilt horen voordat het interval verandert.';

  @override
  String secondsLeft(String seconds) {
    return 'Nog $seconds sec.';
  }

  @override
  String get qrShareInstruction =>
      'Scan deze QR-code met een andere Valcue-app\nom de routine direct te importeren.';

  @override
  String get quickStart => 'Snel starten';

  @override
  String get sessionRepeatBlock => 'Herhaald sessieblok';

  @override
  String repeatTimes(String count) {
    return 'Herhalingen: $count';
  }

  @override
  String get addRepeatBlock => 'Herhaalblok toevoegen';

  @override
  String get unableToShareWorkout => 'Training kan niet worden gedeeld.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'Privacybeleid kan niet worden geopend.';

  @override
  String get unableToOpenLink => 'Link kan niet worden geopend.';

  @override
  String get less => 'Minder';

  @override
  String get more => 'Meer';

  @override
  String inclineValue(String value) {
    return 'Helling: $value%';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return 'Hierna: $value';
  }

  @override
  String get weightCalendar => 'Gewichtskalender';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText intervallen · $difficulty',
      one: '$duration · $countText interval · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Doel: $goalWeight • Doel bereikt!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Doel: $goalWeight • Nog $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Doel: $goalWeight • $difference erboven';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Gem. $value km/u';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Gem. $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Gem. $value omw/min';
  }

  @override
  String averageLevelValue(String value) {
    return 'Gem. niveau $value';
  }

  @override
  String get purchaseFailed => 'Aankoop mislukt. Probeer het opnieuw.';

  @override
  String get restoreSuccess => 'Je aankopen zijn hersteld.';

  @override
  String get restoreNothingToRestore =>
      'Er zijn geen eerdere aankopen gevonden.';

  @override
  String get plansUnavailable =>
      'Kan abonnementen niet laden. Probeer het later opnieuw.';
}
