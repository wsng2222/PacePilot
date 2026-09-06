// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'Размер экрана тренировки';

  @override
  String get workoutDisplaySizeSubtitle =>
      'Увеличивает основные показатели и таймер.';

  @override
  String get workoutDisplaySizeStandard => 'Обычный';

  @override
  String get workoutDisplaySizeLarge => 'Крупный';

  @override
  String get workoutDisplaySizeExtraLarge => 'Макс.';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get system => 'Система';

  @override
  String get voiceGuide => 'Голосовое руководство';

  @override
  String get audioNavigator => 'Аудио навигатор';

  @override
  String get soundEffects => 'Звуковые эффекты';

  @override
  String get unitSetting => 'Единицы';

  @override
  String get kmh => 'км/ч';

  @override
  String get mph => 'миль/ч';

  @override
  String get themeMode => 'Оформление';

  @override
  String get light => 'Светлый';

  @override
  String get dark => 'Темный';

  @override
  String get smartwatchSync => 'Синхронизация со смарт-часами';

  @override
  String get connectSmartwatch => 'Подключиться к смарт-часам';

  @override
  String get connect => 'Подключить';

  @override
  String get about => 'О программе';

  @override
  String get adPrivacyOptions => 'Настройки конфиденциальности рекламы';

  @override
  String version(String version) {
    return 'Версия $version';
  }

  @override
  String get comingSoon => 'Скоро';

  @override
  String get translationComingSoon =>
      'Перевод будет доступен в будущем обновлении.';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get delete => 'Удалить';

  @override
  String get duplicate => 'Дублировать';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get start => 'Начать';

  @override
  String get editRoutine => 'Редактировать';

  @override
  String get routineEdit => 'Редактирование программы';

  @override
  String get name => 'Название';

  @override
  String get unnamedRoutine => 'Программа без названия';

  @override
  String get difficulty => 'Сложность';

  @override
  String difficultyColon(String difficulty) {
    return 'Сложность : $difficulty';
  }

  @override
  String get easy => 'Легко';

  @override
  String get medium => 'Средне';

  @override
  String get hard => 'Сложно';

  @override
  String get interval => 'Интервал';

  @override
  String get addInterval => 'Добавить интервал';

  @override
  String get quickTools => 'Быстрые действия';

  @override
  String get addDefault => 'Добавить базовый';

  @override
  String get duplicateLast => 'Копировать последний';

  @override
  String get repeatPattern => 'Повторить шаблон';

  @override
  String get reorderIntervals => 'Изменить порядок';

  @override
  String get reorderMode => 'Режим изменения порядка';

  @override
  String get reorderModeHint =>
      'Нажмите и удерживайте карточку, чтобы переместить её в нужное место.';

  @override
  String get patternLength => 'Длина шаблона';

  @override
  String get repeatCount => 'Повторы';

  @override
  String get noIntervals => 'Нет интервалов';

  @override
  String get addIntervalPrompt => 'Добавить интервал';

  @override
  String get intervalEdit => 'Редактирование интервала';

  @override
  String get timeMinutes => 'Время (минуты)';

  @override
  String get duration => 'Длительность';

  @override
  String get speed => 'Скорость';

  @override
  String get speedKmh => 'Скорость (км/ч)';

  @override
  String get incline => 'Наклон';

  @override
  String get level => 'Уровень';

  @override
  String levelColon(String level) {
    return 'Уровень $level';
  }

  @override
  String get rpm => 'об/мин';

  @override
  String get rpmInfoDescription =>
      'об/мин показывает, сколько оборотов педали совершают за минуту. Чем выше значение, тем выше темп вращения педалей.';

  @override
  String get resistance => 'Сопротивление';

  @override
  String get resistanceLevel => 'Сопротивление (Уровень)';

  @override
  String resistanceColon(String resistance) {
    return 'Сопротивление $resistance';
  }

  @override
  String get spm => 'шаг/мин';

  @override
  String get spmSteps => 'шаг/мин (шагов/мин)';

  @override
  String get saved => 'Сохранено';

  @override
  String get deleted => 'Удалено';

  @override
  String get deleteRoutineTitle => 'Удалить программу';

  @override
  String get deleteRoutineMessage =>
      'Удалить эту программу? Это действие нельзя отменить.';

  @override
  String get deleteError => 'Произошла ошибка при удалении';

  @override
  String get nameRequired => 'Пожалуйста, введите название';

  @override
  String get nameMaxLength => 'Название должно содержать не более 50 символов';

  @override
  String get minIntervalsRequired => 'Требуется хотя бы один интервал';

  @override
  String get intervalMinDuration =>
      'Длительность интервала должна быть не менее 1 секунды';

  @override
  String get intervalMaxDuration =>
      'Длительность интервала должна быть не более 3 часов (10800 секунд)';

  @override
  String get speedRange => 'Скорость должна быть больше 0 (0.5-25.0 км/ч)';

  @override
  String get inclineRange => 'Наклон должен быть в диапазоне 0-15.0';

  @override
  String get rpmRange => 'об/мин должен быть в диапазоне 30-200';

  @override
  String get resistanceRange => 'Сопротивление должно быть в диапазоне 1-20';

  @override
  String get levelRange => 'Уровень должен быть в диапазоне 1-20';

  @override
  String get spmRange => 'шаг/мин должен быть в диапазоне 50-200';

  @override
  String get noRoutinesSaved => 'Нет сохраненных программ';

  @override
  String get tapToCreate => 'Нажмите, чтобы создать';

  @override
  String get tapButtonToCreate => 'Нажмите кнопку, чтобы создать';

  @override
  String get premiumRoutineSettings => 'Настройки премиум-программы';

  @override
  String get viewMembership => 'Открыть Premium';

  @override
  String get freeLimitTitle => '2 бесплатные программы';

  @override
  String get freeLimitMessage => 'С Premium доступно неограниченно';

  @override
  String get treadmill => 'Беговая дорожка';

  @override
  String get cycle => 'Велосипед';

  @override
  String get stairmaster => 'Степпер';

  @override
  String get selectLanguage => 'Языки';

  @override
  String get selectTheme => 'Выбрать тему';

  @override
  String get selectDifficulty => 'Выбрать сложность';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продолжить';

  @override
  String get endWorkout => 'Завершить Тренировку';

  @override
  String get endWorkoutConfirm => 'Завершить тренировку?';

  @override
  String get end => 'Завершить';

  @override
  String get share => 'Поделиться';

  @override
  String get rotate => 'Повернуть';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get pausedTitle => 'Приостановлено';

  @override
  String get pausedSubtitle => 'Тренировку можно продолжить или завершить';

  @override
  String get endWorkoutConfirmationMessage =>
      'Если завершить сейчас, текущая тренировка закончится и откроется экран итогов.';

  @override
  String get workoutComplete => 'Тренировка завершена';

  @override
  String get backgroundIntervalNotificationTitle => 'Новый интервал';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'Оповещения при выключенном экране';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'Подготовка';

  @override
  String get liveActivityInProgress => 'Тренировка идёт';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'Интервал $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'В течение $duration';
  }

  @override
  String get totalWorkoutTime => 'Общее время';

  @override
  String get totalDistance => 'Общее расстояние';

  @override
  String get totalTime => 'Общее время';

  @override
  String get averageRpm => 'Средний RPM';

  @override
  String get averageLevel => 'Средний Уровень';

  @override
  String get holdToStop => 'Удержите для остановки';

  @override
  String get continueWorkout => 'Продолжить';

  @override
  String get endWorkoutQuestion => 'Завершить тренировку?';

  @override
  String get workoutPaused => 'Тренировка приостановлена';

  @override
  String get lvlIncline => 'Наклон';

  @override
  String get lvlResistance => 'Уровень Сопротивление';

  @override
  String get premium => 'Премиум';

  @override
  String get upgradeNow => 'Обновить Сейчас';

  @override
  String get purchase => 'Купить';

  @override
  String get later => 'Позже';

  @override
  String get premiumActivated => 'Премиум был активирован';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster =>
      'Тренировки на велотренажере и степпере';

  @override
  String get benefitVoiceGuide => 'Голосовой гид во время тренировки';

  @override
  String get benefitUnlimitedRoutines => 'Неограниченное сохранение программ';

  @override
  String get noAds => 'Без Рекламы';

  @override
  String get benefitFutureFeatures => 'Доступ ко всем будущим функциям';

  @override
  String get voiceGuideBenefit1 => 'Голосовой помощник во время бега';

  @override
  String get voiceGuideBenefit2 => 'Автоматическое оповещение о смене сессии';

  @override
  String get voiceGuideBenefit3 => 'Фокусируйтесь на тренировке без рук';

  @override
  String get routineLimitBenefit1 => 'Неограниченное сохранение программ';

  @override
  String get routineLimitBenefit2 => 'Программы под различные фитнес-цели';

  @override
  String get routineLimitBenefit3 =>
      'Полная поддержка беговых дорожек, велосипедов и степперов';

  @override
  String get premium_benefit_1 =>
      'Поддержка <red>велотренажёра и лестничного тренажёра</red>';

  @override
  String get premium_benefit_2 =>
      '<red>Голосовой гид</red> во время тренировок';

  @override
  String get premium_benefit_3 =>
      'Сохранение программ <red>без ограничений</red>';

  @override
  String get premium_benefit_4 =>
      'Все новые функции <red>включены навсегда</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/мес';
  }

  @override
  String get premiumSubheadline =>
      'Разблокируйте голосовое руководство, тренировки на велосипеде и степпере, и неограниченные программы';

  @override
  String get monthly => 'Ежемесячно';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get lifetime => 'На всю жизнь';

  @override
  String get freeTrial7Days => '7 дней бесплатного пробного периода';

  @override
  String get perMonth => '/мес';

  @override
  String get perYear => '/год';

  @override
  String get oneTime => 'Один раз';

  @override
  String savePercent(String percent) {
    return 'Экономия $percent';
  }

  @override
  String get bestValue => 'Лучшая Цена';

  @override
  String get cancelAnytime => 'Отменить в любое время';

  @override
  String get autoRenewableSubscription => 'Автопродление';

  @override
  String get terms => 'Условия';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get restore => 'Восстановить';

  @override
  String get premiumTab => 'Премиум';

  @override
  String get routineTab => 'Программа';

  @override
  String get settingsTab => 'Настройки';

  @override
  String get myTab => 'Я';

  @override
  String get close => 'Закрыть';

  @override
  String get premiumFeature => 'Только Premium';

  @override
  String get usePremiumTest => 'Тест Premium';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day.$month.$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'Просмотр и старт';

  @override
  String get beginner => 'Начинающий';

  @override
  String get intermediate => 'Средний';

  @override
  String get advanced => 'Продвинутый';

  @override
  String get viewRecommendedRoutines => 'Подборки →';

  @override
  String get recommendedRoutinesTreadmill => 'Подборки для дорожки';

  @override
  String get recommendedRoutinesCycle => 'Подборки для вело';

  @override
  String get recommendedRoutinesStairmaster => 'Подборки для степпера';

  @override
  String get alreadySaved => 'Уже сохранено';

  @override
  String get routineSaved => 'Программа сохранена';

  @override
  String get checkRoutine => 'Просмотр';

  @override
  String get saveRoutine => 'Сохранить Программу';

  @override
  String get routineAlreadySaved => 'Программа уже сохранена';

  @override
  String get noTemplatesFound => 'Шаблоны не найдены';

  @override
  String get avg => 'Ср.';

  @override
  String get avgRpm => 'Ср. RPM';

  @override
  String get avgLevel => 'Ср. Уровень';

  @override
  String get templateTreadmillBeginner1Title => 'Беговая дорожка Начальный 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      '1:1 ходьба и бег после 3 мин разминки';

  @override
  String get templateTreadmillBeginner2Title =>
      'Беговая дорожка Начальный 2 (Наклон)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'Ходьба под наклоном с низкой нагрузкой на суставы';

  @override
  String get templateTreadmillIntermediate1Title => 'Беговая дорожка Средний 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      'Беговой интервал 1:1 для сжигания жира';

  @override
  String get templateTreadmillIntermediate2Title =>
      'Беговая дорожка Средний 2 (Скорость)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'Интервальный бег с постепенным ускорением';

  @override
  String get templateTreadmillAdvanced1Title => 'Беговая дорожка Продвинутый 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'Высокоинтенсивный кардио-интервал';

  @override
  String get templateTreadmillAdvanced2Title =>
      'Беговая дорожка Продвинутый 2 (Спринт)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'Короткие спринты высокой интенсивности';

  @override
  String get templateCycleBeginner1Title => 'Велосипед Начальный 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'Вводная тренировка с регулировкой RPM';

  @override
  String get templateCycleBeginner2Title =>
      'Велосипед Начальный 2 (Постоянный)';

  @override
  String get templateCycleBeginner2Subtitle =>
      'Развитие выносливости при фиксированном сопротивлении';

  @override
  String get templateCycleIntermediate1Title => 'Велосипед Средний 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      '1 мин высокая скорость / 1 мин восстановление';

  @override
  String get templateCycleIntermediate2Title => 'Велосипед Средний 2 (Холм)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'Подъем в гору при высоком сопротивлении';

  @override
  String get templateCycleAdvanced1Title => 'Велосипед Продвинутый 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      'Силовые интервалы 30 сек при высоком сопротивлении';

  @override
  String get templateCycleAdvanced2Title => 'Велосипед Продвинутый 2 (Табата)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      'Табата-тренинг 20/10 сек для сжигания жира';

  @override
  String get templateStairmasterBeginner1Title => 'Степпер Начальный 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'Безопасное привыкание к темпу ходьбы по ступеням';

  @override
  String get templateStairmasterBeginner2Title =>
      'Степпер Начальный 2 (Постоянный)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'Аэробный подъем в постоянном темпе';

  @override
  String get templateStairmasterIntermediate1Title =>
      'Степпер Средний 1 (Подъем)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2 мин подъем / 1 мин восстановление ягодиц';

  @override
  String get templateStairmasterIntermediate2Title => 'Степпер Средний 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'Чередование быстрого и медленного темпа';

  @override
  String get templateStairmasterAdvanced1Title => 'Степпер Продвинутый 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'Интенсивная 2-минутная тренировка по блокам';

  @override
  String get templateStairmasterAdvanced2Title =>
      'Степпер Продвинутый 2 (Спринт)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30 сек быстрый подъем / 60 сек восстановление';

  @override
  String get historyTab => 'История';

  @override
  String get calendarTab => 'Календарь';

  @override
  String get weightTab => 'Вес';

  @override
  String get bike => 'Велосипед';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get trend => 'Динамика веса';

  @override
  String get timeframe7D => '7Д';

  @override
  String get timeframe30D => '30Д';

  @override
  String get timeframe90D => '90Д';

  @override
  String get timeframeAll => 'ВСЕ';

  @override
  String get history => 'История';

  @override
  String get seeAll => 'Показать все';

  @override
  String get weightEntryDeleted => 'Запись веса удалена';

  @override
  String get weightUpdated => 'Вес обновлен';

  @override
  String get editWeight => 'Редактировать вес';

  @override
  String get recordWeight => 'Записать вес';

  @override
  String get quickAdjust => 'Быстрая правка';

  @override
  String get goalWeightSet => 'Целевой вес установлен';

  @override
  String get goalWeightRemoved => 'Целевой вес отключен';

  @override
  String get goalAchieved => 'Цель достигнута!';

  @override
  String get goalMatchesCurrentWeight => 'Цель соответствует текущему весу';

  @override
  String get setGoal => 'Установить цель';

  @override
  String get suggested => 'Рекомендуемое';

  @override
  String get removeGoal => 'Сбросить цель';

  @override
  String get addOneMoreRecordToSeeTrend => 'Добавьте ещё 1 запись для тренда';

  @override
  String get noWeightRecorded => 'Вес еще не записан';

  @override
  String get startTrackingYourWeight =>
      'Записывайте вес, чтобы видеть прогресс';

  @override
  String get treadmillSession => 'Сессия Беговой Дорожки';

  @override
  String get bikeSession => 'Сессия Велосипеда';

  @override
  String get stairmasterSession => 'Сессия Степпера';

  @override
  String get treadmillWorkout => 'Тренировка Беговой Дорожки';

  @override
  String get bikeWorkout => 'Тренировка Велосипеда';

  @override
  String get stairmasterWorkout => 'Тренировка Степпера';

  @override
  String get startAWorkoutToSeeItHere =>
      'Здесь появятся завершённые тренировки';

  @override
  String get mon => 'Пн';

  @override
  String get tue => 'Вт';

  @override
  String get wed => 'Ср';

  @override
  String get thu => 'Чт';

  @override
  String get fri => 'Пт';

  @override
  String get sat => 'Сб';

  @override
  String get sun => 'Вс';

  @override
  String get sessions => 'Сессии';

  @override
  String get distance => 'Расстояние';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get noWorkoutsYet => 'Пока нет тренировок';

  @override
  String get startYourFirstWorkout =>
      'Начните свою первую тренировку, чтобы увидеть историю здесь';

  @override
  String get goToRoutines => 'Перейти к Программам';

  @override
  String get weightRecorded => 'Вес записан';

  @override
  String get workout => 'тренировка';

  @override
  String get workouts => 'тренировки';

  @override
  String get goal => 'Цель';

  @override
  String get toGo => 'осталось';

  @override
  String get over => 'превышено';

  @override
  String get last => 'Последний';

  @override
  String get newLabel => 'Новый';

  @override
  String youNeed(String amount, String goal) {
    return 'До цели $goal осталось $amount';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'До цели $goal осталось +$amount';
  }

  @override
  String get current => 'Текущий';

  @override
  String get premiumHeadline => 'Те же 30 минут, другие результаты';

  @override
  String get premiumSubheadlineNew =>
      'Не просто бегайте, тренируйтесь для сжигания жира';

  @override
  String get mostPopular => 'Самый Популярный';

  @override
  String dailyPrice(int price) {
    return '$price в день';
  }

  @override
  String get benefitVoiceCoaching => 'Премиум-система голосового коучинга';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'Уведомления об интервалах при использовании других приложений';

  @override
  String get benefitCycleStairmasterRoutines =>
      'Полная поддержка всего кардио-оборудования';

  @override
  String get benefitUnlimitedRoutinesNew => 'Безлимитная библиотека тренировок';

  @override
  String get benefitWeightFeature => 'Умное отслеживание и анализ веса';

  @override
  String get benefitNoAdsFocus => 'Премиум-опыт без рекламы';

  @override
  String get benefitFutureFeaturesNew => 'Все будущие премиум-функции включены';

  @override
  String get mostChosen => 'Топ-выбор';

  @override
  String get canChangeAnytime => 'Меняйте когда угодно';

  @override
  String get startPremium => 'Подключить Premium';

  @override
  String get cancelAnytimeKeepAccess =>
      'Отменяйте когда угодно, доступ сохранится';

  @override
  String workoutDays(String count) {
    return 'Дней с тренировками: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'Дней отдыха: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'Напоминания';

  @override
  String get workoutReminderOff => 'Выключено';

  @override
  String get workoutReminderEveryDay => 'Каждый день';

  @override
  String get workoutReminderSelectTime => 'Выбрать время';

  @override
  String get workoutReminderPermissionRequired =>
      'Требуется разрешение на уведомления.';

  @override
  String get workoutReminderTimeLabel => 'Время';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Попробуйте эту интервальную тренировку в Valcue!\n\nТренировка: $routineName\n\nСкопируйте или нажмите на ссылку, чтобы импортировать её:\n$shareLink';
  }

  @override
  String get scanQrCode => 'Сканировать QR-код';

  @override
  String get invalidQrCode => 'Этот QR-код не является программой Valcue.';

  @override
  String get previousMonth => 'Предыдущий месяц';

  @override
  String get nextMonth => 'Следующий месяц';

  @override
  String get placeQrInside => 'Поместите QR-код внутрь рамки.';

  @override
  String get customRoutineBuilder => 'Создать персональную тренировку';

  @override
  String get customRoutineAccuracyNoticeTitle =>
      'Значения могут немного отличаться';

  @override
  String get customRoutineAccuracyPointRounding =>
      'Скорость округляется до целых чисел';

  @override
  String get customRoutineAccuracyPointVariation =>
      'Каждый раз результат немного отличается';

  @override
  String get customRoutineAccuracyPointRange =>
      'Значения остаются в безопасном диапазоне для этой сложности';

  @override
  String get customRoutineAccuracyResultNote =>
      'Фактические значения могут отличаться от цели на несколько процентов';

  @override
  String get customRoutineGenerating => 'Создаём персональную тренировку…';

  @override
  String get customRoutineLoadingTarget => 'Настраиваем целевую интенсивность…';

  @override
  String get customRoutineLoadingStructure => 'Планируем разминку и заминку…';

  @override
  String get customRoutineLoadingPace => 'Рассчитываем темп интервалов…';

  @override
  String get customRoutineLoadingVoice => 'Готовим голосовые подсказки…';

  @override
  String get generationComplete => 'Тренировка создана!';

  @override
  String get regenerate => 'Создать заново';

  @override
  String get caloriesEstimateByWeight =>
      'Калории рассчитаны приблизительно на основе указанного веса.';

  @override
  String get commonBack => 'Назад';

  @override
  String get adjustGoals => 'Изменить цели';

  @override
  String get targetCalories => 'Цель по калориям';

  @override
  String get targetStairs => 'Цель по этажам';

  @override
  String get targetDistance => 'Целевая дистанция';

  @override
  String get currentWeight => 'Текущий вес';

  @override
  String get includeIncline => 'Добавить наклон';

  @override
  String get includeWarmupCooldown => 'Добавить разминку и заминку';

  @override
  String get generateCustomRoutine => 'Создать персональную тренировку';

  @override
  String durationMinutes(String minutes) {
    return '$minutes мин';
  }

  @override
  String floorCount(String count) {
    return 'Этажей: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'Персональный бег $distance $distanceUnit ($calories ккал)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'Персональный велозаезд $distance $distanceUnit ($calories ккал)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'Прогрессивный бег $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'Пирамидальный бег $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'Прогрессивный велозаезд $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'Пирамидальный велозаезд $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'Персональная лестница $floors этажей ($calories ккал)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'Персональная тренировка готова. Цель — около $calories калорий!';
  }

  @override
  String get weightDeleteTitle => 'Удалить запись';

  @override
  String get weightDeleteConfirm => 'Удалить эту запись о весе?';

  @override
  String get achievementUnlocked => '🏆 Достижение открыто!';

  @override
  String get achievementCongratulations => 'Поздравляем! Получен новый значок.';

  @override
  String get awesome => 'Отлично!';

  @override
  String get shareCardDefault => '9:14 (Обычный)';

  @override
  String get shareCardStory => '9:16 (История)';

  @override
  String get shareCardSquare => '1:1 (Квадрат)';

  @override
  String get customizeShareCard => 'Настроить карточку';

  @override
  String get shareRoutine => 'Поделиться тренировкой';

  @override
  String get shareViaQrCode => 'Поделиться QR-кодом';

  @override
  String get routineLimitReached => 'Достигнут лимит тренировок';

  @override
  String get routineLimitMessage =>
      'В бесплатной версии можно сохранить до 2 тренировок на дорожке. Для новой тренировки нужна подписка Premium или удаление одной из сохранённых тренировок.';

  @override
  String get importSharedRoutine => 'Импорт общей тренировки';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'В QR-коде найдена тренировка.\n\n• Название: $name\n• Сложность: $difficulty\n• Интервалы: $count\n\nСохранить её в библиотеку?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'В буфере обмена найдена общая тренировка.\n\n• Название: $name\n• Сложность: $difficulty\n• Интервалы: $count\n\nСохранить её в библиотеку?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '«$name» успешно импортирована!';
  }

  @override
  String get importAction => 'Импортировать';

  @override
  String get addRoutineOption => 'Выбери способ добавления';

  @override
  String get createCustomRoutine => 'Создать свою тренировку';

  @override
  String get importFromClipboard => 'Импорт из буфера обмена';

  @override
  String get countdownTiming => 'Обратный отсчёт';

  @override
  String get noAnnouncements => 'Без подсказок';

  @override
  String secondsShort(String seconds) {
    return 'за $seconds с';
  }

  @override
  String get selectCountdownTimings => 'Выбери время подсказок';

  @override
  String get countdownTimingMessage =>
      'Выбери, когда озвучивать оставшееся время перед сменой интервала.';

  @override
  String secondsLeft(String seconds) {
    return 'Осталось: $seconds с';
  }

  @override
  String get qrShareInstruction =>
      'Отсканируйте этот QR-код в другом приложении Valcue,\nчтобы сразу импортировать тренировку.';

  @override
  String get quickStart => 'Быстрый старт';

  @override
  String get sessionRepeatBlock => 'Повторяющийся блок';

  @override
  String repeatTimes(String count) {
    return 'Повторов: $count';
  }

  @override
  String get addRepeatBlock => 'Добавить блок повторов';

  @override
  String get unableToShareWorkout => 'Не удалось поделиться тренировкой.';

  @override
  String get unableToOpenPrivacyPolicy =>
      'Не удалось открыть политику конфиденциальности.';

  @override
  String get unableToOpenLink => 'Не удалось открыть ссылку.';

  @override
  String get less => 'Меньше';

  @override
  String get more => 'Больше';

  @override
  String inclineValue(String value) {
    return 'Наклон: $value %';
  }

  @override
  String rpmValue(String value) {
    return '$value об/мин';
  }

  @override
  String nextMetric(String value) {
    return 'Далее: $value';
  }

  @override
  String get weightCalendar => 'Календарь веса';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText интервала · $difficulty',
      many: '$duration · $countText интервалов · $difficulty',
      few: '$duration · $countText интервала · $difficulty',
      one: '$duration · $countText интервал · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'Цель: $goalWeight • Цель достигнута!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'Цель: $goalWeight • Осталось $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'Цель: $goalWeight • Превышение на $difference';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'Ср. скорость: $value км/ч';
  }

  @override
  String averageSpeedMph(String value) {
    return 'Ср. скорость: $value миль/ч';
  }

  @override
  String averageRpmValue(String value) {
    return 'Ср. темп: $value об/мин';
  }

  @override
  String averageLevelValue(String value) {
    return 'Ср. уровень: $value';
  }

  @override
  String get purchaseFailed =>
      'Не удалось выполнить покупку. Попробуйте ещё раз.';

  @override
  String get restoreSuccess => 'Ваши покупки восстановлены.';

  @override
  String get restoreNothingToRestore => 'Предыдущие покупки не найдены.';

  @override
  String get plansUnavailable =>
      'Не удалось загрузить тарифы. Повторите попытку позже.';
}
