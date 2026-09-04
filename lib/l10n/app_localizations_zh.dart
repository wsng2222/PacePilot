// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get workoutDisplaySizeTitle => '训练画面大小';

  @override
  String get workoutDisplaySizeSubtitle => '放大主要训练数据和计时器。';

  @override
  String get workoutDisplaySizeStandard => '默认';

  @override
  String get workoutDisplaySizeLarge => '大';

  @override
  String get workoutDisplaySizeExtraLarge => '特大';

  @override
  String get appTitle => 'Valcue';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get system => '系统';

  @override
  String get voiceGuide => '语音指南';

  @override
  String get audioNavigator => '音频导航器';

  @override
  String get soundEffects => '音效';

  @override
  String get unitSetting => '单位';

  @override
  String get kmh => 'km/h';

  @override
  String get mph => 'mph';

  @override
  String get themeMode => '外观';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get smartwatchSync => '智能手表同步';

  @override
  String get connectSmartwatch => '连接到智能手表';

  @override
  String get connect => '连接';

  @override
  String get about => '关于';

  @override
  String get adPrivacyOptions => '广告隐私选项';

  @override
  String version(String version) {
    return '版本 $version';
  }

  @override
  String get comingSoon => '即将推出';

  @override
  String get translationComingSoon => '翻译将在未来的更新中提供。';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get done => '完成';

  @override
  String get delete => '删除';

  @override
  String get duplicate => '复制';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get start => '开始';

  @override
  String get editRoutine => '编辑训练计划';

  @override
  String get routineEdit => '编辑训练计划';

  @override
  String get name => '名称';

  @override
  String get unnamedRoutine => '未命名训练计划';

  @override
  String get difficulty => '难度';

  @override
  String difficultyColon(String difficulty) {
    return '难度 : $difficulty';
  }

  @override
  String get easy => '简单';

  @override
  String get medium => '中等';

  @override
  String get hard => '困难';

  @override
  String get interval => '间隔';

  @override
  String get addInterval => '添加间隔';

  @override
  String get quickTools => '快捷操作';

  @override
  String get addDefault => '添加默认';

  @override
  String get duplicateLast => '复制最后';

  @override
  String get repeatPattern => '重复模式';

  @override
  String get reorderIntervals => '调整顺序';

  @override
  String get reorderMode => '顺序调整模式';

  @override
  String get reorderModeHint => '长按卡片并拖到你想要的位置。';

  @override
  String get patternLength => '模式长度';

  @override
  String get repeatCount => '重复次数';

  @override
  String get noIntervals => '没有间隔';

  @override
  String get addIntervalPrompt => '添加间隔';

  @override
  String get intervalEdit => '编辑间隔';

  @override
  String get timeMinutes => '时间（分钟）';

  @override
  String get duration => '时间';

  @override
  String get speed => '速度';

  @override
  String get speedKmh => '速度（km/h）';

  @override
  String get incline => '坡度';

  @override
  String get level => '级别';

  @override
  String levelColon(String level) {
    return '级别 $level';
  }

  @override
  String get rpm => 'RPM';

  @override
  String get rpmInfoDescription => 'RPM 表示踏板在 1 分钟内转动的次数。数值越高，表示你踩踏的踏频越快。';

  @override
  String get resistance => '阻力';

  @override
  String get resistanceLevel => '阻力（级别）';

  @override
  String resistanceColon(String resistance) {
    return '阻力 $resistance';
  }

  @override
  String get spm => 'SPM';

  @override
  String get spmSteps => 'SPM（步/分钟）';

  @override
  String get saved => '已保存';

  @override
  String get deleted => '已删除';

  @override
  String get deleteRoutineTitle => '删除训练计划';

  @override
  String get deleteRoutineMessage => '确定要删除这个训练计划吗？此操作无法撤销。';

  @override
  String get deleteError => '删除时发生错误';

  @override
  String get nameRequired => '请输入名称';

  @override
  String get nameMaxLength => '名称必须为50个字符或更少';

  @override
  String get minIntervalsRequired => '至少需要一个间隔';

  @override
  String get intervalMinDuration => '间隔时间必须至少为1秒';

  @override
  String get intervalMaxDuration => '间隔时间最多为3小时（10800秒）';

  @override
  String get speedRange => '速度必须大于0（0.5-25.0 km/h）';

  @override
  String get inclineRange => '坡度必须在0-15.0范围内';

  @override
  String get rpmRange => 'RPM必须在30-200范围内';

  @override
  String get resistanceRange => '阻力必须在1-20范围内';

  @override
  String get levelRange => '级别必须在1-20范围内';

  @override
  String get spmRange => 'SPM必须在50-200范围内';

  @override
  String get noRoutinesSaved => '还没有保存训练计划';

  @override
  String get tapToCreate => '点击创建';

  @override
  String get tapButtonToCreate => '点击按钮创建';

  @override
  String get premiumRoutineSettings => 'Premium 训练计划设置';

  @override
  String get viewMembership => '查看高级版';

  @override
  String get freeLimitTitle => '免费仅 2 个训练';

  @override
  String get freeLimitMessage => '升级高级版即可不限量使用';

  @override
  String get treadmill => '跑步机';

  @override
  String get cycle => '自行车';

  @override
  String get stairmaster => '爬楼机';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get selectTheme => '选择主题';

  @override
  String get selectDifficulty => '选择难度';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get endWorkout => '结束训练';

  @override
  String get endWorkoutConfirm => '要结束训练吗？';

  @override
  String get end => '结束';

  @override
  String get share => '分享';

  @override
  String get rotate => '旋转';

  @override
  String get paused => '已暂停';

  @override
  String get pausedTitle => '已暂停';

  @override
  String get pausedSubtitle => '你可以继续或结束训练';

  @override
  String get endWorkoutConfirmationMessage => '如果现在结束，当前训练将停止并进入总结页面。';

  @override
  String get workoutComplete => '锻炼完成';

  @override
  String get backgroundIntervalNotificationTitle => '新间歇开始';

  @override
  String get backgroundIntervalNotificationsTitle => '屏幕熄灭时也接收通知';

  @override
  String get backgroundIntervalNotificationsSubtitle => '';

  @override
  String get liveActivityPreparing => '准备中';

  @override
  String get liveActivityInProgress => '锻炼中';

  @override
  String liveActivityIntervalFormat(String current, String total) {
    return '第 $current/$total 个间歇';
  }

  @override
  String liveActivityDurationFormat(String duration) {
    return '持续 $duration';
  }

  @override
  String get totalWorkoutTime => '总时间';

  @override
  String get totalDistance => '总距离';

  @override
  String get totalTime => '总时间';

  @override
  String get averageRpm => '平均RPM';

  @override
  String get averageLevel => '平均等级';

  @override
  String get holdToStop => '长按停止';

  @override
  String get continueWorkout => '继续';

  @override
  String get endWorkoutQuestion => '要结束训练吗？';

  @override
  String get workoutPaused => '训练已暂停';

  @override
  String get lvlIncline => '坡度';

  @override
  String get lvlResistance => '级别阻力';

  @override
  String get premium => '高级版';

  @override
  String get upgradeNow => '立即升级';

  @override
  String get purchase => '购买';

  @override
  String get later => '稍后';

  @override
  String get premiumActivated => '高级版已激活';

  @override
  String get premiumMembership => '高级版';

  @override
  String get benefitCycleStairmaster => '动感单车及爬楼机运动';

  @override
  String get benefitVoiceGuide => '分段语音指导引导';

  @override
  String get benefitUnlimitedRoutines => '无限保存训练计划';

  @override
  String get noAds => '无广告';

  @override
  String get benefitFutureFeatures => '包含未来增加的所有功能';

  @override
  String get voiceGuideBenefit1 => '运动中的语音教练指导';

  @override
  String get voiceGuideBenefit2 => '转换阶段时的自动提示';

  @override
  String get voiceGuideBenefit3 => '无需看屏幕，专注运动本身';

  @override
  String get routineLimitBenefit1 => '无限保存训练计划';

  @override
  String get routineLimitBenefit2 => '按不同目标保存训练计划';

  @override
  String get routineLimitBenefit3 => '跑步机/动感单车/爬楼机完美支持';

  @override
  String get premium_benefit_1 => '支持<red>动感单车和爬楼机</red>训练';

  @override
  String get premium_benefit_2 => '运动时的<red>分段语音指导</red>';

  @override
  String get premium_benefit_3 => '<red>无限</red>保存训练计划';

  @override
  String get premium_benefit_4 => '包含未来所有高级功能<red>永久免费使用</red>';

  @override
  String originalPrice(String price) {
    return '$price';
  }

  @override
  String monthlyPrice(String price) {
    return '$price/月';
  }

  @override
  String get premiumSubheadline => '解锁语音指导、单车和爬楼机训练，以及无限训练计划';

  @override
  String get monthly => '月度';

  @override
  String get yearly => '年度';

  @override
  String get lifetime => '终身';

  @override
  String get freeTrial7Days => '7天免费试用';

  @override
  String get perMonth => '/月';

  @override
  String get perYear => '/年';

  @override
  String get oneTime => '一次性支付';

  @override
  String savePercent(String percent) {
    return '节省 $percent';
  }

  @override
  String get bestValue => '最佳价值';

  @override
  String get cancelAnytime => '随时取消';

  @override
  String get autoRenewableSubscription => '自动续订';

  @override
  String get terms => '条款';

  @override
  String get privacy => '隐私';

  @override
  String get restore => '恢复';

  @override
  String get premiumTab => '高级版';

  @override
  String get routineTab => '训练计划';

  @override
  String get settingsTab => '设置';

  @override
  String get myTab => '我的';

  @override
  String get close => '关闭';

  @override
  String get premiumFeature => '高级版专属';

  @override
  String get usePremiumTest => '试用高级版';

  @override
  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$year年$month月$day日 $hour时$minute分';
  }

  @override
  String get checkRoutineStart => '预览并开始';

  @override
  String get beginner => '初级';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get viewRecommendedRoutines => '推荐 →';

  @override
  String get recommendedRoutinesTreadmill => '跑步机推荐';

  @override
  String get recommendedRoutinesCycle => '单车推荐';

  @override
  String get recommendedRoutinesStairmaster => '爬楼机推荐';

  @override
  String get alreadySaved => '已保存';

  @override
  String get routineSaved => '训练计划已保存';

  @override
  String get checkRoutine => '预览';

  @override
  String get saveRoutine => '保存训练计划';

  @override
  String get routineAlreadySaved => '这个训练计划已保存';

  @override
  String get noTemplatesFound => '未找到模板';

  @override
  String get avg => '平均';

  @override
  String get avgRpm => '平均 RPM';

  @override
  String get avgLevel => '平均等级';

  @override
  String get templateTreadmillBeginner1Title => '初级跑步机 1';

  @override
  String get templateTreadmillBeginner1Subtitle => '3分钟热身后 1:1步行与跑步';

  @override
  String get templateTreadmillBeginner2Title => '初级跑步机 2 (坡度)';

  @override
  String get templateTreadmillBeginner2Subtitle => '低关节冲击的坡度行走';

  @override
  String get templateTreadmillIntermediate1Title => '中级跑步机 1';

  @override
  String get templateTreadmillIntermediate1Subtitle => '助力脂肪燃烧的 1:1跑步极限间歇';

  @override
  String get templateTreadmillIntermediate2Title => '中级跑步机 2 (速度)';

  @override
  String get templateTreadmillIntermediate2Subtitle => '金字塔式速度提升跑';

  @override
  String get templateTreadmillAdvanced1Title => '高级跑步机 1';

  @override
  String get templateTreadmillAdvanced1Subtitle => '最大化心肺耐力的高强度间歇';

  @override
  String get templateTreadmillAdvanced2Title => '高级跑步机 2 (冲刺)';

  @override
  String get templateTreadmillAdvanced2Subtitle => '短时间高强度的冲刺重复训练';

  @override
  String get templateCycleBeginner1Title => '初级动感单车 1';

  @override
  String get templateCycleBeginner1Subtitle => '通过调整RPM的踏频入门';

  @override
  String get templateCycleBeginner2Title => '初级动感单车 2 (匀速)';

  @override
  String get templateCycleBeginner2Subtitle => '恒定阻力的耐力骑行';

  @override
  String get templateCycleIntermediate1Title => '中级动感单车 1';

  @override
  String get templateCycleIntermediate1Subtitle => '1分钟高速 / 1分钟恢复的动感骑行';

  @override
  String get templateCycleIntermediate2Title => '中级动感单车 2 (山地)';

  @override
  String get templateCycleIntermediate2Subtitle => '高阻力下肢肌肉力量训练';

  @override
  String get templateCycleAdvanced1Title => '高级动感单车 1';

  @override
  String get templateCycleAdvanced1Subtitle => '30秒高阻力爆发力间歇';

  @override
  String get templateCycleAdvanced2Title => '高级动感单车 2 (Tabata)';

  @override
  String get templateCycleAdvanced2Subtitle => '脂肪燃脂的20秒/10秒Tabata循环';

  @override
  String get templateStairmasterBeginner1Title => '初级爬楼机 1';

  @override
  String get templateStairmasterBeginner1Subtitle => '安全配速下的爬楼步法适应';

  @override
  String get templateStairmasterBeginner2Title => '初级爬楼机 2 (匀速)';

  @override
  String get templateStairmasterBeginner2Subtitle => '恒定节奏的有氧爬楼训练';

  @override
  String get templateStairmasterIntermediate1Title => '中级爬楼机 1 (登山)';

  @override
  String get templateStairmasterIntermediate1Subtitle => '2分钟登山 / 1分钟恢复以塑造臀肌';

  @override
  String get templateStairmasterIntermediate2Title => '中级爬楼机 2';

  @override
  String get templateStairmasterIntermediate2Subtitle => '快慢节奏交替的心肺间歇训练';

  @override
  String get templateStairmasterAdvanced1Title => '高级爬楼机 1';

  @override
  String get templateStairmasterAdvanced1Subtitle => '高强度的2分钟区块进阶训练';

  @override
  String get templateStairmasterAdvanced2Title => '高级爬楼机 2 (冲刺)';

  @override
  String get templateStairmasterAdvanced2Subtitle => '30秒高速爬楼 / 60秒恢复间歇';

  @override
  String get historyTab => '记录';

  @override
  String get calendarTab => '日历';

  @override
  String get weightTab => '体重';

  @override
  String get bike => '自行车';

  @override
  String get thisWeek => '本周';

  @override
  String get trend => '体重趋势';

  @override
  String get timeframe7D => '7天';

  @override
  String get timeframe30D => '30天';

  @override
  String get timeframe90D => '90天';

  @override
  String get timeframeAll => '全部';

  @override
  String get history => '记录';

  @override
  String get seeAll => '查看全部';

  @override
  String get weightEntryDeleted => '体重记录已删除';

  @override
  String get weightUpdated => '体重已更新';

  @override
  String get editWeight => '编辑体重';

  @override
  String get recordWeight => '记录体重';

  @override
  String get quickAdjust => '快速调整';

  @override
  String get goalWeightSet => '目标体重已设置';

  @override
  String get goalWeightRemoved => '目标体重已清除';

  @override
  String get goalAchieved => '目标达成！';

  @override
  String get goalMatchesCurrentWeight => '目标与当前体重一致';

  @override
  String get setGoal => '设定目标';

  @override
  String get suggested => '建议';

  @override
  String get removeGoal => '清除目标';

  @override
  String get addOneMoreRecordToSeeTrend => '再记录 1 次即可查看趋势';

  @override
  String get noWeightRecorded => '尚未记录任何体重';

  @override
  String get startTrackingYourWeight => '记录体重以追踪进度';

  @override
  String get treadmillSession => '跑步机会话';

  @override
  String get bikeSession => '自行车会话';

  @override
  String get stairmasterSession => '爬楼机会话';

  @override
  String get treadmillWorkout => '跑步机训练';

  @override
  String get bikeWorkout => '自行车训练';

  @override
  String get stairmasterWorkout => '爬楼机训练';

  @override
  String get startAWorkoutToSeeItHere => '你的训练会显示在这里';

  @override
  String get mon => '周一';

  @override
  String get tue => '周二';

  @override
  String get wed => '周三';

  @override
  String get thu => '周四';

  @override
  String get fri => '周五';

  @override
  String get sat => '周六';

  @override
  String get sun => '周日';

  @override
  String get sessions => '会话';

  @override
  String get distance => '距离';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get noWorkoutsYet => '还没有训练记录';

  @override
  String get startYourFirstWorkout => '开始第一次训练，便可在这里查看记录';

  @override
  String get goToRoutines => '前往训练计划';

  @override
  String get weightRecorded => '体重已记录';

  @override
  String get workout => '训练';

  @override
  String get workouts => '训练';

  @override
  String get goal => '目标';

  @override
  String get toGo => '剩余';

  @override
  String get over => '超过';

  @override
  String get last => '上次';

  @override
  String get newLabel => '新的';

  @override
  String youNeed(String amount, String goal) {
    return '距离$goal还差$amount';
  }

  @override
  String youNeedPlus(String amount, String goal) {
    return '距离$goal还差+$amount';
  }

  @override
  String get current => '当前';

  @override
  String get premiumHeadline => '同样的30分钟，不同的结果';

  @override
  String get premiumSubheadlineNew => '不要只是跑步，以燃脂的方式运动';

  @override
  String get mostPopular => '最受欢迎';

  @override
  String dailyPrice(int price) {
    return '每天$price元';
  }

  @override
  String get benefitVoiceCoaching => '高级语音指导系统';

  @override
  String get benefitBackgroundIntervalNotifications => '使用其他应用时也接收间歇切换提醒';

  @override
  String get benefitCycleStairmasterRoutines => '全面支持所有有氧器械';

  @override
  String get benefitUnlimitedRoutinesNew => '无限训练库';

  @override
  String get benefitWeightFeature => '智能体重追踪与分析';

  @override
  String get benefitNoAdsFocus => '无广告高级体验';

  @override
  String get benefitFutureFeaturesNew => '包含所有未来高级功能';

  @override
  String get mostChosen => '最常选';

  @override
  String get canChangeAnytime => '随时可改';

  @override
  String get startPremium => '升级高级版';

  @override
  String get cancelAnytimeKeepAccess => '随时取消，仍可用到期';

  @override
  String workoutDays(String count) {
    return '训练天数：$count 天 🔥';
  }

  @override
  String restDays(String count) {
    return '休息天数：$count 天 🛏️';
  }

  @override
  String get workoutReminderTitle => '提醒';

  @override
  String get workoutReminderOff => '关闭';

  @override
  String get workoutReminderEveryDay => '每天';

  @override
  String get workoutReminderSelectTime => '选择时间';

  @override
  String get workoutReminderPermissionRequired => '需要通知权限。';

  @override
  String get workoutReminderTimeLabel => '时间';

  @override
  String shareRoutineMessage(String routineName, String shareLink) {
    return '在 Valcue 上试试这个间歇训练计划！\n\n计划名称: $routineName\n\n复制或点击下方链接即可导入:\n$shareLink';
  }

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get invalidQrCode => '此二维码不是 Valcue 的训练方案。';

  @override
  String get previousMonth => '上个月';

  @override
  String get nextMonth => '下个月';

  @override
  String get placeQrInside => '请将二维码放入对齐框内。';

  @override
  String get customRoutineBuilder => '定制训练生成';

  @override
  String get customRoutineAccuracyNoticeTitle => '实际数值可能与目标略有不同';

  @override
  String get customRoutineAccuracyNoticeMessage =>
      '速度和踏频会四舍五入为整数,每次生成都会加入一点有意的变化,并且会保持在所选难度的安全范围内。因此实际生成的课表可能与目标相差几个百分点。';

  @override
  String get customRoutineGenerating => '正在生成定制训练…';

  @override
  String get customRoutineLoadingTarget => '正在设定有氧强度目标…';

  @override
  String get customRoutineLoadingStructure => '正在安排热身和放松阶段…';

  @override
  String get customRoutineLoadingPace => '正在计算各阶段配速…';

  @override
  String get customRoutineLoadingVoice => '正在准备语音指导…';

  @override
  String get generationComplete => '生成完成！';

  @override
  String get regenerate => '重新生成';

  @override
  String get caloriesEstimateByWeight => '卡路里为根据所填体重计算的估算值。';

  @override
  String get commonBack => '返回';

  @override
  String get adjustGoals => '修改条件';

  @override
  String get targetCalories => '目标卡路里';

  @override
  String get targetStairs => '目标楼层';

  @override
  String get targetDistance => '目标距离';

  @override
  String get currentWeight => '当前体重';

  @override
  String get includeIncline => '包含坡度';

  @override
  String get includeWarmupCooldown => '包含热身和放松';

  @override
  String get generateCustomRoutine => '生成定制训练';

  @override
  String durationMinutes(String minutes) {
    return '$minutes 分钟';
  }

  @override
  String floorCount(String count) {
    return '$count 层';
  }

  @override
  String customRunName(String distance, String distanceUnit, String calories) {
    return '定制跑步 $distance$distanceUnit（$calories千卡）';
  }

  @override
  String customCycleName(
      String distance, String distanceUnit, String calories) {
    return '定制骑行 $distance$distanceUnit（$calories千卡）';
  }

  @override
  String buildUpRunName(String distance, String distanceUnit) {
    return '递增跑 $distance$distanceUnit';
  }

  @override
  String pyramidRunName(String distance, String distanceUnit) {
    return '金字塔跑 $distance$distanceUnit';
  }

  @override
  String buildUpCycleName(String distance, String distanceUnit) {
    return '递增骑行 $distance$distanceUnit';
  }

  @override
  String pyramidCycleName(String distance, String distanceUnit) {
    return '金字塔骑行 $distance$distanceUnit';
  }

  @override
  String customStairsName(String floors, String calories) {
    return '定制爬楼 $floors层（$calories千卡）';
  }

  @override
  String customRoutineSpeech(String calories) {
    return '定制训练已准备好。开始挑战约$calories卡路里吧！';
  }

  @override
  String get weightDeleteTitle => '删除记录';

  @override
  String get weightDeleteConfirm => '确定要删除这条体重记录吗？';

  @override
  String get achievementUnlocked => '🏆 解锁成就！';

  @override
  String get achievementCongratulations => '恭喜你获得新徽章！';

  @override
  String get awesome => '太棒了！';

  @override
  String get shareCardDefault => '9:14（默认）';

  @override
  String get shareCardStory => '9:16（故事）';

  @override
  String get shareCardSquare => '1:1（正方形）';

  @override
  String get customizeShareCard => '自定义分享卡片';

  @override
  String get shareRoutine => '分享训练';

  @override
  String get shareViaQrCode => '通过二维码分享';

  @override
  String get routineLimitReached => '已达到训练上限';

  @override
  String get routineLimitMessage => '免费用户最多可保存2个跑步机训练。请升级至高级版或删除已有训练。';

  @override
  String get importSharedRoutine => '导入分享的训练';

  @override
  String importQrRoutinePrompt(String name, String difficulty, String count) {
    return '扫描的二维码中发现训练。\n\n• 名称：$name\n• 难度：$difficulty\n• 阶段数：$count\n\n要保存到训练库吗？';
  }

  @override
  String importClipboardRoutinePrompt(
      String name, String difficulty, String count) {
    return '剪贴板中发现分享的训练。\n\n• 名称：$name\n• 难度：$difficulty\n• 阶段数：$count\n\n要保存到训练库吗？';
  }

  @override
  String importRoutineSuccess(String name) {
    return '已成功导入“$name”！';
  }

  @override
  String get importAction => '导入';

  @override
  String get addRoutineOption => '选择添加训练的方式';

  @override
  String get createCustomRoutine => '创建自定义训练';

  @override
  String get importFromClipboard => '从剪贴板导入';

  @override
  String get countdownTiming => '倒计时提醒';

  @override
  String get noAnnouncements => '无提醒';

  @override
  String secondsShort(String seconds) {
    return '提前$seconds秒';
  }

  @override
  String get selectCountdownTimings => '选择倒计时提醒';

  @override
  String get countdownTimingMessage => '请选择在训练阶段切换前多久播放语音提醒。';

  @override
  String secondsLeft(String seconds) {
    return '剩余$seconds秒';
  }

  @override
  String get qrShareInstruction => '使用另一台设备上的 Valcue 扫描此二维码，\n即可立即导入该训练。';

  @override
  String get quickStart => '快速开始';

  @override
  String get sessionRepeatBlock => '训练阶段重复组';

  @override
  String repeatTimes(String count) {
    return '重复 $count 次';
  }

  @override
  String get addRepeatBlock => '添加重复组';

  @override
  String get unableToShareWorkout => '无法分享训练。';

  @override
  String get unableToOpenPrivacyPolicy => '无法打开隐私政策。';

  @override
  String get unableToOpenLink => '无法打开链接。';

  @override
  String get less => '少';

  @override
  String get more => '多';

  @override
  String inclineValue(String value) {
    return '坡度 $value%';
  }

  @override
  String rpmValue(String value) {
    return '$value RPM';
  }

  @override
  String nextMetric(String value) {
    return '下一项：$value';
  }

  @override
  String get weightCalendar => '体重日历';

  @override
  String routineHeaderSummary(
      String duration, int count, String countText, String difficulty) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$duration · $countText 个间歇 · $difficulty',
    );
    return '$_temp0';
  }

  @override
  String goalAchievedSummary(String goalWeight) {
    return '目标 $goalWeight • 已达成！';
  }

  @override
  String goalRemainingSummary(String goalWeight, String difference) {
    return '目标 $goalWeight • 还差 $difference';
  }

  @override
  String goalExceededSummary(String goalWeight, String difference) {
    return '目标 $goalWeight • 超出 $difference';
  }

  @override
  String averageSpeedKmh(String value) {
    return '平均 $value 公里/小时';
  }

  @override
  String averageSpeedMph(String value) {
    return '平均 $value 英里/小时';
  }

  @override
  String averageRpmValue(String value) {
    return '平均 $value 转/分钟';
  }

  @override
  String averageLevelValue(String value) {
    return '平均等级 $value';
  }

  @override
  String get purchaseFailed => '购买失败,请重试。';

  @override
  String get restoreSuccess => '你的购买已恢复。';

  @override
  String get restoreNothingToRestore => '未找到以前的购买记录。';

  @override
  String get plansUnavailable => '无法加载套餐,请稍后重试。';
}
