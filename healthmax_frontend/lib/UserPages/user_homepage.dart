import 'package:flutter/material.dart';
import 'user_bottomnavbar.dart'; 
import 'user_glassy_profile.dart'; 

// ==========================================
// 1. MOCK DATA MODEL (PLACEHOLDER FOR SQL DB)
// ==========================================
class UserHealthData {
  final String username;
  final int heartRate;
  final String heartRateStatus;
  final int bloodGlucose;
  final String bloodGlucoseStatus;
  final int envNoise;
  final String envNoiseStatus;
  final int currentSteps;
  final int targetSteps;
  final int caloriesToBurn;
  final String lastUpdated;

  UserHealthData({
    required this.username,
    required this.heartRate,
    required this.heartRateStatus,
    required this.bloodGlucose,
    required this.bloodGlucoseStatus,
    required this.envNoise,
    required this.envNoiseStatus,
    required this.currentSteps,
    required this.targetSteps,
    required this.caloriesToBurn,
    required this.lastUpdated,
  });
}

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final Color themeBlue = const Color(0xFF5A84F1);
  final Color bgOffWhite = const Color(0xFFF8F9FA);

  // ==========================================
  // 2. INITIALIZE MOCK DATA
  // Replace this later with your HealthMaxDB fetch logic
  // ==========================================
  late UserHealthData myData;

  @override
  void initState() {
    super.initState();
    myData = UserHealthData(
      username: "Adam",
      heartRate: 90,
      heartRateStatus: "Normal",
      bloodGlucose: 90,
      bloodGlucoseStatus: "Normal",
      envNoise: 65,
      envNoiseStatus: "Normal",
      currentSteps: 6789,
      targetSteps: 10000,
      caloriesToBurn: 1234,
      lastUpdated: "1 minute ago",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgOffWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ==========================================
          // 3. COLLAPSING SLIVER APP BAR
          // ==========================================
          SliverAppBar(
            backgroundColor: themeBlue,
            expandedHeight: 220.0,
            toolbarHeight: 90.0, 
            pinned: true, 
            
            // --- THE MAGIC FIX FOR THE FAINT LINE ---
            elevation: 0,
            scrolledUnderElevation: 0.0,         // Turns off the scroll shadow
            surfaceTintColor: Colors.transparent, // Turns off the scroll color tint
            
            // The Profile Button stays pinned at the top right
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 30.0, top: 10.0),
                child: Center(child: UserGlassyProfile()),
              ),
            ],
            
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax, 
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hi,",
                            style: TextStyle(
                              fontSize: 45, 
                              fontWeight: FontWeight.w900, 
                              color: Colors.white, 
                              height: 1.1, 
                              fontFamily: "LexendExaNormal"
                            ),
                          ),
                          Text(
                            "${myData.username}!", // Using Mock Data
                            style: const TextStyle(
                              fontSize: 35, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.white, 
                              fontFamily: "LexendExaNormal"
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // The curved white container pulled down by 1px to hide the gap
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Transform.translate(
                offset: const Offset(0, 1), 
                child: Container(
                  height: 31, 
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgOffWhite, 
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ==========================================
          // 4. SCROLLABLE BODY CONTENT
          // ==========================================
          SliverToBoxAdapter(
            child: Container(
              color: bgOffWhite, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- MAIN DATA CARD ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06), 
                            blurRadius: 20, 
                            offset: const Offset(0, 8)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left Column: Metrics
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMetric(
                                    icon: Icons.monitor_heart,
                                    color: const Color(0xFFFF6B6B),
                                    value: myData.heartRate.toString(),
                                    unit: "bpm",
                                    status: myData.heartRateStatus,
                                    title: "Heart Rate",
                                    description: "Your heart rate is currently stable and within the normal resting range. Consistency is looking great.",
                                  ),
                                  const SizedBox(height: 15),
                                  _buildMetric(
                                    icon: Icons.bloodtype,
                                    color: const Color(0xFF4ECDC4),
                                    value: myData.bloodGlucose.toString(),
                                    unit: "mg / dL",
                                    status: myData.bloodGlucoseStatus,
                                    title: "Blood Glucose",
                                    description: "Blood glucose levels are optimal, indicating a healthy metabolic response.",
                                  ),
                                  const SizedBox(height: 15),
                                  _buildMetric(
                                    icon: Icons.hearing,
                                    color: const Color(0xFF45B7D1),
                                    value: myData.envNoise.toString(),
                                    unit: "dB",
                                    status: myData.envNoiseStatus,
                                    title: "Env. Noise",
                                    description: "Environmental noise exposure is within safe limits.",
                                  ),
                                ],
                              ),
                              
                              // Right Column: Steps Progress
                              SizedBox(
                                width: 140,
                                height: 140,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CircularProgressIndicator(
                                      value: 1.0, 
                                      strokeWidth: 10, 
                                      color: Colors.grey.shade100
                                    ),
                                    TweenAnimationBuilder(
                                      tween: Tween<double>(
                                        begin: 0, 
                                        end: (myData.currentSteps / myData.targetSteps).clamp(0.0, 1.0)
                                      ), 
                                      duration: const Duration(seconds: 2),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, value, child) {
                                        return CircularProgressIndicator(
                                          value: value,
                                          strokeWidth: 10,
                                          backgroundColor: Colors.transparent,
                                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9F43)),
                                          strokeCap: StrokeCap.round,
                                        );
                                      },
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        Text(
                                          myData.currentSteps.toString(),
                                          style: const TextStyle(
                                            fontSize: 32, 
                                            fontWeight: FontWeight.w900, 
                                            fontFamily: "LexendExaNormal", 
                                            letterSpacing: -1
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(color: Colors.black12, height: 1),
                          ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Last Updated : ${myData.lastUpdated}", 
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.sync, size: 16, color: Colors.grey.shade500),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // --- QUICK ACTION SECTION ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Quick Action", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildQuickActionCard(
                          icon: Icons.local_fire_department_rounded,
                          iconBgColor: const Color(0xFFFFD93D),
                          title: "Burn Calories",
                          subtitle: "${myData.caloriesToBurn} Calories left to burn",
                          isProgress: true,
                        ),
                        const SizedBox(width: 15),
                        _buildQuickActionCard(
                          icon: Icons.calendar_month_rounded,
                          iconBgColor: const Color(0xFF00D1FF),
                          title: "17 December 2026",
                          subtitle: "Heart Appointment\nHospital 1",
                          isAppointment: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // --- FEEDBACK SECTION ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Feedback", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildFeedbackCard(
                          "Dr. Ahmad Syafiq", 
                          "Heart Rate consistency is looking excellent this week. Keep up the light cardio.", 
                          "10:30 AM"
                        ),
                        _buildFeedbackCard(
                          "Nutritionist Sarah", 
                          "Your glucose levels have stabilized perfectly after we adjusted your dinner macros.", 
                          "Yesterday"
                        ),
                        const SizedBox(height: 40), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 0),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildMetric({
    required IconData icon, 
    required Color color, 
    required String value, 
    required String unit, 
    required String status,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () => _showDataDetails(title, value, unit, status, color, description),
      child: Container(
        color: Colors.transparent, 
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")),
                    const SizedBox(width: 4),
                    Text(unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.4), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon, 
    required Color iconBgColor, 
    required String title, 
    required String subtitle, 
    bool isProgress = false,
    bool isAppointment = false,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: Colors.black87, size: 35),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.2)),
                if (isProgress) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD93D)),
                    borderRadius: BorderRadius.circular(5),
                    minHeight: 5,
                  ),
                ],
                if (isAppointment) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text("Cancel", style: TextStyle(fontSize: 10, color: Colors.red.shade400, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 15),
                      const Text("Reschedule", style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold)),
                    ],
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(String doctor, String message, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: themeBlue.withOpacity(0.1), 
            child: Icon(Icons.medical_services_rounded, color: themeBlue, size: 20)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(message, style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDataDetails(String title, String value, String unit, String status, Color color, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.vertical(top: Radius.circular(35))
          ),
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50, 
                height: 5, 
                margin: const EdgeInsets.only(bottom: 30), 
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))
              ),
              Container(
                padding: const EdgeInsets.all(20), 
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), 
                child: Icon(Icons.insights_rounded, color: color, size: 50)
              ),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "LexendExaNormal")),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900, color: color)),
                  const SizedBox(width: 8),
                  Text(unit, style: const TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, 
                  borderRadius: BorderRadius.circular(20), 
                  border: Border.all(color: Colors.grey.shade200)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics_outlined, color: Colors.black54, size: 20),
                        const SizedBox(width: 10),
                        Text("Behavior Analysis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(description, style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeBlue, 
                    padding: const EdgeInsets.symmetric(vertical: 18), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}