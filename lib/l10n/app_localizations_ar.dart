// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'حجم شاشة التمرين';

  @override
  String get workoutDisplaySizeSubtitle =>
      'يكبّر أرقام التمرين الأساسية والمؤقت.';

  @override
  String get workoutDisplaySizeStandard => 'افتراضي';

  @override
  String get workoutDisplaySizeLarge => 'كبير';

  @override
  String get workoutDisplaySizeExtraLarge => 'الأكبر';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => 'إعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get system => 'النظام';

  @override
  String get voiceGuide => 'الدليل الصوتي';

  @override
  String get audioNavigator => 'مستكشف الصوت';

  @override
  String get soundEffects => 'تأثيرات صوتية';

  @override
  String get unitSetting => 'الوحدات';

  @override
  String get kmh => 'كم/ساعة';

  @override
  String get mph => 'ميل/ساعة';

  @override
  String get themeMode => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get smartwatchSync => 'مزامنة الساعة الذكية';

  @override
  String get connectSmartwatch => 'الاتصال بالساعة الذكية';

  @override
  String get connect => 'اتصال';

  @override
  String get about => 'حول';

  @override
  String get adPrivacyOptions => 'خيارات خصوصية الإعلانات';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get comingSoon => 'قريباً';

  @override
  String get translationComingSoon => 'ستكون الترجمة متاحة في تحديث مستقبلي.';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get done => 'تم';

  @override
  String get delete => 'حذف';

  @override
  String get duplicate => 'تكرار';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get start => 'بدء';

  @override
  String get editRoutine => 'تعديل الروتين';

  @override
  String get routineEdit => 'تعديل الروتين';

  @override
  String get name => 'الاسم';

  @override
  String get unnamedRoutine => 'روتين بدون اسم';

  @override
  String get difficulty => 'الصعوبة';

  @override
  String difficultyColon(String difficulty) {
    return 'الصعوبة : $difficulty';
  }

  @override
  String get easy => 'سهل';

  @override
  String get medium => 'متوسط';

  @override
  String get hard => 'صعب';

  @override
  String get interval => 'الفترة';

  @override
  String get addInterval => 'إضافة فترة';

  @override
  String get quickTools => 'أدوات سريعة';

  @override
  String get addDefault => 'إضافة أساسية';

  @override
  String get duplicateLast => 'نسخ الأخير';

  @override
  String get repeatPattern => 'تكرار النمط';

  @override
  String get reorderIntervals => 'إعادة الترتيب';

  @override
  String get reorderMode => 'وضع إعادة الترتيب';

  @override
  String get reorderModeHint =>
      'اضغط مطولاً على البطاقة لنقلها إلى المكان الذي تريده.';

  @override
  String get patternLength => 'طول النمط';

  @override
  String get repeatCount => 'عدد التكرار';

  @override
  String get noIntervals => 'لا توجد فترات';

  @override
  String get addIntervalPrompt => 'إضافة فترة';

  @override
  String get intervalEdit => 'تعديل الفترة';

  @override
  String get timeMinutes => 'الوقت (بالدقائق)';

  @override
  String get duration => 'المدة';

  @override
  String get speed => 'السرعة';

  @override
  String get speedKmh => 'السرعة (كم/ساعة)';

  @override
  String get incline => 'الميل';

  @override
  String get level => 'المستوى';

  @override
  String levelColon(String level) {
    return 'المستوى $level';
  }

  @override
  String get rpm => 'دورة/دقيقة';

  @override
  String get rpmInfoDescription =>
      'يوضح RPM عدد المرات التي تدور فيها الدواسات خلال دقيقة واحدة. وكلما ارتفع الرقم، فهذا يعني أنك تبدل بسرعة إيقاع أعلى.';

  @override
  String get resistance => 'المقاومة';

  @override
  String get resistanceLevel => 'المقاومة (المستوى)';

  @override
  String resistanceColon(String resistance) {
    return 'المقاومة $resistance';
  }

  @override
  String get spm => 'خطوة/دقيقة';

  @override
  String get spmSteps => 'خطوة/دقيقة (خطوات/دقيقة)';

  @override
  String get saved => 'محفوظ';

  @override
  String get deleted => 'تم الحذف';

  @override
  String get deleteRoutineTitle => 'حذف الروتين';

  @override
  String get deleteRoutineMessage =>
      'هل أنت متأكد من أنك تريد حذف هذا الروتين؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteError => 'حدث خطأ أثناء الحذف';

  @override
  String get nameRequired => 'الرجاء إدخال اسم';

  @override
  String get nameMaxLength => 'يجب أن يكون الاسم 50 حرفاً أو أقل';

  @override
  String get minIntervalsRequired => 'مطلوب فترة واحدة على الأقل';

  @override
  String get intervalMinDuration =>
      'يجب أن تكون مدة الفترة ثانية واحدة على الأقل';

  @override
  String get intervalMaxDuration =>
      'يجب أن تكون مدة الفترة 3 ساعات كحد أقصى (10800 ثانية)';

  @override
  String get speedRange => 'يجب أن تكون السرعة أكبر من 0 (0.5-25.0 كم/ساعة)';

  @override
  String get inclineRange => 'يجب أن يكون الميل في النطاق 0-15.0';

  @override
  String get rpmRange => 'يجب أن تكون دورة/دقيقة في النطاق 30-200';

  @override
  String get resistanceRange => 'يجب أن تكون المقاومة في النطاق 1-20';

  @override
  String get levelRange => 'يجب أن يكون المستوى في النطاق 1-20';

  @override
  String get spmRange => 'يجب أن تكون خطوة/دقيقة في النطاق 50-200';

  @override
  String get noRoutinesSaved => 'لا توجد روتينات محفوظة';

  @override
  String get tapToCreate => 'اضغط للإنشاء';

  @override
  String get tapButtonToCreate => 'اضغط على الزر للإنشاء';

  @override
  String get premiumRoutineSettings => 'إعدادات الروتين المميز';

  @override
  String get viewMembership => 'عرض بريميوم';

  @override
  String get freeLimitTitle => 'روتينان مجانًا';

  @override
  String get freeLimitMessage => 'احصل على روتينات بلا حد مع بريميوم';

  @override
  String get treadmill => 'جهاز الجري';

  @override
  String get cycle => 'الدراجة';

  @override
  String get stairmaster => 'جهاز صعود الدرج';

  @override
  String get selectLanguage => 'اللغات';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get selectDifficulty => 'اختر الصعوبة';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'متابعة';

  @override
  String get endWorkout => 'إنهاء التمرين';

  @override
  String get endWorkoutConfirm => 'هل تريد إنهاء التمرين؟';

  @override
  String get end => 'إنهاء';

  @override
  String get share => 'مشاركة';

  @override
  String get rotate => 'تدوير';

  @override
  String get paused => 'متوقف مؤقتاً';

  @override
  String get pausedTitle => 'متوقف مؤقتاً';

  @override
  String get pausedSubtitle => 'يمكنك المتابعة أو إنهاء التمرين';

  @override
  String get endWorkoutConfirmationMessage =>
      'إذا أنهيت الآن، سينتهي التمرين الحالي وستنتقل إلى شاشة الملخص.';

  @override
  String get workoutComplete => 'اكتمل التمرين';

  @override
  String get backgroundIntervalNotificationTitle => 'بدء فترة جديدة';

  @override
  String get backgroundIntervalNotificationsTitle =>
      'تنبيهات عند إيقاف تشغيل الشاشة';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => 'جارٍ الاستعداد';

  @override
  String get liveActivityInProgress => 'التمرين جارٍ';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'الفترة $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return 'لمدة $duration';
  }

  @override
  String get totalWorkoutTime => 'إجمالي الوقت';

  @override
  String get totalDistance => 'إجمالي المسافة';

  @override
  String get totalTime => 'الوقت الإجمالي';

  @override
  String get averageRpm => 'متوسط RPM';

  @override
  String get averageLevel => 'المستوى المتوسط';

  @override
  String get holdToStop => 'اضغط مطولاً للإيقاف';

  @override
  String get continueWorkout => 'متابعة';

  @override
  String get endWorkoutQuestion => 'هل تريد إنهاء التمرين؟';

  @override
  String get workoutPaused => 'تم إيقاف التمرين مؤقتاً';

  @override
  String get lvlIncline => 'الميل';

  @override
  String get lvlResistance => 'المستوى المقاومة';

  @override
  String get premium => 'بريميوم';

  @override
  String get upgradeNow => 'ترقية الآن';

  @override
  String get purchase => 'شراء';

  @override
  String get later => 'لاحقاً';

  @override
  String get premiumActivated => 'تم تفعيل بريميوم';

  @override
  String get premiumMembership => 'بريميوم';

  @override
  String get benefitCycleStairmaster => 'تمارين الدراجة وجهاز صعود الدرج';

  @override
  String get benefitVoiceGuide => 'التوجيه الصوتي لكل جزء من التمرين';

  @override
  String get benefitUnlimitedRoutines => 'حفظ غير محدود لتمارينك';

  @override
  String get noAds => 'بدون إعلانات';

  @override
  String get benefitFutureFeatures => 'يشمل جميع الميزات المستقبلية';

  @override
  String get voiceGuideBenefit1 => 'تدريب توجيهي صوتي أثناء التمرين';

  @override
  String get voiceGuideBenefit2 => 'تنبيه تلقائي عند تغيير مراحل التمرين';

  @override
  String get voiceGuideBenefit3 => 'تركيز كامل دون الحاجة لحمل الهاتف';

  @override
  String get routineLimitBenefit1 => 'حفظ غير محدود لتمارينك';

  @override
  String get routineLimitBenefit2 => 'تمارين مخصصة لمختلف أهدافك';

  @override
  String get routineLimitBenefit3 => 'دعم كامل لأجهزة الجري، الدراجة، والدرج';

  @override
  String get premium_benefit_1 => 'دعم تمارين <red>الدراجة وجهاز الدرج</red>';

  @override
  String get premium_benefit_2 => '<red>توجيه صوتي</red> لكل جزء من التمرين';

  @override
  String get premium_benefit_3 => 'عدد التمارين المحفوظة <red>غير محدود</red>';

  @override
  String get premium_benefit_4 =>
      'يشمل الميزات المستقبلية <red>مدى الحياة</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/شهر';
  }

  @override
  String get premiumSubheadline =>
      'فتح قفل الإرشاد الصوتي، وتمارين الدراجة والسلالم، والروتينات غير المحدودة';

  @override
  String get monthly => 'شهري';

  @override
  String get yearly => 'سنوي';

  @override
  String get lifetime => 'مدى الحياة';

  @override
  String get freeTrial7Days => 'تجربة مجانية لمدة 7 أيام';

  @override
  String get perMonth => '/شهر';

  @override
  String get perYear => '/سنة';

  @override
  String get oneTime => 'دفع واحد';

  @override
  String savePercent(String percent) {
    return 'وفّر $percent';
  }

  @override
  String get bestValue => 'أفضل قيمة';

  @override
  String get cancelAnytime => 'إلغاء في أي وقت';

  @override
  String get autoRenewableSubscription => 'يتجدد تلقائيًا';

  @override
  String get terms => 'الشروط';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get restore => 'استعادة';

  @override
  String get premiumTab => 'بريميوم';

  @override
  String get routineTab => 'الروتين';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get myTab => 'أنا';

  @override
  String get close => 'إغلاق';

  @override
  String get premiumFeature => 'بريميوم فقط';

  @override
  String get usePremiumTest => 'تجربة بريميوم';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$day/$month/$year $hour:$minute';
  }

  @override
  String get checkRoutineStart => 'معاينة وبدء';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

  @override
  String get viewRecommendedRoutines => 'مقترحات →';

  @override
  String get recommendedRoutinesTreadmill => 'مقترحات جهاز الجري';

  @override
  String get recommendedRoutinesCycle => 'مقترحات الدراجة';

  @override
  String get recommendedRoutinesStairmaster => 'مقترحات الدرج';

  @override
  String get alreadySaved => 'محفوظ بالفعل';

  @override
  String get routineSaved => 'تم حفظ الروتين';

  @override
  String get checkRoutine => 'معاينة';

  @override
  String get saveRoutine => 'حفظ الروتين';

  @override
  String get routineAlreadySaved => 'الروتين محفوظ بالفعل';

  @override
  String get noTemplatesFound => 'لم يتم العثور على قوالب';

  @override
  String get avg => 'المتوسط';

  @override
  String get avgRpm => 'المتوسط RPM';

  @override
  String get avgLevel => 'المتوسط المستوى';

  @override
  String get templateTreadmillBeginner1Title => 'جهاز الجري للمبتدئين 1';

  @override
  String get templateTreadmillBeginner1Subtitle =>
      'مشى وجري 1:1 بعد 3 دقائق إحماء';

  @override
  String get templateTreadmillBeginner2Title =>
      'جهاز الجري للمبتدئين 2 (الميل)';

  @override
  String get templateTreadmillBeginner2Subtitle =>
      'المشي المائل مع ضغط منخفض على المفاصل';

  @override
  String get templateTreadmillIntermediate1Title => 'جهاز الجري المتوسط 1';

  @override
  String get templateTreadmillIntermediate1Subtitle =>
      'جري بفترات 1:1 لحرق الدهون';

  @override
  String get templateTreadmillIntermediate2Title =>
      'جهاز الجري المتوسط 2 (السرعة)';

  @override
  String get templateTreadmillIntermediate2Subtitle =>
      'تمرين الجري الهرمي لزيادة السرعة';

  @override
  String get templateTreadmillAdvanced1Title => 'جهاز الجري المتقدم 1';

  @override
  String get templateTreadmillAdvanced1Subtitle =>
      'فترة تمارين كارديو عالية الكثافة';

  @override
  String get templateTreadmillAdvanced2Title => 'جهاز الجري المتقدم 2 (سبرينت)';

  @override
  String get templateTreadmillAdvanced2Subtitle =>
      'فترات ركض سريعة وقصيرة عالية الكثافة';

  @override
  String get templateCycleBeginner1Title => 'الدراجة للمبتدئين 1';

  @override
  String get templateCycleBeginner1Subtitle =>
      'مقدمة عن التبديل عن طريق ضبط الـ RPM';

  @override
  String get templateCycleBeginner2Title => 'الدراجة للمبتدئين 2 (مستمر)';

  @override
  String get templateCycleBeginner2Subtitle => 'تمرين التحمل مع مقاومة ثابتة';

  @override
  String get templateCycleIntermediate1Title => 'الدراجة المتوسط 1';

  @override
  String get templateCycleIntermediate1Subtitle =>
      'دقيقة سرعة عالية / دقيقة تمرين خفيف للاستشفاء';

  @override
  String get templateCycleIntermediate2Title => 'الدراجة المتوسط 2 (التلة)';

  @override
  String get templateCycleIntermediate2Subtitle =>
      'صعود التلال بمقاومة عالية لتقوية عضلات الساق';

  @override
  String get templateCycleAdvanced1Title => 'الدراجة المتقدم 1';

  @override
  String get templateCycleAdvanced1Subtitle =>
      'فترات تبديل قوية لمدة 30 ثانية بمقاومة عالية';

  @override
  String get templateCycleAdvanced2Title => 'الدراجة المتقدم 2 (تاباتا)';

  @override
  String get templateCycleAdvanced2Subtitle =>
      'تمرين تاباتا 20 ثانية / 10 ثوان لحرق الدهون';

  @override
  String get templateStairmasterBeginner1Title => 'جهاز صعود الدرج للمبتدئين 1';

  @override
  String get templateStairmasterBeginner1Subtitle =>
      'خطوات بطيئة للتعود على الدرج بأمان';

  @override
  String get templateStairmasterBeginner2Title =>
      'جهاز صعود الدرج للمبتدئين 2 (مستمر)';

  @override
  String get templateStairmasterBeginner2Subtitle =>
      'صعود الدرج الهوائي بوتيرة ثابتة';

  @override
  String get templateStairmasterIntermediate1Title =>
      'جهاز صعود الدرج المتوسط 1 (الصعود)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      'دقيقتان صعود / دقيقة استشفاء لعضلات الألوية';

  @override
  String get templateStairmasterIntermediate2Title =>
      'جهاز صعود الدرج المتوسط 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      'فترات تمرين مع تبديل الوتيرة سريعة/بطيئة';

  @override
  String get templateStairmasterAdvanced1Title => 'جهاز صعود الدرج المتقدم 1';

  @override
  String get templateStairmasterAdvanced1Subtitle =>
      'تمرين مكثف بفترات مدتها دقيقتان';

  @override
  String get templateStairmasterAdvanced2Title =>
      'جهاز صعود الدرج المتقدم 2 (سبرينت)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30 ثانية صعود سريع / 60 ثانية استشفاء';

  @override
  String get historyTab => 'السجل';

  @override
  String get calendarTab => 'التقويم';

  @override
  String get weightTab => 'الوزن';

  @override
  String get bike => 'الدراجة';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get trend => 'مخطط الوزن';

  @override
  String get timeframe7D => '7أ';

  @override
  String get timeframe30D => '30أ';

  @override
  String get timeframe90D => '90أ';

  @override
  String get timeframeAll => 'الكل';

  @override
  String get history => 'السجل';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get weightEntryDeleted => 'تم حذف إدخال الوزن';

  @override
  String get weightUpdated => 'تم تحديث الوزن';

  @override
  String get editWeight => 'تعديل الوزن';

  @override
  String get recordWeight => 'سجّل الوزن';

  @override
  String get quickAdjust => 'ضبط سريع';

  @override
  String get goalWeightSet => 'تم تعيين الوزن المستهدف';

  @override
  String get goalWeightRemoved => 'تم إلغاء الوزن المستهدف';

  @override
  String get goalAchieved => 'تم تحقيق الهدف!';

  @override
  String get goalMatchesCurrentWeight => 'الهدف يطابق الوزن الحالي';

  @override
  String get setGoal => 'حدّد الهدف';

  @override
  String get suggested => 'مقترح';

  @override
  String get removeGoal => 'امسح الهدف';

  @override
  String get addOneMoreRecordToSeeTrend => 'أضف قياسًا آخر لرؤية الاتجاه';

  @override
  String get noWeightRecorded => 'لم يتم تسجيل أي وزن بعد';

  @override
  String get startTrackingYourWeight => 'سجّل وزنك لتتبع تقدمك';

  @override
  String get treadmillSession => 'جلسة جهاز الجري';

  @override
  String get bikeSession => 'جلسة الدراجة';

  @override
  String get stairmasterSession => 'جلسة جهاز صعود الدرج';

  @override
  String get treadmillWorkout => 'تمرين جهاز الجري';

  @override
  String get bikeWorkout => 'تمرين الدراجة';

  @override
  String get stairmasterWorkout => 'تمرين صعود الدرج';

  @override
  String get startAWorkoutToSeeItHere => 'ستظهر تمارينك هنا';

  @override
  String get mon => 'الاثنين';

  @override
  String get tue => 'الثلاثاء';

  @override
  String get wed => 'الأربعاء';

  @override
  String get thu => 'الخميس';

  @override
  String get fri => 'الجمعة';

  @override
  String get sat => 'السبت';

  @override
  String get sun => 'الأحد';

  @override
  String get sessions => 'الجلسات';

  @override
  String get distance => 'المسافة';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get noWorkoutsYet => 'لا توجد تمارين بعد';

  @override
  String get startYourFirstWorkout => 'ابدأ تمرينك الأول لرؤية سجلك هنا';

  @override
  String get goToRoutines => 'الانتقال إلى الروتينات';

  @override
  String get weightRecorded => 'تم تسجيل الوزن';

  @override
  String get workout => 'تمرين';

  @override
  String get workouts => 'تمارين';

  @override
  String get goal => 'الهدف';

  @override
  String get toGo => 'متبقي';

  @override
  String get over => 'تجاوز';

  @override
  String get last => 'آخر';

  @override
  String get newLabel => 'جديد';

  @override
  String youNeed(String amount, String goal) {
    return 'تحتاج $amount للوصول إلى $goal';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return 'تحتاج +$amount للوصول إلى $goal';
  }

  @override
  String get current => 'الحالي';

  @override
  String get premiumHeadline => 'نفس 30 دقيقة، نتائج مختلفة';

  @override
  String get premiumSubheadlineNew => 'لا تجري فقط، تمرن بطريقة حرق الدهون';

  @override
  String get mostPopular => 'الأكثر شعبية';

  @override
  String dailyPrice(int price) {
    return '$price في اليوم';
  }

  @override
  String get benefitVoiceCoaching => 'نظام التدريب الصوتي المتميز';

  @override
  String get benefitBackgroundIntervalNotifications =>
      'تنبيهات تغيّر الفترات أثناء استخدام تطبيقات أخرى';

  @override
  String get benefitCycleStairmasterRoutines => 'دعم كامل لجميع أجهزة الكارديو';

  @override
  String get benefitUnlimitedRoutinesNew => 'مكتبة تمارين غير محدودة';

  @override
  String get benefitWeightFeature => 'تتبع وتحليل ذكي للوزن';

  @override
  String get benefitNoAdsFocus => 'تجربة متميزة بدون إعلانات';

  @override
  String get benefitFutureFeaturesNew => 'جميع ميزات Premium المستقبلية متضمنة';

  @override
  String get mostChosen => 'الأكثر اختيارًا';

  @override
  String get canChangeAnytime => 'غيّر متى شئت';

  @override
  String get startPremium => 'ابدأ بريميوم';

  @override
  String get cancelAnytimeKeepAccess => 'ألغِ متى شئت واحتفظ بالوصول';

  @override
  String workoutDays(String count) {
    return 'أيام التمرين: $count 🔥';
  }

  @override
  String restDays(String count) {
    return 'أيام الراحة: $count 🛏️';
  }

  @override
  String get workoutReminderTitle => 'التذكيرات';

  @override
  String get workoutReminderOff => 'إيقاف';

  @override
  String get workoutReminderEveryDay => 'كل يوم';

  @override
  String get workoutReminderSelectTime => 'اختر الوقت';

  @override
  String get workoutReminderPermissionRequired => 'يلزم منح إذن الإشعارات.';

  @override
  String get workoutReminderTimeLabel => 'الوقت';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'جرّب تمارين الكارديو المتناوب هذه على Valcue!\n\nالتمرين: $routineName\n\nانسخ الرابط أو اضغط عليه للاستيراد:\n$shareLink';
  }

  @override
  String get scanQrCode => 'مسح رمز QR';

  @override
  String get invalidQrCode => 'رمز QR هذا ليس روتين Valcue.';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get placeQrInside => 'ضع رمز QR داخل منطقة الإطار.';

  @override
  String get customRoutineBuilder => 'إنشاء تمرين مخصص';

  @override
  String get customRoutineAccuracyNoticeTitle => 'قد تختلف القيم قليلاً';

  @override
  String get customRoutineAccuracyPointRounding =>
      'يتم تقريب السرعات إلى أرقام صحيحة';

  @override
  String get customRoutineAccuracyPointVariation => 'يختلف كل روتين قليلاً';

  @override
  String get customRoutineAccuracyPointRange =>
      'تبقى القيم ضمن نطاق آمن لمستوى الصعوبة';

  @override
  String get customRoutineAccuracyResultNote =>
      'قد تختلف القيم الفعلية عن هدفك بنسبة بسيطة';

  @override
  String get customRoutineGenerating => 'جارٍ إنشاء تمرينك المخصص…';

  @override
  String get customRoutineLoadingTarget => 'جارٍ تحديد شدة التمرين المستهدفة…';

  @override
  String get customRoutineLoadingStructure => 'جارٍ إعداد الإحماء والتهدئة…';

  @override
  String get customRoutineLoadingPace => 'جارٍ حساب وتيرة الفترات…';

  @override
  String get customRoutineLoadingVoice => 'جارٍ إعداد الإرشاد الصوتي…';

  @override
  String get generationComplete => 'اكتمل الإنشاء!';

  @override
  String get regenerate => 'إعادة الإنشاء';

  @override
  String get caloriesEstimateByWeight =>
      'السعرات تقديرية بناءً على الوزن المُدخل.';

  @override
  String get commonBack => 'رجوع';

  @override
  String get adjustGoals => 'تعديل الأهداف';

  @override
  String get targetCalories => 'السعرات المستهدفة';

  @override
  String get targetStairs => 'الطوابق المستهدفة';

  @override
  String get targetDistance => 'المسافة المستهدفة';

  @override
  String get currentWeight => 'الوزن الحالي';

  @override
  String get includeIncline => 'تضمين الميل';

  @override
  String get includeWarmupCooldown => 'تضمين الإحماء والتهدئة';

  @override
  String get generateCustomRoutine => 'إنشاء تمرين مخصص';

  @override
  String durationMinutes(String minutes) {
    return '$minutes دقيقة';
  }

  @override
  String floorCount(String count) {
    return 'عدد الطوابق: $count';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'جري مخصص $distance $distanceUnit ($calories سعرة)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'دراجة مخصصة $distance $distanceUnit ($calories سعرة)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'جري تصاعدي $distance $distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'جري هرمي $distance $distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'دراجة تصاعدية $distance $distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'دراجة هرمية $distance $distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'درج مخصص $floors طابق ($calories سعرة)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'تمرينك المخصص جاهز. استهدف نحو $calories سعرة حرارية!';
  }

  @override
  String get weightDeleteTitle => 'حذف السجل';

  @override
  String get weightDeleteConfirm => 'هل تريد بالتأكيد حذف سجل الوزن هذا؟';

  @override
  String get achievementUnlocked => '🏆 تم فتح إنجاز!';

  @override
  String get achievementCongratulations => 'تهانينا! لقد حصلت على شارة جديدة.';

  @override
  String get awesome => 'رائع!';

  @override
  String get shareCardDefault => '9:14 (افتراضي)';

  @override
  String get shareCardStory => '9:16 (قصة)';

  @override
  String get shareCardSquare => '1:1 (مربع)';

  @override
  String get customizeShareCard => 'تخصيص بطاقة المشاركة';

  @override
  String get shareRoutine => 'مشاركة التمرين';

  @override
  String get shareViaQrCode => 'المشاركة عبر رمز QR';

  @override
  String get routineLimitReached => 'تم بلوغ حد التمارين';

  @override
  String get routineLimitMessage =>
      'يمكن للمستخدمين المجانيين حفظ تمرينين لجهاز المشي كحد أقصى. قم بالترقية إلى Premium أو احذف تمرينًا موجودًا.';

  @override
  String get importSharedRoutine => 'استيراد تمرين مشترك';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'تم العثور على تمرين في رمز QR.\n\n• الاسم: $name\n• الصعوبة: $difficulty\n• الفترات: $count\n\nهل تريد حفظه في مكتبتك؟';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'تم العثور على تمرين مشترك في الحافظة.\n\n• الاسم: $name\n• الصعوبة: $difficulty\n• الفترات: $count\n\nهل تريد حفظه في مكتبتك؟';
  }

  @override
  String importRoutineSuccess(String name) {
    return 'تم استيراد «$name» بنجاح!';
  }

  @override
  String get importAction => 'استيراد';

  @override
  String get addRoutineOption => 'اختر طريقة إضافة تمرين';

  @override
  String get createCustomRoutine => 'إنشاء تمرين مخصص';

  @override
  String get importFromClipboard => 'استيراد من الحافظة';

  @override
  String get countdownTiming => 'تنبيهات العد التنازلي';

  @override
  String get noAnnouncements => 'بلا تنبيهات';

  @override
  String secondsShort(String seconds) {
    return 'قبل $seconds ث';
  }

  @override
  String get selectCountdownTimings => 'اختيار أوقات العد التنازلي';

  @override
  String get countdownTimingMessage =>
      'اختر وقت سماع الزمن المتبقي قبل تغير الفترة.';

  @override
  String secondsLeft(String seconds) {
    return 'المتبقي: $seconds ث';
  }

  @override
  String get qrShareInstruction =>
      'امسح رمز QR هذا من تطبيق Valcue آخر\nلاستيراد التمرين فورًا.';

  @override
  String get quickStart => 'بدء سريع';

  @override
  String get sessionRepeatBlock => 'مجموعة جلسة متكررة';

  @override
  String repeatTimes(String count) {
    return 'عدد التكرارات: $count';
  }

  @override
  String get addRepeatBlock => 'إضافة مجموعة تكرار';

  @override
  String get unableToShareWorkout => 'تعذرت مشاركة التمرين.';

  @override
  String get unableToOpenPrivacyPolicy => 'تعذر فتح سياسة الخصوصية.';

  @override
  String get unableToOpenLink => 'تعذر فتح الرابط.';

  @override
  String get less => 'أقل';

  @override
  String get more => 'أكثر';

  @override
  String inclineValue(String value) {
    return 'الميل: $value٪';
  }

  @override
  String rpmValue(String value) {
    return '$value دورة/دقيقة';
  }

  @override
  String nextMetric(String value) {
    return 'التالي: $value';
  }

  @override
  String get weightCalendar => 'تقويم الوزن';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText فترة · $difficulty',
      many: '$duration · $countText فترة · $difficulty',
      few: '$duration · $countText فترات · $difficulty',
      two: '$duration · فترتان · $difficulty',
      one: '$duration · فترة واحدة · $difficulty',
      zero: '$duration · لا فترات · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return 'الهدف: $goalWeight • تم تحقيقه!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return 'الهدف: $goalWeight • متبقي $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return 'الهدف: $goalWeight • تجاوز بمقدار $difference';
  }

  @override
  String averageSpeedKmh(String value) {
    return 'متوسط السرعة: $value كم/س';
  }

  @override
  String averageSpeedMph(String value) {
    return 'متوسط السرعة: $value ميل/س';
  }

  @override
  String averageRpmValue(String value) {
    return 'متوسط الوتيرة: $value دورة/دقيقة';
  }

  @override
  String averageLevelValue(String value) {
    return 'متوسط المستوى: $value';
  }

  @override
  String get purchaseFailed => 'فشلت عملية الشراء. يرجى المحاولة مرة أخرى.';

  @override
  String get restoreSuccess => 'تمت استعادة مشترياتك.';

  @override
  String get restoreNothingToRestore => 'لم يتم العثور على مشتريات سابقة.';

  @override
  String get plansUnavailable => 'تعذر تحميل الخطط. يرجى المحاولة لاحقًا.';
}
