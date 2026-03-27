import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Ensure this path is correct
import 'usermodel.dart';

class HPUserSelected extends StatefulWidget {
  final UserModel user;

  const HPUserSelected({super.key, required this.user});

  @override
  State<HPUserSelected> createState() => _HPUserSelectedState();
}

class _HPUserSelectedState extends State<HPUserSelected> {
  // ---------- 1. STATE & DATA ----------  
  String selectedMetric = 'Heart Rate';
  String selectedTimeframe = 'Week';

  // ---------- 2. MAIN BUILD METHOD ---------- 
  @override
  Widget build(BuildContext context) {
    // ==========================================
    // DYNAMIC THEME VARIABLES
    // ==========================================
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final themePurple = Theme.of(context).primaryColor;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final dividerColor = Theme.of(context).dividerColor;

    return Scaffold(
      backgroundColor: themePurple,
      body: Stack(
        children: [
          // A. TOP LAYER: NAVIGATION
          Positioned(
            top: 60, left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // B. TOP LAYER: USER PROFILE HEADER
          Positioned(
            top: 110, left: 30, right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.fullName,
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "LexendExaNormal", letterSpacing: -0.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.watch_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text("Device: ${widget.user.device}",
                      style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(widget.user.infoString,
                  style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // C. MIDDLE LAYER: ANALYTICS CONTAINER
          Column(
            children: [
              const SizedBox(height: 250),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(25, 30, 25, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("ANALYTICS OVERVIEW", 
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.grey, letterSpacing: 1.2)),
                        const SizedBox(height: 20),
                        
                        // Selectors (Metric & Time)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSelector(selectedMetric, (val) => setState(() => selectedMetric = val!), ['Heart Rate', 'Steps', 'Glucose'], isDark, surfaceColor, textPrimary),
                            _buildSelector(selectedTimeframe, (val) => setState(() => selectedTimeframe = val!), ['Day', 'Week', 'Month'], isDark, surfaceColor, textPrimary, isTime: true),
                          ],
                        ),
                        
                        const SizedBox(height: 25),
                        _buildGraphSection(themePurple, surfaceColor, textPrimary, dividerColor, isDark), 
                        const SizedBox(height: 25),
                        _buildQuickStats(isDark, textPrimary),             
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // D. BOTTOM LAYER: FLOATING ACTIONS
          Positioned(
            bottom: 25, left: 20, right: 20,
            child: _buildUserActionBar(isDark),
          ),
        ],
      ),
    );
  }

  // ---------- 3. UI COMPONENT HELPERS ----------
  Widget _buildSelector(String val, ValueChanged<String?> onChange, List<String> items, bool isDark, Color surfaceColor, Color textPrimary, {bool isTime = false}) {
    final dropBg = isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: dropBg, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          dropdownColor: surfaceColor,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(isTime ? Icons.calendar_month : Icons.expand_more, size: 16, color: textPrimary),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)))).toList(),
          onChanged: onChange,
        ),
      ),
    );
  }

  Widget _buildGraphSection(Color color, Color surfaceColor, Color textPrimary, Color dividerColor, bool isDark) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: dividerColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      padding: const EdgeInsets.fromLTRB(10, 25, 25, 15),
      child: LineChart(_sampleChartData(color, dividerColor, textPrimary, surfaceColor)),
    );
  }

  Widget _buildQuickStats(bool isDark, Color textPrimary) {
    return Row(
      children: [
        _statBox("Daily Avg", "72 bpm", isDark ? Colors.orangeAccent : Colors.orange.shade800, textPrimary),
        const SizedBox(width: 15),
        _statBox("Status", "Normal", isDark ? Colors.lightBlueAccent : Colors.blue.shade800, textPrimary),
      ],
    );
  }

  Widget _statBox(String title, String val, Color col, Color textPrimary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.06), 
          borderRadius: BorderRadius.circular(25), 
          border: Border.all(color: col.withValues(alpha: 0.12))
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserActionBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionItem(Icons.phone_in_talk, "Contact", const Color(0xFF2ED573), () {}),
          _actionItem(Icons.chat_bubble_outline, "Feedback", Colors.white, () {}),
          _actionItem(Icons.person_remove_alt_1_outlined, "Remove", const Color(0xFFFF4757), () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------- 4. CHART LOGIC & DATA MAPPING ----------
  LineChartData _sampleChartData(Color color, Color dividerColor, Color textPrimary, Color surfaceColor) {
    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: dividerColor, strokeWidth: 1.5)),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => _getBottomTitles(v, textPrimary))),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 35, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: TextStyle(color: textPrimary.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.bold)))),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: _generateMockSpots(),
          isCurved: true,
          curveSmoothness: 0.35,
          color: color,
          barWidth: 3.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: color, strokeWidth: 1.5, strokeColor: surfaceColor)),
          belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.1)),
        ),
      ],
    );
  }

  Widget _getBottomTitles(double value, Color textPrimary) {
    String text = '';
    if (selectedTimeframe == 'Day' && value % 4 == 0) text = '${value.toInt()}h';
    if (selectedTimeframe == 'Week') text = 'D${value.toInt()}';
    if (selectedTimeframe == 'Month') text = 'W${value.toInt()}';
    return Padding(padding: const EdgeInsets.only(top: 10.0), child: Text(text, style: TextStyle(color: textPrimary.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.bold)));
  }

  List<FlSpot> _generateMockSpots() {
    switch (selectedTimeframe) {
      case 'Day': return const [FlSpot(8, 72), FlSpot(12, 85), FlSpot(16, 78), FlSpot(20, 92), FlSpot(24, 68)];
      case 'Week': return const [FlSpot(1, 70), FlSpot(2, 75), FlSpot(3, 72), FlSpot(4, 85), FlSpot(5, 78), FlSpot(6, 90), FlSpot(7, 82)];
      case 'Month': return const [FlSpot(1, 75), FlSpot(2, 82), FlSpot(3, 70), FlSpot(4, 88)];
      default: return const [FlSpot(0, 0)];
    }
  }
}