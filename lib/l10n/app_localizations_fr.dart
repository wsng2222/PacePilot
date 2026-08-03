// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Taille de l’écran d’entraînement';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Agrandit les données principales et le minuteur.';

  @override
  String get workoutDisplaySizeStandard => 'Normal';

  @override
  String get workoutDisplaySizeLarge => 'Grand';

  @override
  String get workoutDisplaySizeExtraLarge => 'Maximum';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get system => 'Système';

  @override
  String get voiceGuide => 'Guide Vocal';

  @override
  String get audioNavigator => 'Navigateur Audio';

  @override
  String get soundEffects => 'Effets Sonores';

  @override
  String get unitSetting => 'Unités';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Apparence';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get smartwatchSync => 'Synchronisation Smartwatch';

  @override
  String get connectSmartwatch => 'Se connecter à la smartwatch';

  @override
  String get connect => 'Connecter';

  @override
  String get about => 'À propos';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get translationComingSoon =>
      'La traduction sera disponible dans une mise à jour future.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get done => 'Terminé';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get start => 'Démarrer';

  @override
  String get editRoutine => 'Modifier la Routine';

  @override
  String get routineEdit => 'Modifier la Routine';

  @override
  String get name => 'Nom';

  @override
  String get unnamedRoutine => 'Routine Sans Nom';

  @override
  String get difficulty => 'Difficulté';

  @override
  String difficultyColon(String difficulty) {
    return 'Difficulté : $difficulty';
  }

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get interval => 'Intervalle';

  @override
  String get addInterval => 'Ajouter un Intervalle';

  @override
  String get quickTools => 'Actions rapides';

  @override
  String get addDefault => 'Ajouter base';

  @override
  String get duplicateLast => 'Copier la dernière';

  @override
  String get repeatPattern => 'Répéter le motif';

  @override
  String get reorderIntervals => 'Réorganiser';

  @override
  String get reorderMode => 'Mode réorganisation';

  @override
  String get reorderModeHint =>
      'Maintenez une carte appuyée pour la déplacer à l\'endroit souhaité.';

  @override
  String get patternLength => 'Longueur du motif';

  @override
  String get repeatCount => 'Répétitions';

  @override
  String get noIntervals => 'Aucun intervalle';

  @override
  String get addIntervalPrompt => 'Ajouter un intervalle';

  @override
  String get intervalEdit => 'Modifier l\'Intervalle';

  @override
  String get timeMinutes => 'Temps (minutes)';

  @override
  String get duration => 'Durée';

  @override
  String get speed => 'Vitesse';

  @override
  String get speedKmh => 'Vitesse (km/h)';

  @override
  String get incline => 'Inclinaison';

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
      'Le RPM indique combien de fois vos pédales tournent en une minute. Un RPM plus élevé signifie que vous pédalez avec une cadence plus rapide.';

  @override
  String get resistance => 'Résistance';

  @override
  String get resistanceLevel => 'Résistance (Niveau)';

  @override
  String resistanceColon(String resistance) {
    return 'Résistance $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (pas/min)';

  @override
  String get saved => 'Enregistré';

  @override
  String get deleted => 'Supprimé';

  @override
  String get deleteRoutineTitle => 'Supprimer la Routine';

  @override
  String get deleteRoutineMessage =>
      'Êtes-vous sûr de vouloir supprimer cette routine ? Cette action est irréversible.';

  @override
  String get deleteError => 'Une erreur s\'est produite lors de la suppression';

  @override
  String get nameRequired => 'Veuillez entrer un nom';

  @override
  String get nameMaxLength => 'Le nom doit contenir 50 caractères ou moins';

  @override
  String get minIntervalsRequired => 'Au moins un intervalle est requis';

  @override
  String get intervalMinDuration =>
      'La durée de l\'intervalle doit être d\'au moins 1 seconde';

  @override
  String get intervalMaxDuration =>
      'La durée de l\'intervalle doit être d\'au plus 3 heures (10800 secondes)';

  @override
  String get speedRange =>
      'La vitesse doit être supérieure à 0 (0.5-25.0 km/h)';

  @override
  String get inclineRange => 'L\'inclinaison doit être dans la plage 0-15.0';

  @override
  String get rpmRange => 'RPM doit être dans la plage 30-200';

  @override
  String get resistanceRange => 'La résistance doit être dans la plage 1-20';

  @override
  String get levelRange => 'Le niveau doit être dans la plage 1-20';

  @override
  String get spmRange => 'SPM doit être dans la plage 50-200';

  @override
  String get noRoutinesSaved => 'Aucune routine enregistrée';

  @override
  String get tapToCreate => 'Appuyez pour créer';

  @override
  String get tapButtonToCreate => 'Appuyez sur le bouton pour créer';

  @override
  String get premiumRoutineSettings => 'Paramètres de Routine Premium';

  @override
  String get viewMembership => 'Voir Premium';

  @override
  String get freeLimitTitle => '2 routines gratuites';

  @override
  String get freeLimitMessage =>
      'Passez à Premium pour des routines illimitées';

  @override
  String get treadmill => 'Tapis de Course';

  @override
  String get cycle => 'Vélo';

  @override
  String get stairmaster => 'Simulateur d’escalier';

  @override
  String get selectLanguage => 'Langues';

  @override
  String get selectTheme => 'Sélectionner le Thème';

  @override
  String get selectDifficulty => 'Sélectionner la Difficulté';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get endWorkout => 'Terminer l\'Entraînement';

  @override
  String get endWorkoutConfirm => 'Voulez-vous terminer l\'entraînement?';

  @override
  String get end => 'Terminer';

  @override
  String get share => 'Partager';

  @override
  String get rotate => 'Tourner';

  @override
  String get paused => 'EN PAUSE';

  @override
  String get pausedTitle => 'En pause';

  @override
  String get pausedSubtitle =>
      'Vous pouvez continuer ou terminer l\'entraînement';

  @override
  String get endWorkoutConfirmationMessage =>
      'Si vous terminez maintenant, l\'entraînement en cours se terminera et vous passerez à l\'écran de résumé.';

  @override
  String get workoutComplete => 'Entraînement terminé';

  @override
  String get backgroundIntervalNotificationTitle => 'Nouvel intervalle';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Alertes avec l\'écran éteint';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Préparation';

  @override
  String get liveActivityInProgress => 'Entraînement en cours';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Intervalle $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'Pendant $duration';
  }

  @override
  String get totalWorkoutTime => 'Temps total';

  @override
  String get totalDistance => 'Distance totale';

  @override
  String get totalTime => 'Temps total';

  @override
  String get averageRpm => 'RPM Moyen';

  @override
  String get averageLevel => 'Niveau Moyen';

  @override
  String get holdToStop => 'Maintenir pour arrêter';

  @override
  String get continueWorkout => 'Continuer';

  @override
  String get endWorkoutQuestion => 'Voulez-vous terminer l\'entraînement?';

  @override
  String get workoutPaused => 'L\'entraînement a été mis en pause';

  @override
  String get lvlIncline => 'Inclinaison';

  @override
  String get lvlResistance => 'Niveau Résistance';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Mettre à Niveau Maintenant';

  @override
  String get purchase => 'Acheter';

  @override
  String get later => 'Plus Tard';

  @override
  String get premiumActivated => 'Premium a été activé';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Routines vélo et StairMaster';

  @override
  String get benefitVoiceGuide => 'Guidage vocal pour chaque séance';

  @override
  String get benefitUnlimitedRoutines => 'Sauvegarde illimitée des routines';

  @override
  String get noAds => 'Pas de Publicités';

  @override
  String get benefitFutureFeatures => 'Accès aux fonctionnalités futures';

  @override
  String get voiceGuideBenefit1 => 'Entraînement guidé par la voix';

  @override
  String get voiceGuideBenefit2 =>
      'Annonce automatique de changement de séance';

  @override
  String get voiceGuideBenefit3 =>
      'Concentrez-vous sur votre routine en mains libres';

  @override
  String get routineLimitBenefit1 => 'Sauvegarde illimitée des routines';

  @override
  String get routineLimitBenefit2 => 'Routines personnalisées par objectif';

  @override
  String get routineLimitBenefit3 => 'Tapis, vélo et StairMaster inclus';

  @override
  String get premium_benefit_1 => 'Support pour <red>vélo et StairMaster</red>';

  @override
  String get premium_benefit_2 => '<red>Guidage vocal</red> pour chaque séance';

  @override
  String get premium_benefit_3 => 'Sauvegarde de routines <red>illimitée</red>';

  @override
  String get premium_benefit_4 =>
      'Fonctionnalités futures <red>incluses à vie</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/mois';
  }

  @override
  String get premiumSubheadline =>
      'Profitez du guide vocal, des entraînements vélo et simulateur d’escalier, et de séances enregistrées en illimité';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get lifetime => 'Illimité';

  @override
  String get freeTrial7Days => 'Essai gratuit de 7 jours';

  @override
  String get perMonth => '/mois';

  @override
  String get perYear => '/an';

  @override
  String get oneTime => 'Paiement unique';

  @override
  String savePercent(String percent) {
    return 'Économisez $percent';
  }

  @override
  String get bestValue => 'Meilleure Valeur';

  @override
  String get cancelAnytime => 'Annuler à tout moment';

  @override
  String get autoRenewableSubscription => 'Renouvellement auto';

  @override
  String get terms => 'Conditions';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get restore => 'Restaurer';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Routine';

  @override
  String get settingsTab => 'Paramètres';

  @override
  String get myTab => 'Moi';

  @override
  String get close => 'Fermer';

  @override
  String get premiumFeature => 'Réservé Premium';

  @override
  String get usePremiumTest => 'Tester Premium';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day/$month/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Aperçu & démarrer';

  @override
  String get beginner => 'Débutant';

  @override
  String get intermediate => 'Intermédiaire';

  @override
  String get advanced => 'Avancé';

  @override
  String get viewRecommendedRoutines => 'Sélection →';

  @override
  String get recommendedRoutinesTreadmill => 'Sélection tapis';

  @override
  String get recommendedRoutinesCycle => 'Sélection vélo';

  @override
  String get recommendedRoutinesStairmaster =>
      'Sélection simulateur d’escalier';

  @override
  String get alreadySaved => 'Déjà enregistré';

  @override
  String get routineSaved => 'Routine enregistrée';

  @override
  String get checkRoutine => 'Aperçu';

  @override
  String get saveRoutine => 'Enregistrer Routine';

  @override
  String get routineAlreadySaved => 'La routine est déjà enregistrée';

  @override
  String get noTemplatesFound => 'Aucun modèle trouvé';

  @override
  String get avg => 'Moy.';

  @override
  String get avgRpm => 'Moy. RPM';

  @override
  String get avgLevel => 'Moy. Niveau';

  @override
  String get templateTreadmillBeginner1Title => 'Tapis Débutant 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 marche et course après 3 min d\'échauffement';

  @override
  String get templateTreadmillBeginner2Title =>
      'Tapis Débutant 2 (Inclinaison)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Marche inclinée avec faible impact articulaire';

  @override
  String get templateTreadmillIntermediate1Title => 'Tapis Intermédiaire 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      'Intervalle de course 1:1 pour brûler les graisses';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Tapis Intermédiaire 2 (Vitesse)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Course progressive en pyramide de vitesse';

  @override
  String get templateTreadmillAdvanced1Title => 'Tapis avancé 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Intervalle cardio de haute intensité';

  @override
  String get templateTreadmillAdvanced2Title => 'Tapis avancé 2 (sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Répétitions de sprints courts à haute intensité';

  @override
  String get templateCycleBeginner1Title => 'Vélo Débutant 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Initiation au pédalage en ajustant les RPM';

  @override
  String get templateCycleBeginner2Title => 'Vélo Débutant 2 (Continu)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Entraînement d\'endurance à résistance fixe';

  @override
  String get templateCycleIntermediate1Title => 'Vélo Intermédiaire 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 min haute vitesse / 1 min récupération';

  @override
  String get templateCycleIntermediate2Title =>
      'Vélo Intermédiaire 2 (Colline)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Montée de colline à haute résistance';

  @override
  String get templateCycleAdvanced1Title => 'Vélo avancé 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      'Intervalles de force de 30s à haute résistance';

  @override
  String get templateCycleAdvanced2Title => 'Vélo avancé 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      'Circuit Tabata 20s/10s pour brûler les graisses';

  @override
  String get templateStairmasterBeginner1Title => 'StairMaster débutant 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Allure progressive pour s’habituer aux marches';

  @override
  String get templateStairmasterBeginner2Title =>
      'StairMaster débutant 2 (Régulier)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Montée d\'escalier aérobie à rythme constant';

  @override
  String get templateStairmasterIntermediate1Title =>
      'StairMaster intermédiaire 1 (Montée)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 min montée / 1 min récupération fessiers';

  @override
  String get templateStairmasterIntermediate2Title =>
      'StairMaster intermédiaire 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Intervalles alternant rythmes rapide et lent';

  @override
  String get templateStairmasterAdvanced1Title => 'StairMaster avancé 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Blocs d\'entraînement intenses de 2 min';

  @override
  String get templateStairmasterAdvanced2Title =>
      'StairMaster avancé 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s montée rapide / 60s récupération';

  @override
  String get historyTab => 'Historique';

  @override
  String get calendarTab => 'Calendrier';

  @override
  String get weightTab => 'Poids';

  @override
  String get bike => 'Vélo';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get trend => 'Évolution du poids';

  @override
  String get timeframe7D => '7J';

  @override
  String get timeframe30D => '30J';

  @override
  String get timeframe90D => '90J';

  @override
  String get timeframeAll => 'TOUT';

  @override
  String get history => 'Historique';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get weightEntryDeleted => 'Entrée de poids supprimée';

  @override
  String get weightUpdated => 'Poids mis à jour';

  @override
  String get editWeight => 'Modifier le poids';

  @override
  String get recordWeight => 'Saisir le poids';

  @override
  String get quickAdjust => 'Ajustement rapide';

  @override
  String get goalWeightSet => 'Poids objectif défini';

  @override
  String get goalWeightRemoved => 'Poids cible désactivé';

  @override
  String get goalAchieved => 'Objectif atteint !';

  @override
  String get goalMatchesCurrentWeight =>
      'L\'objectif correspond au poids actuel';

  @override
  String get setGoal => 'Fixer l\'objectif';

  @override
  String get suggested => 'Suggéré';

  @override
  String get removeGoal => 'Retirer l\'objectif';

  @override
  String get addOneMoreRecordToSeeTrend =>
      'Ajoutez 1 mesure pour voir la tendance';

  @override
  String get noWeightRecorded => 'Aucun poids enregistré';

  @override
  String get startTrackingYourWeight =>
      'Notez votre poids pour suivre vos progrès';

  @override
  String get treadmillSession => 'Session Tapis de Course';

  @override
  String get bikeSession => 'Session Vélo';

  @override
  String get stairmasterSession => 'Séance sur simulateur d’escalier';

  @override
  String get treadmillWorkout => 'Entraînement Tapis de Course';

  @override
  String get bikeWorkout => 'Entraînement Vélo';

  @override
  String get stairmasterWorkout => 'Entraînement sur simulateur d’escalier';

  @override
  String get startAWorkoutToSeeItHere => 'Vos séances apparaîtront ici';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mer';

  @override
  String get thu => 'Jeu';

  @override
  String get fri => 'Ven';

  @override
  String get sat => 'Sam';

  @override
  String get sun => 'Dim';

  @override
  String get sessions => 'Séances';

  @override
  String get distance => 'Distance';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get noWorkoutsYet => 'Aucun entraînement pour le moment';

  @override
  String get startYourFirstWorkout =>
      'Commencez votre premier entraînement pour voir votre historique ici';

  @override
  String get goToRoutines => 'Aller aux Routines';

  @override
  String get weightRecorded => 'Poids enregistré';

  @override
  String get workout => 'entraînement';

  @override
  String get workouts => 'entraînements';

  @override
  String get goal => 'Objectif';

  @override
  String get toGo => 'restant';

  @override
  String get over => 'dépassé';

  @override
  String get last => 'Dernier';

  @override
  String get newLabel => 'Nouveau';

  @override
  String youNeed(String amount, String goal) {
    return 'Il vous faut $amount pour atteindre $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'Il vous faut +$amount pour atteindre $goal';
  }

  @override
  String get current => 'Actuel';

  @override
  String get premiumHeadline =>
      'Les mêmes 30 minutes, des résultats différents';

  @override
  String get premiumSubheadlineNew =>
      'Ne courez pas simplement, faites de l\'exercice pour brûler les graisses';

  @override
  String get mostPopular => 'Le Plus Populaire';

  @override
  String dailyPrice(int price) {
    return '$price par jour';
  }

  @override
  String get benefitVoiceCoaching => 'Système de Coaching Vocal Premium';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Alertes d’intervalle pendant l’utilisation d’autres apps';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Support Complet pour Tous les Équipements Cardio';

  @override
  String get benefitUnlimitedRoutinesNew =>
      'Bibliothèque de Routines Illimitée';

  @override
  String get benefitWeightFeature => 'Suivi et Analyse Intelligents du Poids';

  @override
  String get benefitNoAdsFocus => 'Expérience Premium sans Publicité';

  @override
  String get benefitFutureFeaturesNew =>
      'Toutes les fonctionnalités premium futures incluses';

  @override
  String get mostChosen => 'Top choix';

  @override
  String get canChangeAnytime => 'Changez quand vous voulez';

  @override
  String get startPremium => 'Passez Premium';

  @override
  String get cancelAnytimeKeepAccess =>
      'Annulez quand vous voulez, gardez l\'accès';

  @override
  String workoutDays(String count) {
    return 'Jours d’entraînement : $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Jours de repos : $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Rappels';

  @override
  String get workoutReminderOff => 'Désactivé';

  @override
  String get workoutReminderEveryDay => 'Tous les jours';

  @override
  String get workoutReminderSelectTime => 'Choisir l\'heure';

  @override
  String get workoutReminderPermissionRequired =>
      'L\'autorisation de notification est requise.';

  @override
  String get workoutReminderTimeLabel => 'Heure';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Essayez cette routine d\'entraînement fractionné sur Valcue !\n\nRoutine : $routineName\n\nCopiez ou appuyez sur le lien pour l\'importer :\n$shareLink';
  }

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get placeQrInside =>
      'Placez le code QR à l\'intérieur de la zone de guidage.';

  @override
  String get customRoutineBuilder => 'Créateur de séance personnalisée';

  @override
  String get customRoutineGenerating =>
      'Création de votre séance personnalisée…';

  @override
  String get customRoutineLoadingTarget =>
      'Définition de votre objectif d’intensité…';

  @override
  String get customRoutineLoadingStructure =>
      'Préparation de l’échauffement et du retour au calme…';

  @override
  String get customRoutineLoadingPace =>
      'Calcul de l’allure de chaque intervalle…';

  @override
  String get customRoutineLoadingVoice => 'Préparation du coaching vocal…';

  @override
  String get generationComplete => 'Séance créée !';

  @override
  String get regenerate => 'Recréer';

  @override
  String get caloriesEstimateByWeight =>
      'Les calories sont une estimation basée sur le poids saisi.';

  @override
  String get commonBack => 'Retour';

  @override
  String get adjustGoals => 'Modifier les objectifs';

  @override
  String get targetCalories => 'Calories cibles';

  @override
  String get targetStairs => 'Étages cibles';

  @override
  String get targetDistance => 'Distance cible';

  @override
  String get currentWeight => 'Poids actuel';

  @override
  String get includeIncline => 'Inclure l’inclinaison';

  @override
  String get includeWarmupCooldown =>
      'Inclure l’échauffement et le retour au calme';

  @override
  String get generateCustomRoutine => 'Créer une séance personnalisée';

  @override
  String durationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String floorCount(String count) {
    return 'Étages : $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Course personnalisée $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Vélo personnalisé $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Escaliers personnalisés $floors étages ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Votre séance personnalisée est prête. Visez environ $calories calories !';
  }

  @override
  String get weightDeleteTitle => 'Supprimer la mesure';

  @override
  String get weightDeleteConfirm =>
      'Voulez-vous vraiment supprimer cette mesure de poids ?';

  @override
  String get achievementUnlocked => '🏆 Succès débloqué !';

  @override
  String get achievementCongratulations =>
      'Félicitations ! Vous avez obtenu un nouveau badge.';

  @override
  String get awesome => 'Super !';

  @override
  String get shareCardDefault => '9:14 (Par défaut)';

  @override
  String get shareCardStory => '9:16 (Story)';

  @override
  String get shareCardSquare => '1:1 (Carré)';

  @override
  String get customizeShareCard => 'Personnaliser la carte';

  @override
  String get shareRoutine => 'Partager la séance';

  @override
  String get shareViaQrCode => 'Partager par code QR';

  @override
  String get routineLimitReached => 'Limite de séances atteinte';

  @override
  String get routineLimitMessage =>
      'Les utilisateurs gratuits peuvent enregistrer jusqu’à 2 séances sur tapis. Passez à Premium ou supprimez une séance existante.';

  @override
  String get importSharedRoutine => 'Importer la séance partagée';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'Une séance a été détectée dans le code QR.\n\n• Nom : $name\n• Difficulté : $difficulty\n• Intervalles : $count\n\nVoulez-vous l’enregistrer dans votre bibliothèque ?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'Une séance partagée a été détectée dans le presse-papiers.\n\n• Nom : $name\n• Difficulté : $difficulty\n• Intervalles : $count\n\nVoulez-vous l’enregistrer dans votre bibliothèque ?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '« $name » a bien été importée !';
  }

  @override
  String get importAction => 'Importer';

  @override
  String get addRoutineOption => 'Choisir comment ajouter une séance';

  @override
  String get createCustomRoutine => 'Créer une séance personnalisée';

  @override
  String get importFromClipboard => 'Importer du presse-papiers';

  @override
  String get countdownTiming => 'Annonces du compte à rebours';

  @override
  String get noAnnouncements => 'Aucune annonce';

  @override
  String secondsShort(String seconds) {
    return '$seconds s avant';
  }

  @override
  String get selectCountdownTimings => 'Choisir les annonces';

  @override
  String get countdownTimingMessage =>
      'Choisissez quand entendre le temps restant avant le changement d’intervalle.';

  @override
  String secondsLeft(String seconds) {
    return 'Encore $seconds s';
  }

  @override
  String get qrShareInstruction =>
      'Scannez ce code QR depuis une autre app Valcue\npour importer cette séance instantanément.';

  @override
  String get quickStart => 'Démarrage rapide';

  @override
  String get sessionRepeatBlock => 'Bloc de séance répété';

  @override
  String repeatTimes(String count) {
    return 'Répétitions : $count';
  }

  @override
  String get addRepeatBlock => 'Ajouter un bloc répété';

  @override
  String get unableToShareWorkout => 'Impossible de partager l’entraînement.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'Impossible d’ouvrir la politique de confidentialité.';

  @override
  String get unableToOpenLink => 'Impossible d’ouvrir le lien.';

  @override
  String get less => 'Moins';

  @override
  String get more => 'Plus';

  @override
  String inclineValue(String value) {
    return 'Inclinaison : $value %';
  }

  @override
  String rpmValue(String value) {
    return '$value tr/min';
  }

  @override
  String nextMetric(String value) {
    return 'À suivre : $value';
  }

  @override
  String get weightCalendar => 'Calendrier du poids';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText intervalles · $difficulty',
      one: '$duration · $countText intervalle · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Objectif : $goalWeight • Objectif atteint !';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Objectif : $goalWeight • Encore $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Objectif : $goalWeight • Dépassé de $difference';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Moy. : $value km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Moy. : $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Cadence moy. : $value tr/min';
  }

  @override
  String averageLevelValue(String value) {
    return 'Niveau moy. : $value';
  }

  @override
  String get purchaseFailed => 'L\'achat a échoué. Veuillez réessayer.';

  @override
  String get restoreSuccess => 'Vos achats ont été restaurés.';

  @override
  String get restoreNothingToRestore =>
      'Aucun achat précédent n\'a été trouvé.';

  @override
  String get plansUnavailable =>
      'Impossible de charger les offres. Veuillez réessayer plus tard.';
}
