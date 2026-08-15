// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => 'ワークアウト画面のサイズ';

  @override
  String get workoutDisplaySizeSubtitle => '主な運動データとタイマーを大きく表示します。';

  @override
  String get workoutDisplaySizeStandard => '標準';

  @override
  String get workoutDisplaySizeLarge => '大';

  @override
  String get workoutDisplaySizeExtraLarge => '特大';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '言語';

  @override
  String get system => 'システム';

  @override
  String get voiceGuide => '音声ガイド';

  @override
  String get audioNavigator => 'オーディオナビゲーター';

  @override
  String get soundEffects => 'サウンド効果';

  @override
  String get unitSetting => '単位';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => '表示';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get smartwatchSync => 'スマートウォッチ同期';

  @override
  String get connectSmartwatch => 'スマートウォッチに接続';

  @override
  String get connect => '接続';

  @override
  String get about => 'について';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get comingSoon => '近日公開';

  @override
  String get translationComingSoon => '翻訳は今後のアップデートで利用可能になります。';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get done => '完了';

  @override
  String get delete => '削除';

  @override
  String get duplicate => '複製';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get start => '開始';

  @override
  String get editRoutine => 'ルーティンを編集';

  @override
  String get routineEdit => 'ルーティン編集';

  @override
  String get name => '名前';

  @override
  String get unnamedRoutine => '名前のないルーティン';

  @override
  String get difficulty => '難易度';

  @override
  String difficultyColon(String difficulty) {
    return '難易度 : $difficulty';
  }

  @override
  String get easy => '簡単';

  @override
  String get medium => '中程度';

  @override
  String get hard => '難しい';

  @override
  String get interval => 'インターバル';

  @override
  String get addInterval => 'インターバルを追加';

  @override
  String get quickTools => 'クイック操作';

  @override
  String get addDefault => '基本追加';

  @override
  String get duplicateLast => '最後を複製';

  @override
  String get repeatPattern => 'パターン反復';

  @override
  String get reorderIntervals => '順序変更';

  @override
  String get reorderMode => '順序変更モード';

  @override
  String get reorderModeHint => 'カードを長押しして、好きな位置に移動してください。';

  @override
  String get patternLength => 'パターン長';

  @override
  String get repeatCount => '追加回数';

  @override
  String get noIntervals => 'インターバルがありません';

  @override
  String get addIntervalPrompt => 'インターバルを追加してください';

  @override
  String get intervalEdit => 'インターバル編集';

  @override
  String get timeMinutes => '時間（分）';

  @override
  String get duration => '時間';

  @override
  String get speed => '速度';

  @override
  String get speedKmh => '速度（km/h）';

  @override
  String get incline => '傾斜';

  @override
  String get level => 'レベル';

  @override
  String levelColon(String level) {
    return 'レベル $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription =>
      'RPMは1分間にペダルが何回転するかを示す値です。数値が高いほど、より速いケイデンスでペダルをこいでいることを意味します。';

  @override
  String get resistance => '抵抗';

  @override
  String get resistanceLevel => '抵抗（レベル）';

  @override
  String resistanceColon(String resistance) {
    return '抵抗 $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM（ステップ/分）';

  @override
  String get saved => '保存済み';

  @override
  String get deleted => '削除されました';

  @override
  String get deleteRoutineTitle => 'ルーティンを削除';

  @override
  String get deleteRoutineMessage => 'このルーティンを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get deleteError => '削除中にエラーが発生しました';

  @override
  String get nameRequired => '名前を入力してください';

  @override
  String get nameMaxLength => '名前は50文字以下である必要があります';

  @override
  String get minIntervalsRequired => '少なくとも1つのインターバルが必要です';

  @override
  String get intervalMinDuration => 'インターバルの時間は少なくとも1秒である必要があります';

  @override
  String get intervalMaxDuration => 'インターバルの時間は最大3時間（10800秒）まで可能です';

  @override
  String get speedRange => '速度は0より大きい値である必要があります（0.5-25.0 km/h）';

  @override
  String get inclineRange => '傾斜は0-15.0の範囲である必要があります';

  @override
  String get rpmRange => 'RPMは30-200の範囲である必要があります';

  @override
  String get resistanceRange => '抵抗は1-20の範囲である必要があります';

  @override
  String get levelRange => 'レベルは1-20の範囲である必要があります';

  @override
  String get spmRange => 'SPMは50-200の範囲である必要があります';

  @override
  String get noRoutinesSaved => '保存されたルーティンがありません';

  @override
  String get tapToCreate => 'タップして作成';

  @override
  String get tapButtonToCreate => 'ボタンをタップして作成';

  @override
  String get premiumRoutineSettings => 'プレミアムルーティン設定';

  @override
  String get viewMembership => 'Premiumを見る';

  @override
  String get freeLimitTitle => '無料は2件まで';

  @override
  String get freeLimitMessage => 'Premiumでルーティン使い放題';

  @override
  String get treadmill => 'ランニングマシン';

  @override
  String get cycle => 'サイクル';

  @override
  String get stairmaster => 'ステアクライマー';

  @override
  String get selectLanguage => '言語';

  @override
  String get selectTheme => 'テーマを選択';

  @override
  String get selectDifficulty => '難易度を選択';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get endWorkout => 'ワークアウト終了';

  @override
  String get endWorkoutConfirm => 'ワークアウトを終了しますか？';

  @override
  String get end => '終了';

  @override
  String get share => '共有';

  @override
  String get rotate => '回転';

  @override
  String get paused => '一時停止中';

  @override
  String get pausedTitle => '一時停止中';

  @override
  String get pausedSubtitle => '続けるか、ワークアウトを終了できます';

  @override
  String get endWorkoutConfirmationMessage =>
      '終了すると、現在進行中のワークアウトが終了し、要約画面に移動します。';

  @override
  String get workoutComplete => 'ワークアウト完了';

  @override
  String get backgroundIntervalNotificationTitle => '新しい区間開始';

  @override
  String get backgroundIntervalNotificationsTitle => '画面オフでも通知';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => '準備中';

  @override
  String get liveActivityInProgress => 'ワークアウト中';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return 'インターバル $current/$total';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return '$duration間';
  }

  @override
  String get totalWorkoutTime => '合計時間';

  @override
  String get totalDistance => '総距離';

  @override
  String get totalTime => '合計時間';

  @override
  String get averageRpm => '平均RPM';

  @override
  String get averageLevel => '平均レベル';

  @override
  String get holdToStop => '長押しで停止';

  @override
  String get continueWorkout => '続ける';

  @override
  String get endWorkoutQuestion => 'ワークアウトを終了しますか？';

  @override
  String get workoutPaused => 'ワークアウトが一時停止されました';

  @override
  String get lvlIncline => '傾斜';

  @override
  String get lvlResistance => 'レベル抵抗';

  @override
  String get premium => 'プレミアム';

  @override
  String get upgradeNow => '今すぐアップグレード';

  @override
  String get purchase => '購入';

  @override
  String get later => '後で';

  @override
  String get premiumActivated => 'プレミアムが有効になりました';

  @override
  String get premiumMembership => 'Premium';

  @override
  String get benefitCycleStairmaster => 'バイク・クライマー（階段登り）ルーティン';

  @override
  String get benefitVoiceGuide => 'セッションごとの音声ガイド案内';

  @override
  String get benefitUnlimitedRoutines => 'ルーティンの保存件数無制限';

  @override
  String get noAds => '広告なし';

  @override
  String get benefitFutureFeatures => '将来追加されるすべての機能を含む';

  @override
  String get voiceGuideBenefit1 => '運動中の音声コーチング案内';

  @override
  String get voiceGuideBenefit2 => 'セッション切り替え時の自動案内';

  @override
  String get voiceGuideBenefit3 => '画面を見ずに運動に集中';

  @override
  String get routineLimitBenefit1 => 'ルーティンの保存件数無制限';

  @override
  String get routineLimitBenefit2 => '目標に合わせたカスタムルーティンの保存';

  @override
  String get routineLimitBenefit3 => 'ランニングマシン/バイク/クライマーを完全サポート';

  @override
  String get premium_benefit_1 => '<red>バイク、クライマー</red>に対応';

  @override
  String get premium_benefit_2 => 'セッションごとの<red>音声ガイド</red>提供';

  @override
  String get premium_benefit_3 => 'ルーティン保存件数<red>無制限</red>';

  @override
  String get premium_benefit_4 => '将来追加される機能も<red>永続的に含む</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/月';
  }

  @override
  String get premiumSubheadline =>
      '音声ガイド、バイクとステアクライマーのワークアウト、ルーティンの無制限保存を利用できます';

  @override
  String get monthly => '月額';

  @override
  String get yearly => '年額';

  @override
  String get lifetime => '生涯';

  @override
  String get freeTrial7Days => '7日間無料トライアル';

  @override
  String get perMonth => '/月';

  @override
  String get perYear => '/年';

  @override
  String get oneTime => '1回限りの支払い';

  @override
  String savePercent(String percent) {
    return '$percentお得';
  }

  @override
  String get bestValue => 'ベストバリュー';

  @override
  String get cancelAnytime => 'いつでもキャンセル可能';

  @override
  String get autoRenewableSubscription => '自動更新';

  @override
  String get terms => '利用規約';

  @override
  String get privacy => 'プライバシー';

  @override
  String get restore => '復元';

  @override
  String get premiumTab => 'プレミアム';

  @override
  String get routineTab => 'ルーティン';

  @override
  String get settingsTab => '設定';

  @override
  String get myTab => 'マイ';

  @override
  String get close => '閉じる';

  @override
  String get premiumFeature => 'Premium限定';

  @override
  String get usePremiumTest => 'Premiumを試す';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$year年$month月$day日 $hour時$minute分';
  }

  @override
  String get checkRoutineStart => '確認して開始';

  @override
  String get beginner => '初級';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '上級';

  @override
  String get viewRecommendedRoutines => 'おすすめ →';

  @override
  String get recommendedRoutinesTreadmill => 'おすすめランニング';

  @override
  String get recommendedRoutinesCycle => 'おすすめバイク';

  @override
  String get recommendedRoutinesStairmaster => 'おすすめ階段';

  @override
  String get alreadySaved => '既に保存済み';

  @override
  String get routineSaved => 'ルーティンが保存されました';

  @override
  String get checkRoutine => '見る';

  @override
  String get saveRoutine => 'ルーティンを保存';

  @override
  String get routineAlreadySaved => 'ルーティンは既に保存されています';

  @override
  String get noTemplatesFound => 'テンプレートが見つかりません';

  @override
  String get avg => '平均';

  @override
  String get avgRpm => '平均 RPM';

  @override
  String get avgLevel => '平均レベル';

  @override
  String get templateTreadmillBeginner1Title => '初級ランニングマシン 1';

  @override
  String get templateTreadmillBeginner1Subtitle => '3分ウォームアップ後 1:1歩行・走行';

  @override
  String get templateTreadmillBeginner2Title => '初級ランニングマシン 2 (傾斜)';

  @override
  String get templateTreadmillBeginner2Subtitle => '関節への負担が少ない傾斜歩行';

  @override
  String get templateTreadmillIntermediate1Title => '中級ランニングマシン 1';

  @override
  String get templateTreadmillIntermediate1Subtitle => '脂肪燃焼を促す 1:1走行インターバル';

  @override
  String get templateTreadmillIntermediate2Title => '中級ランニングマシン 2 (スピード)';

  @override
  String get templateTreadmillIntermediate2Subtitle => '段階的に速度を上げるビルドアップ走行';

  @override
  String get templateTreadmillAdvanced1Title => '上級ランニングマシン 1';

  @override
  String get templateTreadmillAdvanced1Subtitle => '心肺機能を高める高強度インターバル';

  @override
  String get templateTreadmillAdvanced2Title => '上級ランニングマシン 2 (スプリント)';

  @override
  String get templateTreadmillAdvanced2Subtitle => '短時間高強度のスプリント反復コース';

  @override
  String get templateCycleBeginner1Title => '初級バイク 1';

  @override
  String get templateCycleBeginner1Subtitle => 'RPM調整によるペダリング入門';

  @override
  String get templateCycleBeginner2Title => '初級バイク 2 (持続走行)';

  @override
  String get templateCycleBeginner2Subtitle => '一定負荷による持久力向上ロード';

  @override
  String get templateCycleIntermediate1Title => '中級バイク 1';

  @override
  String get templateCycleIntermediate1Subtitle => '1分高速回転 / 1分回復のスピンコース';

  @override
  String get templateCycleIntermediate2Title => '中級バイク 2 (ヒルクライム)';

  @override
  String get templateCycleIntermediate2Subtitle => '高負荷での下半身強化ヒルクライム';

  @override
  String get templateCycleAdvanced1Title => '上級バイク 1';

  @override
  String get templateCycleAdvanced1Subtitle => '30秒高負荷パワーインターバル';

  @override
  String get templateCycleAdvanced2Title => '上級バイク 2 (タバタ)';

  @override
  String get templateCycleAdvanced2Subtitle => '脂肪燃焼のための20秒/10秒タバタサーキット';

  @override
  String get templateStairmasterBeginner1Title => '初級ステアクライマー 1';

  @override
  String get templateStairmasterBeginner1Subtitle => '安全なペースでの階段歩行';

  @override
  String get templateStairmasterBeginner2Title => '初級ステアクライマー 2 (持続)';

  @override
  String get templateStairmasterBeginner2Subtitle => '一定テンポの有酸素階段登り';

  @override
  String get templateStairmasterIntermediate1Title => '中級ステアクライマー 1 (クライム)';

  @override
  String get templateStairmasterIntermediate1Subtitle => '2分登り / 1分回復のヒップアップ';

  @override
  String get templateStairmasterIntermediate2Title => '中級ステアクライマー 2';

  @override
  String get templateStairmasterIntermediate2Subtitle => '高速・低速テンポの交互インターバル';

  @override
  String get templateStairmasterAdvanced1Title => '上級ステアクライマー 1';

  @override
  String get templateStairmasterAdvanced1Subtitle => '高強度2分ブロックトレーニング';

  @override
  String get templateStairmasterAdvanced2Title => '上級ステアクライマー 2 (スプリント)';

  @override
  String get templateStairmasterAdvanced2Subtitle => '30秒高速登り / 60秒回復インターバル';

  @override
  String get historyTab => '記録';

  @override
  String get calendarTab => 'カレンダー';

  @override
  String get weightTab => '体重';

  @override
  String get bike => 'サイクル';

  @override
  String get thisWeek => '今週';

  @override
  String get trend => '体重推移';

  @override
  String get timeframe7D => '7日';

  @override
  String get timeframe30D => '30日';

  @override
  String get timeframe90D => '90日';

  @override
  String get timeframeAll => 'すべて';

  @override
  String get history => '記録';

  @override
  String get seeAll => 'すべて表示';

  @override
  String get weightEntryDeleted => '体重記録が削除されました';

  @override
  String get weightUpdated => '体重が更新されました';

  @override
  String get editWeight => '体重を編集';

  @override
  String get recordWeight => '体重を記録';

  @override
  String get quickAdjust => 'クイック調整';

  @override
  String get goalWeightSet => '目標体重が設定されました';

  @override
  String get goalWeightRemoved => '目標体重の設定を解除しました';

  @override
  String get goalAchieved => '目標達成！';

  @override
  String get goalMatchesCurrentWeight => '目標が現在の体重と一致します';

  @override
  String get setGoal => '目標設定';

  @override
  String get suggested => '推奨';

  @override
  String get removeGoal => '目標解除';

  @override
  String get addOneMoreRecordToSeeTrend => 'あと1件で推移が見られます';

  @override
  String get noWeightRecorded => 'まだ体重が記録されていません';

  @override
  String get startTrackingYourWeight => '体重を記録して変化を追跡';

  @override
  String get treadmillSession => 'ランニングマシンセッション';

  @override
  String get bikeSession => 'サイクルセッション';

  @override
  String get stairmasterSession => 'ステアクライマーのセッション';

  @override
  String get treadmillWorkout => 'ランニングマシン運動';

  @override
  String get bikeWorkout => 'サイクル運動';

  @override
  String get stairmasterWorkout => 'ステアクライマーのワークアウト';

  @override
  String get startAWorkoutToSeeItHere => '運動履歴はここに表示されます';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get sessions => 'セッション';

  @override
  String get distance => '距離';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get noWorkoutsYet => 'まだワークアウトがありません';

  @override
  String get startYourFirstWorkout => '最初のワークアウトを開始して、ここで履歴を確認してください';

  @override
  String get goToRoutines => 'ルーティンへ移動';

  @override
  String get weightRecorded => '体重が記録されました';

  @override
  String get workout => 'ワークアウト';

  @override
  String get workouts => 'ワークアウト';

  @override
  String get goal => '目標';

  @override
  String get toGo => '残り';

  @override
  String get over => '超過';

  @override
  String get last => '前回';

  @override
  String get newLabel => '新しい';

  @override
  String youNeed(String amount, String goal) {
    return '$goalに到達するには$amount必要です';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return '$goalに到達するには+$amount必要です';
  }

  @override
  String get current => '現在';

  @override
  String get premiumHeadline => '同じ30分、違う結果';

  @override
  String get premiumSubheadlineNew => 'ただ走るのではなく、脂肪燃焼の方法で運動する';

  @override
  String get mostPopular => '最も人気';

  @override
  String dailyPrice(int price) {
    return '1日$price円';
  }

  @override
  String get benefitVoiceCoaching => 'プレミアム音声コーチングシステム';

  @override
  String get benefitBackgroundIntervalNotifications => '他のアプリ使用中も区間変更を通知';

  @override
  String get benefitCycleStairmasterRoutines => 'すべての有酸素機器に完全対応';

  @override
  String get benefitUnlimitedRoutinesNew => '無制限ルーティンライブラリ';

  @override
  String get benefitWeightFeature => 'スマート体重追跡＆分析';

  @override
  String get benefitNoAdsFocus => '広告なしのプレミアム体験';

  @override
  String get benefitFutureFeaturesNew => '今後のプレミアム機能すべて含む';

  @override
  String get mostChosen => '一番人気';

  @override
  String get canChangeAnytime => 'いつでも変更可';

  @override
  String get startPremium => 'Premiumを始める';

  @override
  String get cancelAnytimeKeepAccess => 'いつでも解約可、期間中は利用可';

  @override
  String workoutDays(String count) {
    return 'トレーニング日数：$count日 🔥';
  }

  @override
  String restDays(String count) {
    return '休息日数：$count日 🛏️';
  }

  @override
  String get workoutReminderTitle => '通知';

  @override
  String get workoutReminderOff => 'オフ';

  @override
  String get workoutReminderEveryDay => '毎日';

  @override
  String get workoutReminderSelectTime => '時刻を選択';

  @override
  String get workoutReminderPermissionRequired => '通知権限が必要です。';

  @override
  String get workoutReminderTimeLabel => '時刻';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return 'Valcueでこのインターバルトレーニングを試してみませんか？\n\nメニュー名：$routineName\n\nリンクをコピーするか、タップして取り込んでください：\n$shareLink';
  }

  @override
  String get scanQrCode => 'QRコードスキャン';

  @override
  String get invalidQrCode => 'このQRコードはValcueのルーティンではありません。';

  @override
  String get previousMonth => '前の月';

  @override
  String get nextMonth => '次の月';

  @override
  String get placeQrInside => 'ガイド枠の中にQRコードを合わせてください。';

  @override
  String get customRoutineBuilder => 'カスタムルーティン作成';

  @override
  String get customRoutineGenerating => 'カスタムルーティンを作成しています…';

  @override
  String get customRoutineLoadingTarget => '有酸素運動の強度目標を設定中…';

  @override
  String get customRoutineLoadingStructure => 'ウォームアップとクールダウンを構成中…';

  @override
  String get customRoutineLoadingPace => 'インターバルごとのペースを計算中…';

  @override
  String get customRoutineLoadingVoice => '音声コーチングを準備中…';

  @override
  String get generationComplete => '作成完了！';

  @override
  String get regenerate => 'もう一度作成';

  @override
  String get caloriesEstimateByWeight => 'カロリーは入力した体重を基にした推定値です。';

  @override
  String get commonBack => '戻る';

  @override
  String get adjustGoals => '条件を変更';

  @override
  String get targetCalories => '目標カロリー';

  @override
  String get targetStairs => '目標階数';

  @override
  String get targetDistance => '目標距離';

  @override
  String get currentWeight => '現在の体重';

  @override
  String get includeIncline => '傾斜を含める';

  @override
  String get includeWarmupCooldown => 'ウォームアップとクールダウンを含める';

  @override
  String get generateCustomRoutine => 'カスタムルーティンを作成';

  @override
  String durationMinutes(String minutes) {
    return '$minutes分';
  }

  @override
  String floorCount(String count) {
    return '$count階';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return 'カスタムラン $distance$distanceUnit（${calories}kcal）';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return 'カスタムサイクル $distance$distanceUnit（${calories}kcal）';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return 'ビルドアップラン $distance$distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return 'ピラミッドラン $distance$distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return 'ビルドアップサイクル $distance$distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return 'ピラミッドサイクル $distance$distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return 'カスタム階段 $floors階（${calories}kcal）';
  }

  @override
  String customRoutineSpeech(String calories) {
    return 'カスタムルーティンが完成しました。約$caloriesカロリーを目標に始めましょう！';
  }

  @override
  String get weightDeleteTitle => '記録を削除';

  @override
  String get weightDeleteConfirm => 'この体重記録を削除しますか？';

  @override
  String get achievementUnlocked => '🏆 実績を解除！';

  @override
  String get achievementCongratulations => '新しいバッジを獲得しました。おめでとうございます！';

  @override
  String get awesome => 'OK';

  @override
  String get shareCardDefault => '9:14（標準）';

  @override
  String get shareCardStory => '9:16（ストーリー）';

  @override
  String get shareCardSquare => '1:1（正方形）';

  @override
  String get customizeShareCard => '共有カードをカスタマイズ';

  @override
  String get shareRoutine => 'ルーティンを共有';

  @override
  String get shareViaQrCode => 'QRコードで共有';

  @override
  String get routineLimitReached => 'ルーティン数の上限';

  @override
  String get routineLimitMessage =>
      '無料ユーザーが保存できるトレッドミルルーティンは2件までです。プレミアムにアップグレードするか、既存のルーティンを削除してください。';

  @override
  String get importSharedRoutine => '共有ルーティンを読み込む';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return 'スキャンしたQRコードからルーティンが見つかりました。\n\n• 名前：$name\n• 難易度：$difficulty\n• インターバル：$count\n\nライブラリに保存しますか？';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return 'クリップボードから共有ルーティンが見つかりました。\n\n• 名前：$name\n• 難易度：$difficulty\n• インターバル：$count\n\nライブラリに保存しますか？';
  }

  @override
  String importRoutineSuccess(String name) {
    return '「$name」を読み込みました！';
  }

  @override
  String get importAction => '読み込む';

  @override
  String get addRoutineOption => 'ルーティンの追加方法';

  @override
  String get createCustomRoutine => 'カスタムルーティンを作成';

  @override
  String get importFromClipboard => 'クリップボードから読み込む';

  @override
  String get countdownTiming => 'カウントダウン通知';

  @override
  String get noAnnouncements => '通知なし';

  @override
  String secondsShort(String seconds) {
    return '$seconds秒前';
  }

  @override
  String get selectCountdownTimings => '通知タイミングを選択';

  @override
  String get countdownTimingMessage => 'インターバルが変わる何秒前に音声案内を受けるか選択してください。';

  @override
  String secondsLeft(String seconds) {
    return '残り$seconds秒';
  }

  @override
  String get qrShareInstruction =>
      '別のValcueアプリでこのQRコードをスキャンすると\nルーティンをすぐに読み込めます。';

  @override
  String get quickStart => 'クイックスタート';

  @override
  String get sessionRepeatBlock => 'セッション繰り返しブロック';

  @override
  String repeatTimes(String count) {
    return '$count回繰り返し';
  }

  @override
  String get addRepeatBlock => '繰り返しブロックを追加';

  @override
  String get unableToShareWorkout => 'ワークアウトを共有できません。';

  @override
  String get unableToOpenPrivacyPolicy => 'プライバシーポリシーを開けません。';

  @override
  String get unableToOpenLink => 'リンクを開けません。';

  @override
  String get less => '少ない';

  @override
  String get more => '多い';

  @override
  String inclineValue(String value) {
    return '傾斜 $value%';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return '次：$value';
  }

  @override
  String get weightCalendar => '体重カレンダー';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countTextインターバル · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return '目標 $goalWeight • 達成！';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return '目標 $goalWeight • あと $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return '目標 $goalWeight • $difference超過';
  }

  @override
  String averageSpeedKmh(String value) {
    return '平均 $value km/h';
  }

  @override
  String averageSpeedMph(String value) {
    return '平均 $value mph';
  }

  @override
  String averageRpmValue(String value) {
    return '平均 $value RPM';
  }

  @override
  String averageLevelValue(String value) {
    return '平均レベル $value';
  }

  @override
  String get purchaseFailed => '購入に失敗しました。もう一度お試しください。';

  @override
  String get restoreSuccess => '購入内容を復元しました。';

  @override
  String get restoreNothingToRestore => '復元できる購入履歴が見つかりませんでした。';

  @override
  String get plansUnavailable => 'プランを読み込めませんでした。後でもう一度お試しください。';
}
