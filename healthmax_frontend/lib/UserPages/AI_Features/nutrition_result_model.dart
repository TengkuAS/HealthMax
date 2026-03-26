import 'dart:convert';

class NutritionResult {
  final List<FoodItem> foods;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double confidence;
  final String notes;

  NutritionResult({
    required this.foods,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.confidence,
    required this.notes,
  });

  factory NutritionResult.fromJson(String jsonStr) {
    final map = jsonDecode(jsonStr);

    return NutritionResult(
      foods: (map["foods"] as List)
          .map((food) => FoodItem.fromMap(food))
          .toList(),
      totalCalories: map["total_calories"],
      totalProtein: map["total_protein_g"],
      totalCarbs: map["total_carbs_g"],
      totalFat: map["total_fat_g"],
      confidence: map["confidence"],
      notes: map["notes"],
    );
  }
}

class FoodItem {
  final String name;
  final String amount;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodItem({
    required this.name,
    required this.amount,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodItem.fromMap(Map map) => FoodItem(
    name: map["name"] ?? "Unknown Food",
    amount: map["amount"] ?? "Uncertain Amount",
    calories: map["calories"] ?? 0,
    protein: (map["protein_g"] ?? 0).toDouble(),
    carbs: (map["carbs_g"] ?? 0).toDouble(),
    fat: (map["fat_g"] ?? 0.0).toDouble(),
  );
}
