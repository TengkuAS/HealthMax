import 'package:flutter/material.dart';

class MainGoal {
  String title;
  String targetValue;
  double aiProgress;
  String aiInsightText;

  MainGoal({
    required this.title,
    required this.targetValue,
    required this.aiProgress,
    required this.aiInsightText,
  });
}

class TargetItem {
  String title;
  String description;
  double progress;
  int currentValue;
  int targetValue;
  String unit;
  int rewardPoints;
  bool isCompleted;

  TargetItem({
    required this.title,
    required this.description,
    required this.progress,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.rewardPoints,
    required this.isCompleted,
  });
}

class RankingUser {
  final int rank;
  final String name;
  final int score;
  final bool isCurrentUser;

  RankingUser(this.rank, this.name, this.score, this.isCurrentUser);
}

class GoalProvider extends ChangeNotifier {
  bool isLoading = false;
  int userScore = 1250;

  // By default, set to "N/A" so the Target Page knows it was skipped.
  MainGoal mainGoal = MainGoal(
    title: "N/A",
    targetValue: "N/A",
    aiProgress: 0.0,
    aiInsightText: "Set a main health goal to let AI personalize your experience.",
  );

  List<TargetItem> targets = [];

  List<RankingUser> topRankings = [
    RankingUser(1, "Alex", 3400, false),
    RankingUser(2, "Sarah", 2900, false),
    RankingUser(3, "John", 2100, false),
  ];
  
  RankingUser currentUserRank = RankingUser(42, "You", 1250, true);

  // This is called from the registration page!
  void updateMainGoal(String title, String targetValue) {
    mainGoal.title = title;
    mainGoal.targetValue = targetValue;
    mainGoal.aiProgress = 0.0;
    
    // If the user skipped registration, handle it gracefully
    if (title == "N/A" || title.isEmpty) {
      mainGoal.title = "N/A";
      mainGoal.aiInsightText = "Set a main health goal to let AI personalize your experience.";
      targets = []; // Clear sub-targets
    } else {
      mainGoal.aiInsightText = "AI is gathering data to track your $title progress over time.";
      _generateSubTargets(title); // Auto-create daily goals based on their choice!
    }
    notifyListeners();
  }

  // Automatically generates fun daily goals based on what AI detected during registration
  void _generateSubTargets(String goalTitle) {
    if (goalTitle == "Lose Weight") {
      targets = [
        TargetItem(title: "Calorie Deficit", description: "Stay under your daily calorie limit.", progress: 0.7, currentValue: 1400, targetValue: 2000, unit: "kcal", rewardPoints: 50, isCompleted: false),
        TargetItem(title: "Cardio", description: "Complete a 30 min cardio session.", progress: 1.0, currentValue: 30, targetValue: 30, unit: "min", rewardPoints: 100, isCompleted: true),
      ];
    } else if (goalTitle == "More Steps") {
      targets = [
        TargetItem(title: "Daily Steps", description: "Walk 10,000 steps today.", progress: 0.5, currentValue: 5000, targetValue: 10000, unit: "steps", rewardPoints: 100, isCompleted: false),
        TargetItem(title: "Active Minutes", description: "Stay active for at least 45 minutes.", progress: 0.8, currentValue: 36, targetValue: 45, unit: "min", rewardPoints: 50, isCompleted: false),
      ];
    } else if (goalTitle == "Build Muscle") {
      targets = [
        TargetItem(title: "Protein Intake", description: "Hit your daily protein goal.", progress: 0.8, currentValue: 120, targetValue: 150, unit: "g", rewardPoints: 75, isCompleted: false),
        TargetItem(title: "Strength Training", description: "Complete weight lifting session.", progress: 0.0, currentValue: 0, targetValue: 1, unit: "session", rewardPoints: 150, isCompleted: false),
      ];
    } else if (goalTitle == "Less Sugar") {
      targets = [
        TargetItem(title: "Sugar Limit", description: "Keep added sugar under 30g.", progress: 0.3, currentValue: 10, targetValue: 30, unit: "g", rewardPoints: 50, isCompleted: false),
        TargetItem(title: "Hydration", description: "Drink 8 glasses of water.", progress: 1.0, currentValue: 8, targetValue: 8, unit: "glasses", rewardPoints: 20, isCompleted: true),
      ];
    } else {
      targets = [];
    }
  }
}