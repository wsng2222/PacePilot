import '../models/interval.dart';
import '../models/machine_type.dart';
import 'dart:math';

List<Interval> buildCustomRoutineIntervals({
  required MachineType machineType,
  required int durationMinutes,
  required double distanceTargetKm,
  required int caloriesTarget,
  required double bodyWeightKg,
  required bool includeIncline,
  bool includeWarmupCooldown = true,
  int? stairsTargetFloors,
  int variationSeed = 0,
  String difficulty = 'medium',
}) {
  final random = Random(DateTime.now().millisecondsSinceEpoch + variationSeed);
  final intervals = <Interval>[];
  final totalSeconds = durationMinutes * 60;
  
  final warmupSeconds = includeWarmupCooldown
      ? (durationMinutes <= 15 ? 90 : 180)
      : 0;
  final cooldownSeconds = includeWarmupCooldown
      ? (durationMinutes <= 15 ? 60 : 120)
      : 0;
  int remainingSeconds = totalSeconds - warmupSeconds - cooldownSeconds;
  if (remainingSeconds < 60) remainingSeconds = totalSeconds;

  if (machineType == MachineType.treadmill) {
    double maxFeasibleDist = double.parse((durationMinutes * 0.21).toStringAsFixed(1)).clamp(1.0, 15.0);
    if (distanceTargetKm > maxFeasibleDist) {
      distanceTargetKm = maxFeasibleDist;
    }

    // Warmup speed tied to difficulty (Easy=light walk, Hard=fast walk)
    double warmupSpeed = difficulty == 'easy' ? 4.0 : (difficulty == 'hard' ? 5.5 : 5.0);
    const double cooldownSpeed = 4.5;
    final double warmupCooldownDist = includeWarmupCooldown
        ? (warmupSpeed * (warmupSeconds / 3600.0) + cooldownSpeed * (cooldownSeconds / 3600.0))
        : 0.0;

    // Target speed gap between run and walk based on difficulty
    double targetSpeedGap = 4.8;
    if (difficulty == 'easy') {
      targetSpeedGap = 3.8;
    } else if (difficulty == 'hard') {
      targetSpeedGap = 6.2;
    }

    // Dynamic base block durations based on total durationMinutes & difficulty (Snapped to 30s)
    int baseWorkSec = 120;
    int baseRecSec = 90;

    if (durationMinutes <= 15) {
      baseWorkSec = difficulty == 'easy' ? 60 : (difficulty == 'hard' ? 120 : 90);
      baseRecSec = difficulty == 'easy' ? 60 : (difficulty == 'hard' ? 60 : 60);
    } else if (durationMinutes <= 25) {
      baseWorkSec = difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 180 : 120);
      baseRecSec = difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 60 : 90);
    } else if (durationMinutes <= 40) {
      baseWorkSec = difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 240 : 180);
      baseRecSec = difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 90 : 90);
    } else {
      baseWorkSec = difficulty == 'easy' ? 180 : (difficulty == 'hard' ? 300 : 240);
      baseRecSec = difficulty == 'easy' ? 150 : (difficulty == 'hard' ? 120 : 120);
    }

    // Helper: Strictly snap any duration to clean 30-second grid
    int snap30(int sec) => ((sec / 30.0).round() * 30).clamp(30, 600);

    // Determine pattern mode based on regeneration seed (0: Flat, 1: Build-up, 2: Pyramid)
    final int patternMode = variationSeed % 3;

    // Calculate total run time and total walk time in main interval block with dynamic set durations
    int totalWorkSeconds = 0;
    int totalRecoverySeconds = 0;
    final workDurations = <int>[];
    final recoveryDurations = <int>[];

    var calcSecondsLeft = remainingSeconds;
    int stepIdx = 0;

    while (calcSecondsLeft > 0) {
      // Dynamic duration variation per step snapped to clean 30s grid
      final double durationMultiplier = (patternMode != 0 && stepIdx > 0)
          ? (1.0 + ((stepIdx % 3) * 0.25))
          : 1.0;
      
      int currentWorkSec = snap30((baseWorkSec * durationMultiplier).round());
      int currentRecSec = snap30((baseRecSec * (1.0 + ((stepIdx % 2) * 0.20))).round());

      // If remaining time is smaller than 30s, absorb it cleanly
      int workDur = currentWorkSec;
      if (calcSecondsLeft < currentWorkSec) {
        workDur = snap30(calcSecondsLeft);
        if (workDur <= 0) workDur = calcSecondsLeft;
      }
      int recDur = currentRecSec;
      if (calcSecondsLeft < currentRecSec) {
        recDur = snap30(calcSecondsLeft);
        if (recDur <= 0) recDur = calcSecondsLeft;
      }

      if (!includeWarmupCooldown) {
        // Start with Rest/Walk first when warmup is disabled
        totalRecoverySeconds += recDur;
        recoveryDurations.add(recDur);
        calcSecondsLeft -= recDur;
        if (calcSecondsLeft <= 0) break;

        totalWorkSeconds += workDur;
        workDurations.add(workDur);
        calcSecondsLeft -= workDur;
      } else {
        // Start with Run first when warmup is already included
        totalWorkSeconds += workDur;
        workDurations.add(workDur);
        calcSecondsLeft -= workDur;
        if (calcSecondsLeft <= 0) break;

        totalRecoverySeconds += recDur;
        recoveryDurations.add(recDur);
        calcSecondsLeft -= recDur;
      }
      stepIdx++;
    }

    final int totalCycles = workDurations.length;
    double workHours = totalWorkSeconds / 3600.0;
    double recoveryHours = totalRecoverySeconds / 3600.0;
    double mainHours = workHours + recoveryHours;

    // Remaining distance for the main run portion
    double targetMainDist = distanceTargetKm - warmupCooldownDist;
    if (targetMainDist < 0.2) targetMainDist = 0.2;

    // Dynamically balance workSpeed and restSpeed so that:
    // MainDist = workSpeed * workHours + (workSpeed - targetSpeedGap) * recoveryHours
    // => MainDist = workSpeed * mainHours - targetSpeedGap * recoveryHours
    double baseWorkSpeed = 8.0;
    double restSpeed = 5.0;

    if (mainHours > 0) {
      baseWorkSpeed = (targetMainDist + targetSpeedGap * recoveryHours) / mainHours;
      restSpeed = baseWorkSpeed - targetSpeedGap;

      // Rest speed bounds check (4.0 ~ 7.0 km/h)
      if (restSpeed < 4.0) {
        restSpeed = 4.0;
        baseWorkSpeed = workHours > 0 ? (targetMainDist - restSpeed * recoveryHours) / workHours : 8.0;
      } else if (restSpeed > 7.0) {
        restSpeed = 7.0;
        baseWorkSpeed = workHours > 0 ? (targetMainDist - restSpeed * recoveryHours) / workHours : 10.0;
      }
    }

    // Seed variation — always has micro-variation, larger when reseeded
    // Distance-neutral: compensate workSpeed so total distance stays accurate
    double restSeedVar = (random.nextDouble() - 0.5) * (variationSeed > 0 ? 0.4 : 0.1);
    double newRestSpd = (restSpeed + restSeedVar).clamp(4.0, 7.0);
    double restDelta = newRestSpd - restSpeed;
    restSpeed = newRestSpd;
    if (workHours > 0 && recoveryHours > 0) {
      baseWorkSpeed = baseWorkSpeed - (restDelta * recoveryHours) / workHours;
    }

    double workGrade = 0.0;
    double restGrade = 0.0;
    double warmupGrade = includeIncline ? 0.5 : 0.0;

    // Safety & max speed handling with Incline Cardio Load Trade-off
    if (baseWorkSpeed > 15.0) {
      double speedDiff = baseWorkSpeed - 15.0;
      baseWorkSpeed = 15.0;
      if (includeIncline) {
        workGrade = (speedDiff * 1.5).clamp(1.0, 10.0);
      }
    } else if (includeIncline) {
      workGrade = difficulty == 'easy' ? 1.0 : (difficulty == 'hard' ? 3.0 : 2.0);
      restGrade = 0.5;
      
      // Incline Cardio Load Adjustment: slightly tune base speed to prevent over-fatigue
      double inclineSpeedAdjustment = (workGrade * 0.15).clamp(0.15, 0.45);
      baseWorkSpeed = (baseWorkSpeed - inclineSpeedAdjustment).clamp(5.5, 15.0);
    }

    // Apply difficulty-based realistic gym speed bounds
    double maxSpeedByDiff = difficulty == 'easy' ? 9.5 : (difficulty == 'hard' ? 13.5 : 11.2);
    double minSpeedByDiff = difficulty == 'easy' ? 6.5 : (difficulty == 'hard' ? 9.5 : 8.0);
    baseWorkSpeed = baseWorkSpeed.clamp(minSpeedByDiff, maxSpeedByDiff);

    // Calculate pattern speed factors per set
    final setSpeedFactors = List<double>.filled(totalCycles, 1.0);
    if (totalCycles > 1) {
      if (patternMode == 1) {
        // Build-up / Ladder pattern: Speed increases gradually
        for (int i = 0; i < totalCycles; i++) {
          setSpeedFactors[i] = 0.88 + (i / (totalCycles - 1)) * 0.24;
        }
      } else if (patternMode == 2) {
        // Pyramid pattern: Speed peaks at the middle set
        final mid = (totalCycles - 1) / 2.0;
        for (int i = 0; i < totalCycles; i++) {
          final distFromMid = (i - mid).abs();
          final normDist = mid > 0 ? (1.0 - (distFromMid / mid)) : 1.0;
          setSpeedFactors[i] = 0.88 + normDist * 0.24;
        }
      }
    }

    // Adjust scale factor to ensure total distance exact match
    double requiredRunDistance = targetMainDist - (restSpeed * recoveryHours);
    double weightedRunHoursSum = 0.0;
    for (int i = 0; i < totalCycles; i++) {
      weightedRunHoursSum += (workDurations[i] / 3600.0) * setSpeedFactors[i];
    }
    double scaleFactor = 1.0;
    if (weightedRunHoursSum > 0 && requiredRunDistance > 0 && patternMode != 0) {
      scaleFactor = requiredRunDistance / (baseWorkSpeed * weightedRunHoursSum);
    }

    if (includeWarmupCooldown) {
      intervals.add(Interval.treadmill(
        durationSeconds: warmupSeconds,
        speedKmh: double.parse(warmupSpeed.toStringAsFixed(1)),
        grade: warmupGrade,
      ));
    }

    final groupId = 'ai_group_${random.nextInt(10000)}';
    var mainSecondsLeft = remainingSeconds;
    int cycleIndex = 0;

    while (mainSecondsLeft > 0) {
      final workDuration = cycleIndex < workDurations.length
          ? workDurations[cycleIndex]
          : (mainSecondsLeft >= baseWorkSec ? baseWorkSec : mainSecondsLeft);
      final recoveryDuration = cycleIndex < recoveryDurations.length
          ? recoveryDurations[cycleIndex]
          : (mainSecondsLeft >= baseRecSec ? baseRecSec : mainSecondsLeft);

      double speedFactor = cycleIndex < setSpeedFactors.length
          ? setSpeedFactors[cycleIndex]
          : 1.0;
      double rawWorkSpeed = (baseWorkSpeed * scaleFactor * speedFactor).clamp(5.5, 15.0);
      double currentWorkSpeed = (rawWorkSpeed * 10.0).round() / 10.0;
      double currentRestSpeed = (restSpeed * 10.0).round() / 10.0;
      double snappedWorkGrade = (workGrade * 2.0).round() / 2.0;
      double snappedRestGrade = (restGrade * 2.0).round() / 2.0;

      if (!includeWarmupCooldown) {
        // Add Rest/Walk first when warmup is disabled
        intervals.add(Interval.treadmill(
          durationSeconds: recoveryDuration,
          speedKmh: currentRestSpeed,
          grade: snappedRestGrade,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
        if (mainSecondsLeft <= 0) break;

        intervals.add(Interval.treadmill(
          durationSeconds: workDuration,
          speedKmh: currentWorkSpeed,
          grade: snappedWorkGrade,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= workDuration;
      } else {
        // Add Run first when warmup is already included
        intervals.add(Interval.treadmill(
          durationSeconds: workDuration,
          speedKmh: currentWorkSpeed,
          grade: snappedWorkGrade,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= workDuration;
        if (mainSecondsLeft <= 0) break;

        intervals.add(Interval.treadmill(
          durationSeconds: recoveryDuration,
          speedKmh: currentRestSpeed,
          grade: snappedRestGrade,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
      }

      cycleIndex++;
    }

    if (includeWarmupCooldown) {
      intervals.add(Interval.treadmill(
        durationSeconds: cooldownSeconds,
        speedKmh: double.parse(cooldownSpeed.toStringAsFixed(1)),
        grade: 0.0,
      ));
    }
  } else if (machineType == MachineType.cycle) {
    // Evidence-based indoor cycling resistance (AFAA/ACE spinning protocol)
    // Rest:  3~5  (comfortable recovery spin)
    // Easy:  7~9  (aerobic, slight breathlessness)
    // Med:   10~13 (threshold, can't hold conversation)
    // Hard:  14~18 (HIIT explosive sprint)
    double baseWorkRes = difficulty == 'easy' ? 8.0 : (difficulty == 'hard' ? 15.0 : 11.0);
    double baseRestRes = 4.0; // always clearly easy regardless of difficulty

    // RPM derived from target distance: higher distance goal = faster cadence
    // Indoor cycle virtual distance ~ rpm * 0.035 km/min
    double targetKmPerMin = distanceTargetKm / durationMinutes;
    double baseWorkRpm = (targetKmPerMin / 0.035).clamp(
      difficulty == 'easy' ? 60.0 : (difficulty == 'hard' ? 75.0 : 65.0),
      difficulty == 'easy' ? 85.0 : (difficulty == 'hard' ? 110.0 : 100.0),
    );
    double baseRestRpm = (baseWorkRpm * 0.70).clamp(45.0, 80.0);

    // Scale only work resistance by body weight (heavier user → slightly lower resistance)
    double weightFactor = (bodyWeightKg / 70.0).clamp(0.85, 1.15);
    baseWorkRes = (baseWorkRes / weightFactor).clamp(4.0, 20.0);

    // Pattern mode per set (build-up or pyramid)
    final int patternModeCycle = variationSeed % 3;

    if (includeWarmupCooldown) {
      intervals.add(Interval.cycle(
        durationSeconds: warmupSeconds > 0 ? warmupSeconds : 180,
        rpm: (baseRestRpm - 2).clamp(45, 80).toInt(),
        resistance: (baseRestRes - 1).clamp(1, 8).toInt(),
      ));
    }

    // Dynamic block durations based on total workout length (like Treadmill)
    final workBlockDuration = durationMinutes <= 15
        ? (difficulty == 'easy' ? 60 : (difficulty == 'hard' ? 120 : 90))
        : durationMinutes <= 25
            ? (difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 180 : 120))
            : (difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 240 : 180));
    final recoveryBlockDuration = durationMinutes <= 15
        ? (difficulty == 'easy' ? 60 : (difficulty == 'hard' ? 90 : 75))
        : durationMinutes <= 25
            ? (difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 90 : 90))
            : (difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 90 : 120));
    final groupId = 'ai_group_${random.nextInt(10000)}';

    var mainSecondsLeft = remainingSeconds;
    int cycleStep = 0;

    // Pre-compute per-set work resistance sequence for true interval training
    // Work resistance steps: meaningful jumps per set based on difficulty & pattern
    final int maxSets = (remainingSeconds / (workBlockDuration + recoveryBlockDuration)).ceil() + 2;

    List<int> workResSequence = [];
    if (patternModeCycle == 1) {
      // Build-up: linearly interpolate from base to (base+6) — no explosive jump
      double buildMax = (baseWorkRes + 6.0).clamp(baseWorkRes, 20.0);
      for (int i = 0; i < maxSets; i++) {
        double t = maxSets > 1 ? (i / (maxSets - 1).toDouble()) : 0.0;
        int res = (baseWorkRes + t * (buildMax - baseWorkRes)).round().clamp(2, 20);
        workResSequence.add(res);
      }
    } else if (patternModeCycle == 2) {
      // Pyramid: rises to peak then falls
      for (int i = 0; i < maxSets; i++) {
        double peak = maxSets / 2.0;
        double distFromPeak = (i - peak).abs();
        double normDist = peak > 0 ? (1.0 - distFromPeak / peak) : 1.0;
        int res = (baseWorkRes + normDist * 6.0).round().clamp(2, 20);
        workResSequence.add(res);
      }
    } else {
      // Flat: alternates between two distinct resistance levels
      for (int i = 0; i < maxSets; i++) {
        int res = (i % 2 == 0)
            ? baseWorkRes.round().clamp(2, 20)
            : (baseWorkRes + 3).round().clamp(2, 20);
        workResSequence.add(res);
      }
    }

    while (mainSecondsLeft > 0) {
      final workDuration = mainSecondsLeft >= workBlockDuration
          ? workBlockDuration
          : mainSecondsLeft;
      final recoveryDuration = mainSecondsLeft >= recoveryBlockDuration
          ? recoveryBlockDuration
          : mainSecondsLeft;

      // Always a slight RPM micro-variation; larger when regenerating
      int rpmOffset = (random.nextInt(5) - 2) + (variationSeed > 0 ? (random.nextInt(7) - 3) : 0);
      int currentWorkRes = cycleStep < workResSequence.length
          ? workResSequence[cycleStep]
          : workResSequence.last;
      int currentRestRes = baseRestRes.round().clamp(1, 5); // fixed low for clear contrast
      int currentWorkRpm = (baseWorkRpm + rpmOffset).clamp(60.0, 115.0).toInt();
      int currentRestRpm = (baseRestRpm + rpmOffset ~/ 2).clamp(45.0, 90.0).toInt();

      if (!includeWarmupCooldown) {
        intervals.add(Interval.cycle(
          durationSeconds: recoveryDuration,
          rpm: currentRestRpm,
          resistance: currentRestRes,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
        if (mainSecondsLeft <= 0) break;

        // Recalculate workDuration with updated remaining time
        final actualWorkDuration = mainSecondsLeft >= workBlockDuration
            ? workBlockDuration
            : mainSecondsLeft;
        intervals.add(Interval.cycle(
          durationSeconds: actualWorkDuration,
          rpm: currentWorkRpm,
          resistance: currentWorkRes,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= actualWorkDuration;
      } else {
        intervals.add(Interval.cycle(
          durationSeconds: workDuration,
          rpm: currentWorkRpm,
          resistance: currentWorkRes,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= workDuration;
        if (mainSecondsLeft <= 0) break;

        intervals.add(Interval.cycle(
          durationSeconds: recoveryDuration,
          rpm: currentRestRpm,
          resistance: currentRestRes,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
      }
      cycleStep++;
    }

    if (includeWarmupCooldown) {
      intervals.add(Interval.cycle(
        durationSeconds: cooldownSeconds > 0 ? cooldownSeconds : 120,
        rpm: (baseRestRpm - 10).clamp(40, 70).toInt(),
        resistance: (baseRestRes - 1).clamp(1, 6).toInt(),
      ));
    }
  } else {
    final floorsGoal = stairsTargetFloors ?? 50;
    double floorsPerMin = 0.0;
    if (durationMinutes > 0) {
      floorsPerMin = floorsGoal / durationMinutes;
    }
    double stepsPerMin = floorsPerMin * 16.0;
    // Raw level from target floors, wider range
    double baseLevelRaw = (stepsPerMin / 5.0).clamp(3.0, 16.0);
    // Apply difficulty offset so Easy/Hard actually produce different levels
    double difficultyOffset = difficulty == 'easy' ? -1.5 : (difficulty == 'hard' ? 2.0 : 0.0);
    double baseLevel = (baseLevelRaw + difficultyOffset).clamp(2.0, 16.0);

    // Difficulty-aware clamp ranges for work/rest levels
    double workMin = difficulty == 'easy' ? 4.0 : (difficulty == 'hard' ? 8.0 : 6.0);
    double workMax = difficulty == 'easy' ? 12.0 : (difficulty == 'hard' ? 20.0 : 16.0);
    double restMin = difficulty == 'easy' ? 2.0 : (difficulty == 'hard' ? 3.0 : 2.0);
    double restMax = difficulty == 'easy' ? 7.0 : (difficulty == 'hard' ? 11.0 : 9.0);

    int workLevel = (baseLevel + 3.0).clamp(workMin, workMax).round();
    int restLevel = (baseLevel - 2.0).clamp(restMin, restMax).round();
    // Ensure minimum 3-level gap between work and rest
    if (workLevel - restLevel < 3) {
      workLevel = restLevel + 3;
    }

    if (includeWarmupCooldown) {
      intervals.add(Interval.stairmaster(
        durationSeconds: warmupSeconds > 0 ? warmupSeconds : 180,
        level: (baseLevel - 2.0).clamp(2.0, 10.0).round(),
      ));
    }

    // Dynamic block durations based on total workout length
    final workBlockDuration = durationMinutes <= 15
        ? (difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 150 : 120))
        : durationMinutes <= 30
            ? (difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 240 : 180))
            : (difficulty == 'easy' ? 180 : (difficulty == 'hard' ? 300 : 240));
    final recoveryBlockDuration = durationMinutes <= 15
        ? (difficulty == 'easy' ? 60 : (difficulty == 'hard' ? 75 : 60))
        : durationMinutes <= 30
            ? (difficulty == 'easy' ? 90 : (difficulty == 'hard' ? 90 : 90))
            : (difficulty == 'easy' ? 120 : (difficulty == 'hard' ? 90 : 120));
    final groupId = 'ai_group_${random.nextInt(10000)}';

    var mainSecondsLeft = remainingSeconds;
    int stepCount = 0;

    while (mainSecondsLeft > 0) {
      int workDuration = mainSecondsLeft >= workBlockDuration
          ? workBlockDuration
          : mainSecondsLeft;
      int recoveryDuration = mainSecondsLeft >= recoveryBlockDuration
          ? recoveryBlockDuration
          : mainSecondsLeft;

      int levelOffset = (variationSeed > 0) ? ((stepCount % 3) - 1) : 0;
      int currentWorkLevel = (workLevel + levelOffset).clamp(6, 20);

      if (!includeWarmupCooldown) {
        // Add Rest/Easy level first when warmup is disabled
        intervals.add(Interval.stairmaster(
          durationSeconds: recoveryDuration,
          level: restLevel,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
        if (mainSecondsLeft <= 0) break;

        // Recalculate workDuration with updated remaining time
        workDuration = mainSecondsLeft >= workBlockDuration
            ? workBlockDuration
            : mainSecondsLeft;
        intervals.add(Interval.stairmaster(
          durationSeconds: workDuration,
          level: currentWorkLevel,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= workDuration;
      } else {
        intervals.add(Interval.stairmaster(
          durationSeconds: workDuration,
          level: currentWorkLevel,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= workDuration;
        if (mainSecondsLeft <= 0) break;

        intervals.add(Interval.stairmaster(
          durationSeconds: recoveryDuration,
          level: restLevel,
          groupId: groupId,
          repeatCount: 1,
        ));
        mainSecondsLeft -= recoveryDuration;
      }
      stepCount++;
    }

    if (includeWarmupCooldown) {
      intervals.add(Interval.stairmaster(
        durationSeconds: cooldownSeconds > 0 ? cooldownSeconds : 120,
        // Cooldown = restLevel - 1 (already a low level; go just one step below)
        level: (restLevel - 1).clamp(1, restLevel),
      ));
    }
  }

  return intervals;
}
