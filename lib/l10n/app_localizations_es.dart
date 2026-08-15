// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get workoutDisplaySizeTitle =>
      'Tamaño de la pantalla de entrenamiento';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Amplía los datos principales y el temporizador.';

  @override
  String get workoutDisplaySizeStandard => 'Normal';

  @override
  String get workoutDisplaySizeLarge => 'Grande';

  @override
  String get workoutDisplaySizeExtraLarge => 'Máximo';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get system => 'Sistema';

  @override
  String get voiceGuide => 'Guía de Voz';

  @override
  String get audioNavigator => 'Navegador de Audio';

  @override
  String get soundEffects => 'Efectos de Sonido';

  @override
  String get unitSetting => 'Unidades';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => 'Apariencia';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get smartwatchSync => 'Sincronización de Smartwatch';

  @override
  String get connectSmartwatch => 'Conectar con smartwatch';

  @override
  String get connect => 'Conectar';

  @override
  String get about => 'Acerca de';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get translationComingSoon =>
      'La traducción estará disponible en una actualización futura.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Hecho';

  @override
  String get delete => 'Eliminar';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get start => 'Iniciar';

  @override
  String get editRoutine => 'Editar Rutina';

  @override
  String get routineEdit => 'Editar Rutina';

  @override
  String get name => 'Nombre';

  @override
  String get unnamedRoutine => 'Rutina Sin Nombre';

  @override
  String get difficulty => 'Dificultad';

  @override
  String difficultyColon(String difficulty) {
    return 'Dificultad : $difficulty';
  }

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get interval => 'Intervalo';

  @override
  String get addInterval => 'Agregar Intervalo';

  @override
  String get quickTools => 'Acciones rápidas';

  @override
  String get addDefault => 'Añadir base';

  @override
  String get duplicateLast => 'Duplicar última';

  @override
  String get repeatPattern => 'Repetir patrón';

  @override
  String get reorderIntervals => 'Reordenar';

  @override
  String get reorderMode => 'Modo de reordenación';

  @override
  String get reorderModeHint =>
      'Mantén pulsada una tarjeta para moverla a la posición que quieras.';

  @override
  String get patternLength => 'Largo del patrón';

  @override
  String get repeatCount => 'Repeticiones';

  @override
  String get noIntervals => 'No hay intervalos';

  @override
  String get addIntervalPrompt => 'Agregar un intervalo';

  @override
  String get intervalEdit => 'Editar Intervalo';

  @override
  String get timeMinutes => 'Tiempo (minutos)';

  @override
  String get duration => 'Duración';

  @override
  String get speed => 'Velocidad';

  @override
  String get speedKmh => 'Velocidad (km/h)';

  @override
  String get incline => 'Inclinación';

  @override
  String get level => 'Nivel';

  @override
  String levelColon(String level) {
    return 'Nivel $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPM muestra cuántas veces giran tus pedales en un minuto. Un RPM más alto significa que pedaleas con una cadencia más rápida.';

  @override
  String get resistance => 'Resistencia';

  @override
  String get resistanceLevel => 'Resistencia (Nivel)';

  @override
  String resistanceColon(String resistance) {
    return 'Resistencia $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM (pasos/min)';

  @override
  String get saved => 'Guardado';

  @override
  String get deleted => 'Eliminado';

  @override
  String get deleteRoutineTitle => 'Eliminar Rutina';

  @override
  String get deleteRoutineMessage =>
      '¿Estás seguro de que quieres eliminar esta rutina? Esto no se puede deshacer.';

  @override
  String get deleteError => 'Ocurrió un error al eliminar';

  @override
  String get nameRequired => 'Por favor ingresa un nombre';

  @override
  String get nameMaxLength => 'El nombre debe tener 50 caracteres o menos';

  @override
  String get minIntervalsRequired => 'Se requiere al menos un intervalo';

  @override
  String get intervalMinDuration =>
      'La duración del intervalo debe ser de al menos 1 segundo';

  @override
  String get intervalMaxDuration =>
      'La duración del intervalo debe ser de máximo 3 horas (10800 segundos)';

  @override
  String get speedRange => 'La velocidad debe ser mayor que 0 (0.5-25.0 km/h)';

  @override
  String get inclineRange => 'La inclinación debe estar en el rango 0-15.0';

  @override
  String get rpmRange => 'RPM debe estar en el rango 30-200';

  @override
  String get resistanceRange => 'La resistencia debe estar en el rango 1-20';

  @override
  String get levelRange => 'El nivel debe estar en el rango 1-20';

  @override
  String get spmRange => 'SPM debe estar en el rango 50-200';

  @override
  String get noRoutinesSaved => 'No hay rutinas guardadas';

  @override
  String get tapToCreate => 'Toca para crear';

  @override
  String get tapButtonToCreate => 'Toca el botón para crear';

  @override
  String get premiumRoutineSettings => 'Configuración de Rutina Premium';

  @override
  String get viewMembership => 'Ver Premium';

  @override
  String get freeLimitTitle => '2 rutinas gratis';

  @override
  String get freeLimitMessage => 'Pásate a Premium para rutinas ilimitadas';

  @override
  String get treadmill => 'Cinta de Correr';

  @override
  String get cycle => 'Bicicleta';

  @override
  String get stairmaster => 'Escaladora';

  @override
  String get selectLanguage => 'Idiomas';

  @override
  String get selectTheme => 'Seleccionar Tema';

  @override
  String get selectDifficulty => 'Seleccionar Dificultad';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Continuar';

  @override
  String get endWorkout => 'Finalizar Entrenamiento';

  @override
  String get endWorkoutConfirm => '¿Quieres finalizar el entrenamiento?';

  @override
  String get end => 'Finalizar';

  @override
  String get share => 'Compartir';

  @override
  String get rotate => 'Rotar';

  @override
  String get paused => 'PAUSADO';

  @override
  String get pausedTitle => 'Pausado';

  @override
  String get pausedSubtitle => 'Puedes continuar o finalizar el entrenamiento';

  @override
  String get endWorkoutConfirmationMessage =>
      'Si finalizas ahora, el entrenamiento actual terminará y pasarás a la pantalla de resumen.';

  @override
  String get workoutComplete => 'Entrenamiento completo';

  @override
  String get backgroundIntervalNotificationTitle => 'Nuevo intervalo';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Alertas con la pantalla apagada';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Preparando';

  @override
  String get liveActivityInProgress => 'Entrenamiento en curso';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Intervalo $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'Durante $duration';
  }

  @override
  String get totalWorkoutTime => 'Tiempo total';

  @override
  String get totalDistance => 'Distancia total';

  @override
  String get totalTime => 'Tiempo total';

  @override
  String get averageRpm => 'RPM Promedio';

  @override
  String get averageLevel => 'Nivel Promedio';

  @override
  String get holdToStop => 'Mantén para detener';

  @override
  String get continueWorkout => 'Continuar';

  @override
  String get endWorkoutQuestion => '¿Quieres finalizar el entrenamiento?';

  @override
  String get workoutPaused => 'El entrenamiento ha sido pausado';

  @override
  String get lvlIncline => 'Inclinación';

  @override
  String get lvlResistance => 'Nivel Resistencia';

  @override
  String get premium => 'Premium';

  @override
  String get upgradeNow => 'Actualizar Ahora';

  @override
  String get purchase => 'Comprar';

  @override
  String get later => 'Más Tarde';

  @override
  String get premiumActivated => 'Premium ha sido activado';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'Rutinas de bicicleta y StairMaster';

  @override
  String get benefitVoiceGuide => 'Guía de voz para cada sesión';

  @override
  String get benefitUnlimitedRoutines => 'Guardado ilimitado de rutinas';

  @override
  String get noAds => 'Sin Anuncios';

  @override
  String get benefitFutureFeatures => 'Acceso a todas las funciones futuras';

  @override
  String get voiceGuideBenefit1 => 'Entrenamiento guiado por voz';

  @override
  String get voiceGuideBenefit2 => 'Anuncio automático de cambio de sesión';

  @override
  String get voiceGuideBenefit3 => 'Concéntrate en tu rutina con manos libres';

  @override
  String get routineLimitBenefit1 => 'Guardado ilimitado de rutinas';

  @override
  String get routineLimitBenefit2 => 'Rutinas personalizadas por objetivo';

  @override
  String get routineLimitBenefit3 =>
      'Soporte para cinta, bicicleta y escalador';

  @override
  String get premium_benefit_1 =>
      'Soporte para <red>bicicleta y StairMaster</red>';

  @override
  String get premium_benefit_2 => '<red>Guía por voz</red> para cada sesión';

  @override
  String get premium_benefit_3 => 'Guardado de rutinas <red>ilimitado</red>';

  @override
  String get premium_benefit_4 =>
      'Todas las funciones futuras <red>incluidas de por vida</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/mes';
  }

  @override
  String get premiumSubheadline =>
      'Desbloquea guía de voz, entrenamientos de bicicleta y escaladora, y rutinas ilimitadas';

  @override
  String get monthly => 'Mensual';

  @override
  String get yearly => 'Anual';

  @override
  String get lifetime => 'Vitalicio';

  @override
  String get freeTrial7Days => 'Prueba gratis de 7 días';

  @override
  String get perMonth => '/mes';

  @override
  String get perYear => '/año';

  @override
  String get oneTime => 'Única';

  @override
  String savePercent(String percent) {
    return 'Ahorra un $percent';
  }

  @override
  String get bestValue => 'Mejor Valor';

  @override
  String get cancelAnytime => 'Cancela en cualquier momento';

  @override
  String get autoRenewableSubscription => 'Renovación automática';

  @override
  String get terms => 'Términos';

  @override
  String get privacy => 'Privacidad';

  @override
  String get restore => 'Restaurar';

  @override
  String get premiumTab => 'Premium';

  @override
  String get routineTab => 'Rutina';

  @override
  String get settingsTab => 'Configuración';

  @override
  String get myTab => 'Mi';

  @override
  String get close => 'Cerrar';

  @override
  String get premiumFeature => 'Solo Premium';

  @override
  String get usePremiumTest => 'Probar Premium';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day/$month/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Ver y empezar';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advanced => 'Avanzado';

  @override
  String get viewRecommendedRoutines => 'Sugeridas →';

  @override
  String get recommendedRoutinesTreadmill => 'Sugeridas de cinta';

  @override
  String get recommendedRoutinesCycle => 'Sugeridas de bici';

  @override
  String get recommendedRoutinesStairmaster => 'Sugeridas de escaladora';

  @override
  String get alreadySaved => 'Ya guardado';

  @override
  String get routineSaved => 'Rutina guardada';

  @override
  String get checkRoutine => 'Vista previa';

  @override
  String get saveRoutine => 'Guardar Rutina';

  @override
  String get routineAlreadySaved => 'La rutina ya está guardada';

  @override
  String get noTemplatesFound => 'No se encontraron plantillas';

  @override
  String get avg => 'Prom.';

  @override
  String get avgRpm => 'Prom. RPM';

  @override
  String get avgLevel => 'Prom. Nivel';

  @override
  String get templateTreadmillBeginner1Title => 'Cinta Principiante 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 caminar y correr tras 3 min de calentamiento';

  @override
  String get templateTreadmillBeginner2Title =>
      'Cinta Principiante 2 (Inclinación)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Caminata inclinada con bajo impacto articular';

  @override
  String get templateTreadmillIntermediate1Title => 'Cinta Intermedio 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      'Intervalo de carrera 1:1 para quemar grasa';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Cinta Intermedio 2 (Velocidad)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Carrera piramidal de velocidad creciente';

  @override
  String get templateTreadmillAdvanced1Title => 'Cinta Avanzado 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Intervalo de alta intensidad para cardio';

  @override
  String get templateTreadmillAdvanced2Title => 'Cinta Avanzado 2 (Sprint)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Repeticiones cortas de sprint de alta intensidad';

  @override
  String get templateCycleBeginner1Title => 'Bici Principiante 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Iniciación al pedaleo ajustando RPM';

  @override
  String get templateCycleBeginner2Title => 'Bici Principiante 2 (Constante)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Entrenamiento de resistencia a carga fija';

  @override
  String get templateCycleIntermediate1Title => 'Bici Intermedio 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 min alta velocidad / 1 min recuperación';

  @override
  String get templateCycleIntermediate2Title => 'Bici Intermedio 2 (Colina)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Subida de colinas a alta resistencia';

  @override
  String get templateCycleAdvanced1Title => 'Bici Avanzado 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      'Intervalos de fuerza de 30s a alta resistencia';

  @override
  String get templateCycleAdvanced2Title => 'Bici Avanzado 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      'Circuito Tabata de 20s/10s para quemar grasa';

  @override
  String get templateStairmasterBeginner1Title => 'Escalador Principiante 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Caminata segura de adaptación al escalador';

  @override
  String get templateStairmasterBeginner2Title =>
      'Escalador Principiante 2 (Constante)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Subida aeróbica a ritmo constante';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Escalador Intermedio 1 (Subida)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 min de subida / 1 min recuperación de glúteos';

  @override
  String get templateStairmasterIntermediate2Title => 'Escalador Intermedio 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Intervalos alternando ritmo rápido y lento';

  @override
  String get templateStairmasterAdvanced1Title => 'Escalador Avanzado 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Entrenamiento intenso de bloques de 2 min';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Escalador Avanzado 2 (Sprint)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30s de subida rápida / 60s de recuperación';

  @override
  String get historyTab => 'Historial';

  @override
  String get calendarTab => 'Calendario';

  @override
  String get weightTab => 'Peso';

  @override
  String get bike => 'Bicicleta';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get trend => 'Historial de peso';

  @override
  String get timeframe7D => '7D';

  @override
  String get timeframe30D => '30D';

  @override
  String get timeframe90D => '90D';

  @override
  String get timeframeAll => 'Todo';

  @override
  String get history => 'Historial';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get weightEntryDeleted => 'Entrada de peso eliminada';

  @override
  String get weightUpdated => 'Peso actualizado';

  @override
  String get editWeight => 'Editar peso';

  @override
  String get recordWeight => 'Registrar peso';

  @override
  String get quickAdjust => 'Edición rápida';

  @override
  String get goalWeightSet => 'Peso objetivo establecido';

  @override
  String get goalWeightRemoved => 'Peso objetivo desactivado';

  @override
  String get goalAchieved => '¡Objetivo alcanzado!';

  @override
  String get goalMatchesCurrentWeight =>
      'El objetivo coincide con el peso actual';

  @override
  String get setGoal => 'Fijar meta';

  @override
  String get suggested => 'Sugerido';

  @override
  String get removeGoal => 'Quitar meta';

  @override
  String get addOneMoreRecordToSeeTrend =>
      'Añade 1 registro más para ver la tendencia';

  @override
  String get noWeightRecorded => 'Aún no hay peso registrado';

  @override
  String get startTrackingYourWeight =>
      'Registra tu peso para seguir tu progreso';

  @override
  String get treadmillSession => 'Sesión de Cinta';

  @override
  String get bikeSession => 'Sesión de Bicicleta';

  @override
  String get stairmasterSession => 'Sesión de Escaladora';

  @override
  String get treadmillWorkout => 'Entrenamiento de Cinta';

  @override
  String get bikeWorkout => 'Entrenamiento de Bicicleta';

  @override
  String get stairmasterWorkout => 'Entrenamiento de Escaladora';

  @override
  String get startAWorkoutToSeeItHere => 'Tus entrenos aparecerán aquí';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mié';

  @override
  String get thu => 'Jue';

  @override
  String get fri => 'Vie';

  @override
  String get sat => 'Sáb';

  @override
  String get sun => 'Dom';

  @override
  String get sessions => 'Sesiones';

  @override
  String get distance => 'Distancia';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get noWorkoutsYet => 'Aún no hay entrenamientos';

  @override
  String get startYourFirstWorkout =>
      'Comienza tu primer entrenamiento para ver tu historial aquí';

  @override
  String get goToRoutines => 'Ir a Rutinas';

  @override
  String get weightRecorded => 'Peso registrado';

  @override
  String get workout => 'entrenamiento';

  @override
  String get workouts => 'entrenamientos';

  @override
  String get goal => 'Objetivo';

  @override
  String get toGo => 'restante';

  @override
  String get over => 'sobre';

  @override
  String get last => 'Último';

  @override
  String get newLabel => 'Nuevo';

  @override
  String youNeed(String amount, String goal) {
    return 'Necesitas $amount para alcanzar $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'Necesitas +$amount para alcanzar $goal';
  }

  @override
  String get current => 'Actual';

  @override
  String get premiumHeadline => 'Los mismos 30 minutos, resultados diferentes';

  @override
  String get premiumSubheadlineNew =>
      'No solo corras, ejercítate de forma que queme grasa';

  @override
  String get mostPopular => 'Más Popular';

  @override
  String dailyPrice(int price) {
    return '$price por día';
  }

  @override
  String get benefitVoiceCoaching => 'Sistema de Entrenamiento por Voz Premium';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Alertas de intervalos mientras usas otras apps';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Soporte Completo para Todo Equipo Cardio';

  @override
  String get benefitUnlimitedRoutinesNew => 'Biblioteca de Rutinas Ilimitadas';

  @override
  String get benefitWeightFeature =>
      'Seguimiento y Análisis Inteligente de Peso';

  @override
  String get benefitNoAdsFocus => 'Experiencia Premium sin Anuncios';

  @override
  String get benefitFutureFeaturesNew =>
      'Todas las funciones premium futuras incluidas';

  @override
  String get mostChosen => 'Más elegida';

  @override
  String get canChangeAnytime => 'Cambia cuando quieras';

  @override
  String get startPremium => 'Hazte Premium';

  @override
  String get cancelAnytimeKeepAccess =>
      'Cancela cuando quieras y conserva el acceso';

  @override
  String workoutDays(String count) {
    return 'Días de entrenamiento: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Días de descanso: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Recordatorios';

  @override
  String get workoutReminderOff => 'Desactivado';

  @override
  String get workoutReminderEveryDay => 'Cada día';

  @override
  String get workoutReminderSelectTime => 'Seleccionar hora';

  @override
  String get workoutReminderPermissionRequired =>
      'Se requiere permiso de notificación.';

  @override
  String get workoutReminderTimeLabel => 'Hora';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return '¡Prueba esta rutina de entrenamiento por intervalos en Valcue!\n\nRutina: $routineName\n\nCopia o toca el enlace para importarla:\n$shareLink';
  }

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get invalidQrCode => 'Este código QR no es una rutina de Valcue.';

  @override
  String get previousMonth => 'Mes anterior';

  @override
  String get nextMonth => 'Mes siguiente';

  @override
  String get placeQrInside =>
      'Coloque el código QR dentro del área de la guía.';

  @override
  String get customRoutineBuilder => 'Creador de rutina personalizada';

  @override
  String get customRoutineGenerating => 'Creando tu rutina personalizada...';

  @override
  String get customRoutineLoadingTarget =>
      'Definiendo tu objetivo de intensidad...';

  @override
  String get customRoutineLoadingStructure =>
      'Preparando calentamiento y vuelta a la calma...';

  @override
  String get customRoutineLoadingPace =>
      'Calculando el ritmo de cada intervalo...';

  @override
  String get customRoutineLoadingVoice =>
      'Preparando las indicaciones de voz...';

  @override
  String get generationComplete => '¡Rutina creada!';

  @override
  String get regenerate => 'Volver a crear';

  @override
  String get caloriesEstimateByWeight =>
      'Las calorías son una estimación basada en el peso introducido.';

  @override
  String get commonBack => 'Atrás';

  @override
  String get adjustGoals => 'Ajustar objetivos';

  @override
  String get targetCalories => 'Calorías objetivo';

  @override
  String get targetStairs => 'Pisos objetivo';

  @override
  String get targetDistance => 'Distancia objetivo';

  @override
  String get currentWeight => 'Peso actual';

  @override
  String get includeIncline => 'Incluir inclinación';

  @override
  String get includeWarmupCooldown =>
      'Incluir calentamiento y vuelta a la calma';

  @override
  String get generateCustomRoutine => 'Crear rutina personalizada';

  @override
  String durationMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String floorCount(String count) {
    return 'Pisos: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Carrera personalizada $distance $distanceUnit ($calories kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Ciclismo personalizado $distance $distanceUnit ($calories kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Carrera Progresiva $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Carrera en Pirámide $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Ciclismo Progresivo $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Ciclismo en Pirámide $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Escaleras personalizadas $floors pisos ($calories kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Tu rutina personalizada está lista. ¡Apunta a unas $calories calorías!';
  }

  @override
  String get weightDeleteTitle => 'Eliminar registro';

  @override
  String get weightDeleteConfirm =>
      '¿Seguro que quieres eliminar este registro de peso?';

  @override
  String get achievementUnlocked => '🏆 ¡Logro desbloqueado!';

  @override
  String get achievementCongratulations =>
      '¡Enhorabuena! Has conseguido una insignia nueva.';

  @override
  String get awesome => '¡Genial!';

  @override
  String get shareCardDefault => '9:14 (Predeterminado)';

  @override
  String get shareCardStory => '9:16 (Historia)';

  @override
  String get shareCardSquare => '1:1 (Cuadrado)';

  @override
  String get customizeShareCard => 'Personalizar tarjeta';

  @override
  String get shareRoutine => 'Compartir rutina';

  @override
  String get shareViaQrCode => 'Compartir por código QR';

  @override
  String get routineLimitReached => 'Límite de rutinas alcanzado';

  @override
  String get routineLimitMessage =>
      'Los usuarios gratuitos pueden guardar hasta 2 rutinas de cinta. Mejora a Premium o elimina una rutina existente.';

  @override
  String get importSharedRoutine => 'Importar rutina compartida';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'Se detectó una rutina en el código QR.\n\n• Nombre: $name\n• Dificultad: $difficulty\n• Intervalos: $count\n\n¿Quieres guardarla en tu biblioteca?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'Se detectó una rutina compartida en el portapapeles.\n\n• Nombre: $name\n• Dificultad: $difficulty\n• Intervalos: $count\n\n¿Quieres guardarla en tu biblioteca?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '¡Se importó «$name» correctamente!';
  }

  @override
  String get importAction => 'Importar';

  @override
  String get addRoutineOption => 'Elige cómo añadir una rutina';

  @override
  String get createCustomRoutine => 'Crear rutina personalizada';

  @override
  String get importFromClipboard => 'Importar del portapapeles';

  @override
  String get countdownTiming => 'Avisos de cuenta atrás';

  @override
  String get noAnnouncements => 'Sin avisos';

  @override
  String secondsShort(String seconds) {
    return '$seconds s antes';
  }

  @override
  String get selectCountdownTimings => 'Seleccionar avisos';

  @override
  String get countdownTimingMessage =>
      'Elige cuándo escuchar el tiempo restante antes de cambiar de intervalo.';

  @override
  String secondsLeft(String seconds) {
    return 'Quedan $seconds s';
  }

  @override
  String get qrShareInstruction =>
      'Escanea este código QR desde otra app Valcue\npara importar la rutina al instante.';

  @override
  String get quickStart => 'Inicio rápido';

  @override
  String get sessionRepeatBlock => 'Bloque de sesión repetido';

  @override
  String repeatTimes(String count) {
    return 'Repeticiones: $count';
  }

  @override
  String get addRepeatBlock => 'Añadir bloque repetido';

  @override
  String get unableToShareWorkout => 'No se pudo compartir el entrenamiento.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'No se pudo abrir la política de privacidad.';

  @override
  String get unableToOpenLink => 'No se pudo abrir el enlace.';

  @override
  String get less => 'Menos';

  @override
  String get more => 'Más';

  @override
  String inclineValue(String value) {
    return 'Inclinación: $value %';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return 'Siguiente: $value';
  }

  @override
  String get weightCalendar => 'Calendario de peso';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText intervalos · $difficulty',
      one: '$duration · $countText intervalo · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Objetivo: $goalWeight • ¡Objetivo alcanzado!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Objetivo: $goalWeight • Faltan $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Objetivo: $goalWeight • $difference por encima';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Prom. $value km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Prom. $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return 'Prom. $value RPM';
  }

  @override
  String averageLevelValue(String value) {
    return 'Nivel medio: $value';
  }

  @override
  String get purchaseFailed => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get restoreSuccess => 'Tus compras se han restaurado.';

  @override
  String get restoreNothingToRestore => 'No se encontraron compras anteriores.';

  @override
  String get plansUnavailable =>
      'No se pudieron cargar los planes. Inténtalo de nuevo más tarde.';
}
