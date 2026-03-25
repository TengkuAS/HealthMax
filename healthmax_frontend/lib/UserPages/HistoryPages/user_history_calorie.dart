import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../user_bottomnavbar.dart';
import '../user_glassy_profile.dart';
import 'user_history_feedback.dart'; 

class CalorieRecord {
  final String foodName;
  final int quantity;
  final String protein;
  final String carbs;
  final String fats;
  final int calories;
  final IconData placeholderIcon;
  final Color iconColor;

  CalorieRecord(this.foodName, this.quantity, this.protein, this.carbs, this.fats, this.calories, this.placeholderIcon, this.iconColor);
}

class UserHistoryCaloriePage extends StatefulWidget {
  const UserHistoryCaloriePage({super.key});

  @override
  State<UserHistoryCaloriePage> createState() => _UserHistoryCaloriePageState();
}

class _UserHistoryCaloriePageState extends State<UserHistoryCaloriePage> {
  final Color themeBlue = const Color(0xFF5A84F1);
  final Color bgOffWhite = const Color(0xFFF8F9FA);

  final List<CalorieRecord> calorieHistory = [
    CalorieRecord("Burger", 1, "25g", "40g", "15g", 375, Icons.lunch_dining, Colors.orange),
    CalorieRecord("Salad", 1, "5g", "10g", "3g", 90, Icons.eco, Colors.green),
    CalorieRecord("Nasi Kandar", 1, "35g", "80g", "25g", 720, Icons.rice_bowl, Colors.redAccent),
    CalorieRecord("Apple", 3, "1.8g", "75g", "0.9g", 145, Icons.apple, Colors.red),
    CalorieRecord("Oatmeal", 1, "10g", "45g", "5g", 250, Icons.breakfast_dining, Colors.brown),
  ];

  int get _totalCalories => calorieHistory.fold(0, (sum, item) => sum + item.calories);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgOffWhite,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ==========================================
              // --- THE ELEGANT HEADER ---
              // ==========================================
              SliverAppBar(
                backgroundColor: themeBlue,
                expandedHeight: 200.0,
                toolbarHeight: 90.0,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0.0,
                surfaceTintColor: Colors.transparent,
                actions: const [
                  Padding(padding: EdgeInsets.only(right: 30.0, top: 10.0), child: Center(child: UserGlassyProfile())),
                ],
                title: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "History.", 
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "LexendExaNormal", letterSpacing: -1.0, height: 1.1),
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SizedBox.shrink(),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60), 
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bgOffWhite, 
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10), 
                      child: Container(
                        height: 40, 
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, 
                          borderRadius: BorderRadius.circular(30), 
                        ),
                        child: Row(
                          children: [
                            _buildActiveTab("Calorie Intake"),
                            _buildInactiveTab("Feedback", context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // ==========================================
              // --- CALORIE LIST ---
              // ==========================================
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = calorieHistory[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => _showDetailSheet(item.foodName, "Detailed macronutrient breakdown for ${item.foodName}."),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 70, width: 70, 
                                    decoration: BoxDecoration(color: item.iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                    child: Icon(item.placeholderIcon, size: 35, color: item.iconColor),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.foodName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")),
                                            Text("Quantity : ${item.quantity}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(child: Text("Protein : ${item.protein}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                                            Expanded(child: Text("Carbs : ${item.carbs}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text("Fats : ${item.fats}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),
                                        Align(alignment: Alignment.centerRight, child: Text("Calories : ${item.calories} kcal", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < calorieHistory.length - 1) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.grey.shade200, thickness: 1)),
                        ],
                      );
                    },
                    childCount: calorieHistory.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Adjusted padding
            ],
          ),
          
          // ==========================================
          // --- THE SEAMLESS "FOG FADE" FOOTER ---
          // ==========================================
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 130, // Taller height for a very gradual, elegant fade
              width: double.infinity,
              // We use a pure color gradient instead of a blur to avoid sharp edges
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    bgOffWhite,                  // Solid background color at the bottom
                    bgOffWhite.withOpacity(0.8), // Starts fading
                    bgOffWhite.withOpacity(0.0), // Completely transparent at the top
                  ],
                  stops: const [0.0, 0.5, 1.0],  // Controls the smoothness of the curve
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight, 
                child: Padding(
                  padding: const EdgeInsets.only(right: 25.0, bottom: 20.0), 
                  child: Container(
                    height: 48, 
                    decoration: BoxDecoration(
                      color: themeBlue, 
                      borderRadius: BorderRadius.circular(30), 
                      boxShadow: [
                        BoxShadow(color: themeBlue.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _showCalorieBreakdownSheet,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, 
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Total: $_totalCalories kcal", 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, fontFamily: "LexendExaNormal"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 1),
    );
  }

  // --- WIDGETS & LOGIC ---
  Widget _buildActiveTab(String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(3), 
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(30), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]
        ),
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "LexendExaNormal", fontSize: 12)),
      ),
    );
  }

  Widget _buildInactiveTab(String title, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const UserHistoryFeedbackPage(), transitionDuration: Duration.zero)),
        child: Container(
          margin: const EdgeInsets.all(3),
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade500, fontFamily: "LexendExaNormal", fontSize: 12)),
        ),
      ),
    );
  }

  void _showDetailSheet(String title, String description) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (context) => _buildBottomSheetLayout(title, Text(description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14))),
    );
  }

  void _showCalorieBreakdownSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetLayout(
        "Daily Breakdown",
        Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            ...calorieHistory.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.quantity}x ${item.foodName}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("+ ${item.calories} kcal", style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Intake", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "LexendExaNormal")),
                Text("$_totalCalories kcal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: themeBlue)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetLayout(String title, Widget content) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 30), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")),
          const SizedBox(height: 20),
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: content),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: themeBlue, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "LexendExaNormal")))),
        ],
      ),
    );
  }
}