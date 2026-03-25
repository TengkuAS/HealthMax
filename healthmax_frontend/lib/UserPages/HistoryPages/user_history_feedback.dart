import 'package:flutter/material.dart';
import '../user_bottomnavbar.dart';
import '../user_glassy_profile.dart';
import 'user_history_calorie.dart'; 

class FeedbackRecord {
  final String hospitalName;
  final String date;
  final String time;
  final String message;
  final String feedbackType;
  final Color typeColor;

  FeedbackRecord(this.hospitalName, this.date, this.time, this.message, this.feedbackType, this.typeColor);
}

class UserHistoryFeedbackPage extends StatefulWidget {
  const UserHistoryFeedbackPage({super.key});

  @override
  State<UserHistoryFeedbackPage> createState() => _UserHistoryFeedbackPageState();
}

class _UserHistoryFeedbackPageState extends State<UserHistoryFeedbackPage> {
  final Color themeBlue = const Color(0xFF5A84F1);
  final Color bgOffWhite = const Color(0xFFF8F9FA);

  final List<FeedbackRecord> feedbackHistory = [
    FeedbackRecord("Hospital 1", "17 December 2025", "10:00 am", "Your heart rate today is a bit above normal, try to relax for a while.", "Heart Rate", Colors.redAccent),
    FeedbackRecord("Hospital 2", "3 December 2025", "10:30 am", "Great job! You've hit a healthy number of steps today.", "Steps", Colors.orange),
    FeedbackRecord("Hospital 3", "17 December 2025", "10:00 am", "Your glucose level is slightly high, remember to stay hydrated.", "Glucose Level", Colors.blueAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgOffWhite,
      body: CustomScrollView(
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
            // --- THE FIXED, SLIMMER PILL CONTAINER ---
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
                        _buildInactiveTab("Calorie Intake", context),
                        _buildActiveTab("Feedback"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // ==========================================
          // --- FEEDBACK LIST ---
          // ==========================================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final feedback = feedbackHistory[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _showDetailSheet(feedback.feedbackType, feedback.message),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(backgroundColor: Colors.black87, radius: 22, child: Icon(Icons.local_hospital, color: Colors.white, size: 20)),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(feedback.hospitalName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        Text("${feedback.date}   ${feedback.time}", style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text('"${feedback.message}"', style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text("Feedback on ", style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                                        Text(feedback.feedbackType, style: TextStyle(fontSize: 10, color: feedback.typeColor, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index < feedbackHistory.length - 1) const SizedBox(height: 15), // Uses space instead of dividers for cards
                    ],
                  );
                },
                childCount: feedbackHistory.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]),
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "LexendExaNormal", fontSize: 12)),
      ),
    );
  }

  Widget _buildInactiveTab(String title, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const UserHistoryCaloriePage(), transitionDuration: Duration.zero)),
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
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 30), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")),
              const SizedBox(height: 20),
              Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Text(description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14))),
              const SizedBox(height: 30),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: themeBlue, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "LexendExaNormal")))),
            ],
          ),
        );
      },
    );
  }
}