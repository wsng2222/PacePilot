// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => '운동 화면 표시 크기';

  @override
  String get workoutDisplaySizeSubtitle => '운동 중 핵심 수치와 타이머를 크게 표시해요.';

  @override
  String get workoutDisplaySizeStandard => '기본';

  @override
  String get workoutDisplaySizeLarge => '크게';

  @override
  String get workoutDisplaySizeExtraLarge => '매우 크게';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => '설정';

  @override
  String get language => '언어';

  @override
  String get system => '시스템';

  @override
  String get voiceGuide => '음성 가이드';

  @override
  String get audioNavigator => '오디오 네비게이터';

  @override
  String get soundEffects => '사운드 효과';

  @override
  String get unitSetting => '단위';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => '화면 모드';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get smartwatchSync => '스마트워치 동기화';

  @override
  String get connectSmartwatch => '스마트워치 연결하기';

  @override
  String get connect => '연결';

  @override
  String get about => '앱 정보';

  @override
  String version(String version) {
    return '버전 $version';
  }

  @override
  String get comingSoon => '준비 중';

  @override
  String get translationComingSoon => '번역은 추후 업데이트 예정입니다.';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get done => '완료';

  @override
  String get delete => '삭제';

  @override
  String get duplicate => '복제';

  @override
  String get save => '저장';

  @override
  String get edit => '수정';

  @override
  String get start => '시작';

  @override
  String get editRoutine => '루틴 수정';

  @override
  String get routineEdit => '루틴 편집';

  @override
  String get name => '이름';

  @override
  String get unnamedRoutine => '이름 없는 루틴';

  @override
  String get difficulty => '난이도';

  @override
  String difficultyColon(String difficulty) {
    return '난이도 : $difficulty';
  }

  @override
  String get easy => '쉬움';

  @override
  String get medium => '중간';

  @override
  String get hard => '높음';

  @override
  String get interval => '인터벌';

  @override
  String get addInterval => '인터벌 추가';

  @override
  String get quickTools => '빠른 작업';

  @override
  String get addDefault => '기본 추가';

  @override
  String get duplicateLast => '마지막 복제';

  @override
  String get repeatPattern => '패턴 반복';

  @override
  String get reorderIntervals => '순서 변경';

  @override
  String get reorderMode => '순서 변경 모드';

  @override
  String get reorderModeHint => '카드를 길게 눌러 원하는 위치로 옮겨보세요.';

  @override
  String get patternLength => '패턴 길이';

  @override
  String get repeatCount => '추가 횟수';

  @override
  String get noIntervals => '인터벌이 없습니다';

  @override
  String get addIntervalPrompt => '인터벌을 추가하세요';

  @override
  String get intervalEdit => '인터벌 편집';

  @override
  String get timeMinutes => '시간(분)';

  @override
  String get duration => '시간';

  @override
  String get speed => '속도';

  @override
  String get speedKmh => '속도(km/h)';

  @override
  String get incline => '경사도';

  @override
  String get level => '레벨';

  @override
  String levelColon(String level) {
    return '레벨 $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPM은 1분 동안 페달이 몇 바퀴 도는지 보여주는 값이에요. 숫자가 높을수록 더 빠른 케이던스로 페달을 밟는다는 뜻입니다.';

  @override
  String get resistance => '저항';

  @override
  String get resistanceLevel => '저항(레벨)';

  @override
  String resistanceColon(String resistance) {
    return '저항 $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM(분당 걸음 수)';

  @override
  String get saved => '저장됨';

  @override
  String get deleted => '삭제됨';

  @override
  String get deleteRoutineTitle => '루틴 삭제';

  @override
  String get deleteRoutineMessage => '이 루틴을 삭제할까요? 삭제하면 되돌릴 수 없어요.';

  @override
  String get deleteError => '삭제 중 오류가 발생했습니다';

  @override
  String get nameRequired => '이름을 입력해주세요';

  @override
  String get nameMaxLength => '이름은 50자 이하여야 합니다';

  @override
  String get minIntervalsRequired => '최소 하나의 인터벌이 필요합니다';

  @override
  String get intervalMinDuration => '인터벌 시간은 최소 1초 이상이어야 합니다';

  @override
  String get intervalMaxDuration => '인터벌 시간은 최대 3시간(10800초)까지 가능합니다';

  @override
  String get speedRange => '속도는 0보다 큰 값이어야 합니다 (0.5-25.0 km/h)';

  @override
  String get inclineRange => '경사도는 0-15.0 범위여야 합니다';

  @override
  String get rpmRange => 'RPM은 30-200 범위여야 합니다';

  @override
  String get resistanceRange => '저항은 1-20 범위여야 합니다';

  @override
  String get levelRange => '레벨은 1-20 범위여야 합니다';

  @override
  String get spmRange => 'SPM은 50-200 범위여야 합니다';

  @override
  String get noRoutinesSaved => '저장된 루틴이 없습니다';

  @override
  String get tapToCreate => '화면을 터치해 생성하기';

  @override
  String get tapButtonToCreate => '버튼을 터치해 생성하기';

  @override
  String get premiumRoutineSettings => '프리미엄 루틴 설정';

  @override
  String get viewMembership => '프리미엄 보기';

  @override
  String get freeLimitTitle => '무료 루틴 2개';

  @override
  String get freeLimitMessage => '프리미엄으로 루틴을 무제한 사용하세요';

  @override
  String get treadmill => '러닝머신';

  @override
  String get cycle => '사이클';

  @override
  String get stairmaster => '천국의 계단';

  @override
  String get selectLanguage => '언어';

  @override
  String get selectTheme => '테마 선택';

  @override
  String get selectDifficulty => '난이도 선택';

  @override
  String get pause => '일시중지';

  @override
  String get resume => '계속하기';

  @override
  String get endWorkout => '운동 종료';

  @override
  String get endWorkoutConfirm => '운동을 종료하시겠습니까?';

  @override
  String get end => '종료';

  @override
  String get share => '공유';

  @override
  String get rotate => '회전';

  @override
  String get paused => '일시중지됨';

  @override
  String get pausedTitle => '일시정지됨';

  @override
  String get pausedSubtitle => '계속하거나 운동을 종료할 수 있어요';

  @override
  String get endWorkoutConfirmationMessage =>
      '종료하면 현재 진행 중인 운동이 끝나고 요약 화면으로 이동해요.';

  @override
  String get workoutComplete => '운동 완료';

  @override
  String get backgroundIntervalNotificationTitle => '새 구간 시작';

  @override
  String get backgroundIntervalNotificationsTitle => '화면 꺼짐 중에도 알림';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => '준비';

  @override
  String get liveActivityInProgress => '운동 중';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return '$current/$total 구간';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return '$duration 동안';
  }

  @override
  String get totalWorkoutTime => '총 시간';

  @override
  String get totalDistance => '총 거리';

  @override
  String get totalTime => '총 시간';

  @override
  String get averageRpm => '평균 RPM';

  @override
  String get averageLevel => '평균 레벨';

  @override
  String get holdToStop => '길게 눌러 정지';

  @override
  String get continueWorkout => '계속';

  @override
  String get endWorkoutQuestion => '운동을 종료할까요?';

  @override
  String get workoutPaused => '운동이 일시중지되었습니다';

  @override
  String get lvlIncline => '경사도';

  @override
  String get lvlResistance => '저항';

  @override
  String get premium => '프리미엄';

  @override
  String get upgradeNow => '지금 업그레이드하기';

  @override
  String get purchase => '구매하기';

  @override
  String get later => '나중에';

  @override
  String get premiumActivated => '프리미엄이 활성화되었습니다';

  @override
  String get premiumMembership => '프리미엄';

  @override
  String get benefitCycleStairmaster => '사이클 및 천국의 계단 루틴';

  @override
  String get benefitVoiceGuide => '세션별 음성 가이드 안내';

  @override
  String get benefitUnlimitedRoutines => '루틴 저장 개수 무제한';

  @override
  String get noAds => '광고 없음';

  @override
  String get benefitFutureFeatures => '향후 추가되는 모든 기능 포함';

  @override
  String get voiceGuideBenefit1 => '운동 중 음성 코칭 안내';

  @override
  String get voiceGuideBenefit2 => '세션 전환 시 자동 안내';

  @override
  String get voiceGuideBenefit3 => '화면을 보지 않고 운동에 집중';

  @override
  String get routineLimitBenefit1 => '루틴 저장 개수 무제한';

  @override
  String get routineLimitBenefit2 => '목표별 맞춤 루틴 저장';

  @override
  String get routineLimitBenefit3 => '러닝머신/사이클/천국의 계단 완벽 지원';

  @override
  String get premium_benefit_1 => '<red>사이클, 천국의 계단</red> 지원';

  @override
  String get premium_benefit_2 => '세션별 <red>음성 가이드</red> 제공';

  @override
  String get premium_benefit_3 => '루틴 저장 개수 <red>무제한</red>';

  @override
  String get premium_benefit_4 => '향후 추가되는 모든 기능 <red>평생 포함</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/월';
  }

  @override
  String get premiumSubheadline => '음성 가이드, 사이클 및 천국의 계단 운동, 무제한 루틴 잠금 해제';

  @override
  String get monthly => '월간';

  @override
  String get yearly => '연간';

  @override
  String get lifetime => '평생';

  @override
  String get freeTrial7Days => '7일 무료 트라이얼';

  @override
  String get perMonth => '/월';

  @override
  String get perYear => '/년';

  @override
  String get oneTime => '일회성';

  @override
  String savePercent(String percent) {
    return '$percent 절약';
  }

  @override
  String get bestValue => '최고의 가치';

  @override
  String get cancelAnytime => '언제든지 취소 가능';

  @override
  String get autoRenewableSubscription => '자동 갱신';

  @override
  String get terms => '약관';

  @override
  String get privacy => '개인정보처리방침';

  @override
  String get restore => '복원';

  @override
  String get premiumTab => '프리미엄';

  @override
  String get routineTab => '루틴';

  @override
  String get settingsTab => '설정';

  @override
  String get myTab => '나';

  @override
  String get close => '닫기';

  @override
  String get premiumFeature => '프리미엄 전용';

  @override
  String get usePremiumTest => '프리미엄 테스트';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$year년 $month월 $day일 $hour시 $minute분';
  }

  @override
  String get checkRoutineStart => '루틴 확인 / 시작';

  @override
  String get beginner => '초급';

  @override
  String get intermediate => '중급';

  @override
  String get advanced => '고급';

  @override
  String get viewRecommendedRoutines => '추천 →';

  @override
  String get recommendedRoutinesTreadmill => '추천 러닝';

  @override
  String get recommendedRoutinesCycle => '추천 사이클';

  @override
  String get recommendedRoutinesStairmaster => '추천 계단';

  @override
  String get alreadySaved => '이미 저장되었습니다';

  @override
  String get routineSaved => '루틴이 저장되었습니다';

  @override
  String get checkRoutine => '미리보기';

  @override
  String get saveRoutine => '루틴 저장';

  @override
  String get routineAlreadySaved => '이미 저장된 루틴입니다';

  @override
  String get noTemplatesFound => '템플릿을 찾을 수 없습니다';

  @override
  String get avg => '평균';

  @override
  String get avgRpm => '평균 RPM';

  @override
  String get avgLevel => '평균 레벨';

  @override
  String get templateTreadmillBeginner1Title => '초급 러닝머신 1';

  @override
  String get templateTreadmillBeginner1Subtitle => '3분 워밍업 후 1:1 걷고 달리기';

  @override
  String get templateTreadmillBeginner2Title => '초급 러닝머신 2 (경사)';

  @override
  String get templateTreadmillBeginner2Subtitle => '무릎 부담이 적은 경사 걷기';

  @override
  String get templateTreadmillIntermediate1Title => '중급 러닝머신 1';

  @override
  String get templateTreadmillIntermediate1Subtitle => '지방 연소를 돕는 1:1 러닝 인터벌';

  @override
  String get templateTreadmillIntermediate2Title => '중급 러닝머신 2 (스피드)';

  @override
  String get templateTreadmillIntermediate2Subtitle => '단계별로 속도가 빨라지는 러닝';

  @override
  String get templateTreadmillAdvanced1Title => '고급 러닝머신 1';

  @override
  String get templateTreadmillAdvanced1Subtitle => '심폐 기능 극대화를 위한 고강도 인터벌';

  @override
  String get templateTreadmillAdvanced2Title => '고급 러닝머신 2 (스프린트)';

  @override
  String get templateTreadmillAdvanced2Subtitle => '짧고 굵은 전력 질주 반복 코스';

  @override
  String get templateCycleBeginner1Title => '초급 사이클 1';

  @override
  String get templateCycleBeginner1Subtitle => 'RPM 조절로 다리를 푸는 페달링 입문';

  @override
  String get templateCycleBeginner2Title => '초급 사이클 2 (지속주)';

  @override
  String get templateCycleBeginner2Subtitle => '고정 강도로 일정하게 타는 지구력 향상 코스';

  @override
  String get templateCycleIntermediate1Title => '중급 사이클 1';

  @override
  String get templateCycleIntermediate1Subtitle => '1분 고속 회전 / 1분 회복 스피닝 코스';

  @override
  String get templateCycleIntermediate2Title => '중급 사이클 2 (언덕)';

  @override
  String get templateCycleIntermediate2Subtitle => '높은 페달 저항을 버티는 하체 단련 코스';

  @override
  String get templateCycleAdvanced1Title => '고급 사이클 1';

  @override
  String get templateCycleAdvanced1Subtitle => '30초 고저항 파워 인터벌';

  @override
  String get templateCycleAdvanced2Title => '고급 사이클 2 (타바타)';

  @override
  String get templateCycleAdvanced2Subtitle => '체지방 연소를 위한 20초/10초 타바타 서킷';

  @override
  String get templateStairmasterBeginner1Title => '초급 계단 1';

  @override
  String get templateStairmasterBeginner1Subtitle => '느린 속도로 안전하게 적응하는 계단 걷기';

  @override
  String get templateStairmasterBeginner2Title => '초급 계단 2 (지속주)';

  @override
  String get templateStairmasterBeginner2Subtitle => '일정한 템포로 길게 오르는 유산소 입문';

  @override
  String get templateStairmasterIntermediate1Title => '중급 계단 1 (언덕)';

  @override
  String get templateStairmasterIntermediate1Subtitle =>
      '2분 오르기 / 1분 회복으로 둔근 자극 극대화';

  @override
  String get templateStairmasterIntermediate2Title => '중급 계단 2';

  @override
  String get templateStairmasterIntermediate2Subtitle =>
      '빠른 템포와 느린 템포를 번갈아 밟는 인터벌';

  @override
  String get templateStairmasterAdvanced1Title => '고급 계단 1';

  @override
  String get templateStairmasterAdvanced1Subtitle => '강도가 높은 2분 집중 트레이닝';

  @override
  String get templateStairmasterAdvanced2Title => '고급 계단 2 (스프린트)';

  @override
  String get templateStairmasterAdvanced2Subtitle =>
      '30초 고속 오르기 / 60초 긴 회복 인터벌';

  @override
  String get historyTab => '기록';

  @override
  String get calendarTab => '캘린더';

  @override
  String get weightTab => '체중';

  @override
  String get bike => '사이클';

  @override
  String get thisWeek => '이번 주';

  @override
  String get trend => '체중 추이';

  @override
  String get timeframe7D => '7일';

  @override
  String get timeframe30D => '30일';

  @override
  String get timeframe90D => '90일';

  @override
  String get timeframeAll => '전체';

  @override
  String get history => '기록';

  @override
  String get seeAll => '전체 보기';

  @override
  String get weightEntryDeleted => '체중 기록이 삭제되었습니다';

  @override
  String get weightUpdated => '체중이 업데이트되었습니다';

  @override
  String get editWeight => '체중 수정';

  @override
  String get recordWeight => '체중 기록';

  @override
  String get quickAdjust => '빠른 수정';

  @override
  String get goalWeightSet => '목표 체중이 설정되었습니다';

  @override
  String get goalWeightRemoved => '목표 체중이 해제되었습니다';

  @override
  String get goalAchieved => '목표 달성!';

  @override
  String get goalMatchesCurrentWeight => '목표가 현재 체중과 일치합니다';

  @override
  String get setGoal => '목표 설정';

  @override
  String get suggested => '추천';

  @override
  String get removeGoal => '목표 삭제';

  @override
  String get addOneMoreRecordToSeeTrend => '기록 1개만 더 추가하면 추이를 볼 수 있어요';

  @override
  String get noWeightRecorded => '아직 기록된 체중이 없습니다';

  @override
  String get startTrackingYourWeight => '체중을 기록해 변화를 확인하세요';

  @override
  String get treadmillSession => '러닝머신 세션';

  @override
  String get bikeSession => '사이클 세션';

  @override
  String get stairmasterSession => '천국의 계단 세션';

  @override
  String get treadmillWorkout => '러닝머신 운동';

  @override
  String get bikeWorkout => '사이클 운동';

  @override
  String get stairmasterWorkout => '천국의 계단 운동';

  @override
  String get startAWorkoutToSeeItHere => '운동 기록이 여기에 표시돼요';

  @override
  String get mon => '월';

  @override
  String get tue => '화';

  @override
  String get wed => '수';

  @override
  String get thu => '목';

  @override
  String get fri => '금';

  @override
  String get sat => '토';

  @override
  String get sun => '일';

  @override
  String get sessions => '세션';

  @override
  String get distance => '거리';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get noWorkoutsYet => '아직 운동 기록이 없습니다';

  @override
  String get startYourFirstWorkout => '첫 운동을 시작하여 기록을 확인하세요';

  @override
  String get goToRoutines => '루틴으로 이동';

  @override
  String get weightRecorded => '체중이 기록되었습니다';

  @override
  String get workout => '운동';

  @override
  String get workouts => '운동 횟수';

  @override
  String get goal => '목표';

  @override
  String get toGo => '남았습니다';

  @override
  String get over => '초과';

  @override
  String get last => '이전';

  @override
  String get newLabel => '새로운';

  @override
  String youNeed(String amount, String goal) {
    return '$amount만큼 더 해야 $goal에 도달합니다';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return '+$amount만큼 더 해야 $goal에 도달합니다';
  }

  @override
  String get current => '현재';

  @override
  String get premiumHeadline => '같은 30분, 결과는 다르게';

  @override
  String get premiumSubheadlineNew => '그냥 뛰지 말고, 효과적으로 체지방을 태워보세요';

  @override
  String get mostPopular => '가장 인기';

  @override
  String dailyPrice(int price) {
    return '하루 $price원';
  }

  @override
  String get benefitVoiceCoaching => '프리미엄 음성 코칭 시스템';

  @override
  String get benefitBackgroundIntervalNotifications => '다른 앱 사용 중에도 구간 변경 알림';

  @override
  String get benefitCycleStairmasterRoutines => '모든 유산소 기구 완벽 지원';

  @override
  String get benefitUnlimitedRoutinesNew => '무제한 루틴 라이브러리';

  @override
  String get benefitWeightFeature => '스마트 체중 추적 & 분석';

  @override
  String get benefitNoAdsFocus => '광고 없는 프리미엄 경험';

  @override
  String get benefitFutureFeaturesNew => '추후 프리미엄 기능 전체 포함';

  @override
  String get mostChosen => '가장 인기';

  @override
  String get canChangeAnytime => '언제든 변경';

  @override
  String get startPremium => '프리미엄 시작';

  @override
  String get cancelAnytimeKeepAccess => '언제든 해지, 기간 끝까지 이용';

  @override
  String workoutDays(String count) {
    return '운동일 $count일 🔥';
  }

  @override
  String restDays(String count) {
    return '휴식일 $count일 🛏️';
  }

  @override
  String get workoutReminderTitle => '운동 알림';

  @override
  String get workoutReminderOff => '꺼짐';

  @override
  String get workoutReminderEveryDay => '매일';

  @override
  String get workoutReminderSelectTime => '시간 선택';

  @override
  String get workoutReminderPermissionRequired => '알림 권한이 필요합니다.';

  @override
  String get workoutReminderTimeLabel => '시간';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Valcue에서 이 인터벌 운동 루틴을 해보세요!\n\n루틴 이름: $routineName\n\n아래 링크를 복사하거나 클릭해 가져올 수 있습니다:\n$shareLink';
  }

  @override
  String get scanQrCode => 'QR 코드 스캔';

  @override
  String get invalidQrCode => '이 QR 코드는 Valcue 루틴이 아니에요.';

  @override
  String get previousMonth => '이전 달';

  @override
  String get nextMonth => '다음 달';

  @override
  String get placeQrInside => '가이드 영역 안에 QR 코드를 맞춰주세요.';

  @override
  String get customRoutineBuilder => '맞춤 루틴 생성';

  @override
  String get customRoutineGenerating => '맞춤 운동 루틴을 생성하고 있어요';

  @override
  String get customRoutineLoadingTarget => '유산소 강도 목표 설정 중...';

  @override
  String get customRoutineLoadingStructure => '준비 운동과 마무리 운동 구성 중...';

  @override
  String get customRoutineLoadingPace => '구간별 맞춤 페이스 계산 중...';

  @override
  String get customRoutineLoadingVoice => '음성 코칭 준비 중...';

  @override
  String get generationComplete => '생성 완료!';

  @override
  String get regenerate => '재생성';

  @override
  String get caloriesEstimateByWeight => '칼로리는 입력한 체중 기준 예상치예요.';

  @override
  String get commonBack => '이전으로';

  @override
  String get adjustGoals => '조건 수정';

  @override
  String get targetCalories => '목표 칼로리';

  @override
  String get targetStairs => '목표 층수';

  @override
  String get targetDistance => '목표 거리';

  @override
  String get currentWeight => '현재 체중';

  @override
  String get includeIncline => '경사도 적용';

  @override
  String get includeWarmupCooldown => '웜업 / 쿨다운 포함';

  @override
  String get generateCustomRoutine => '맞춤 루틴 생성하기';

  @override
  String durationMinutes(String minutes) {
    return '$minutes분';
  }

  @override
  String floorCount(String count) {
    return '$count층';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return '맞춤 러닝 $distance$distanceUnit (${calories}kcal)';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return '맞춤 사이클 $distance$distanceUnit (${calories}kcal)';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return '빌드업 러닝 $distance$distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return '피라미드 러닝 $distance$distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return '빌드업 라이딩 $distance$distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return '피라미드 라이딩 $distance$distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return '맞춤 계단 $floors층 (${calories}kcal)';
  }

  @override
  String customRoutineSpeech(String calories) {
    return '맞춤 루틴이 완성됐어요. 약 $calories칼로리를 목표로 시작해 보세요!';
  }

  @override
  String get weightDeleteTitle => '기록 삭제';

  @override
  String get weightDeleteConfirm => '이 체중 기록을 삭제하시겠습니까?';

  @override
  String get achievementUnlocked => '🏆 업적 달성!';

  @override
  String get achievementCongratulations => '새로운 배지를 획득했어요. 축하합니다!';

  @override
  String get awesome => '확인';

  @override
  String get shareCardDefault => '9:14 (기본)';

  @override
  String get shareCardStory => '9:16 (스토리)';

  @override
  String get shareCardSquare => '1:1 (정사각형)';

  @override
  String get customizeShareCard => '공유 카드 꾸미기';

  @override
  String get shareRoutine => '루틴 공유하기';

  @override
  String get shareViaQrCode => 'QR 코드로 공유';

  @override
  String get routineLimitReached => '루틴 제한 초과';

  @override
  String get routineLimitMessage =>
      '무료 사용자는 러닝머신 루틴을 최대 2개까지 저장할 수 있습니다. 프리미엄으로 업그레이드하거나 기존 루틴을 삭제하세요.';

  @override
  String get importSharedRoutine => '공유된 루틴 가져오기';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return '스캔한 QR 코드에서 루틴을 찾았습니다.\n\n• 이름: $name\n• 난이도: $difficulty\n• 구간 수: $count개\n\n이 루틴을 보관함에 저장할까요?';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return '클립보드에서 공유된 루틴을 찾았습니다.\n\n• 이름: $name\n• 난이도: $difficulty\n• 구간 수: $count개\n\n이 루틴을 보관함에 저장할까요?';
  }

  @override
  String importRoutineSuccess(String name) {
    return '\'$name\' 루틴을 가져왔습니다!';
  }

  @override
  String get importAction => '가져오기';

  @override
  String get addRoutineOption => '루틴 추가 방법 선택';

  @override
  String get createCustomRoutine => '새 커스텀 루틴 만들기';

  @override
  String get importFromClipboard => '클립보드에서 가져오기';

  @override
  String get countdownTiming => '카운트다운 알림';

  @override
  String get noAnnouncements => '알림 없음';

  @override
  String secondsShort(String seconds) {
    return '$seconds초 전';
  }

  @override
  String get selectCountdownTimings => '카운트다운 알림 타이밍 선택';

  @override
  String get countdownTimingMessage => '운동 강도가 바뀌기 몇 초 전에 음성 안내를 받을지 선택하세요.';

  @override
  String secondsLeft(String seconds) {
    return '$seconds초 전';
  }

  @override
  String get qrShareInstruction =>
      '상대방의 Valcue 앱에서 QR 코드를 스캔하면\n이 루틴을 바로 가져올 수 있습니다.';

  @override
  String get quickStart => '빠른 시작';

  @override
  String get sessionRepeatBlock => '세션 반복 세트';

  @override
  String repeatTimes(String count) {
    return '$count회 반복';
  }

  @override
  String get addRepeatBlock => '반복 세션 추가';

  @override
  String get unableToShareWorkout => '운동을 공유할 수 없습니다.';

  @override
  String get unableToOpenPrivacyPolicy => '개인정보처리방침을 열 수 없습니다.';

  @override
  String get unableToOpenLink => '링크를 열 수 없습니다.';

  @override
  String get less => '적음';

  @override
  String get more => '많음';

  @override
  String inclineValue(String value) {
    return '경사도 $value%';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return '다음: $value';
  }

  @override
  String get weightCalendar => '체중 캘린더';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · 인터벌 $countText개 · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return '목표 $goalWeight • 달성!';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return '목표 $goalWeight • $difference 남음';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return '목표 $goalWeight • $difference 초과';
  }

  @override
  String averageSpeedKmh(String value) {
    return '평균 ${value}km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return '평균 ${value}mph';
  }

  @override
  String averageRpmValue(String value) {
    return '평균 ${value}RPM';
  }

  @override
  String averageLevelValue(String value) {
    return '평균 레벨 $value';
  }

  @override
  String get purchaseFailed => '구매에 실패했습니다. 다시 시도해주세요.';

  @override
  String get restoreSuccess => '구매 내역이 복원되었습니다.';

  @override
  String get restoreNothingToRestore => '복원할 구매 내역이 없습니다.';

  @override
  String get plansUnavailable => '요금제를 불러올 수 없습니다. 나중에 다시 시도해주세요.';
}
