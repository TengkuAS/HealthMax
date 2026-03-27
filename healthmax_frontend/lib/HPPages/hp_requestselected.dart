import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Ensure this path is correct
import 'usermodel.dart';

class HPRequestSelected extends StatefulWidget {
  final UserModel user;

  const HPRequestSelected({super.key, required this.user});

  @override
  State<HPRequestSelected> createState() => _HPRequestSelectedState();
}

class _HPRequestSelectedState extends State<HPRequestSelected> {
  // --- STATE VARIABLES ---
  String selectedMetric = 'Heart Rate';
  String selectedTimeframe = 'Week';

  // --- DYNAMIC GRAPH LOGIC (Unchanged) ---
  double _getMaxX() => selectedTimeframe == "Week" ? 6 : (selectedTimeframe == "Month" ? 3 : 11);
  double _getMinY() => selectedMetric == 'Heart Rate' ? 60 : 0;
  double _getMaxY() {
    switch (selectedMetric) {
      case 'Heart Rate': return 100;
      case 'Steps': return 15000;
      case 'Calories': return 3500;
      case 'Glucose Level': return 15;
      default: return 100;
    }
  }
  double _getIntervalY() {
    switch (selectedMetric) {
      case 'Heart Rate': return 5;
      case 'Steps': return 5000;
      case 'Calories': return 1000;
      case 'Glucose Level': return 5;
      default: return 5;
    }
  }

  List<FlSpot> _getChartData() {
    double m = 1.0;
    if (selectedMetric == 'Steps') m = 100.0;
    if (selectedMetric == 'Calories') m = 20.0;
    if (selectedMetric == 'Glucose Level') m = 0.1;

    List<FlSpot> baseData;
    if (selectedTimeframe == "Week") {
      baseData = const [FlSpot(0, 70), FlSpot(1, 75), FlSpot(2, 72), FlSpot(3, 85), FlSpot(4, 78), FlSpot(5, 90), FlSpot(6, 82)];
    } else if (selectedTimeframe == "Month") {
      baseData = const [FlSpot(0, 72), FlSpot(1, 85), FlSpot(2, 78), FlSpot(3, 88)];
    } else {
      baseData = const [FlSpot(0, 75), FlSpot(2, 80), FlSpot(4, 85), FlSpot(6, 78), FlSpot(8, 90), FlSpot(10, 85), FlSpot(11, 88)];
    }
    return baseData.map((spot) => FlSpot(spot.x, spot.y * m)).toList();
  }

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
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- PREMIUM SLIVER APP BAR ---
              SliverAppBar(
                backgroundColor: themePurple,
                expandedHeight: 250.0,
                toolbarHeight: 70.0,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0.0,
                surfaceTintColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 65, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.fullName,
                            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "LexendExaNormal", letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.watch_rounded, color: Colors.white70, size: 16),
                              const SizedBox(width: 6),
                              Text("Device: ${widget.user.device}", style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${widget.user.gender} | ${widget.user.height.toInt()} cm | ${widget.user.weight.toInt()} kg",
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30),
                  child: Transform.translate(
                    offset: const Offset(0, 1),
                    child: Container(height: 31, width: double.infinity, decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(35)))),
                  ),
                ),
              ),

              // --- MAIN BODY CONTENT ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ANALYTICS OVERVIEW", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.grey, letterSpacing: 1.2)),
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDropdown(['Heart Rate', 'Steps', 'Glucose Level', 'Calories'], selectedMetric, (v) => setState(() => selectedMetric = v!), isMetric: true, isDark: isDark, surfaceColor: surfaceColor, textPrimary: textPrimary),
                          _buildDropdown(['Week', 'Month', 'Year'], selectedTimeframe, (v) => setState(() => selectedTimeframe = v!), isMetric: false, isDark: isDark, surfaceColor: surfaceColor, textPrimary: textPrimary),
                        ],
                      ),
                      
                      const SizedBox(height: 25),
                      _buildMainGraph(themePurple, surfaceColor, textPrimary, dividerColor, isDark),
                      const SizedBox(height: 25),
                      
                      Row(
                        children: [
                          Expanded(child: _buildStatCard("Daily Avg", "72 bpm", isDark ? Colors.orangeAccent : Colors.orange.shade800, isDark ? Colors.orange.withValues(alpha: 0.1) : Colors.orange.shade50, textPrimary)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildStatCard("Status", "Normal", isDark ? Colors.lightBlueAccent : Colors.blue.shade800, isDark ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.shade50, textPrimary)),
                        ],
                      ),
                      
                      const SizedBox(height: 140), 
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ==========================================
          // 2. FLOATING DARK ACTION BAR
          // ==========================================
          Positioned(
            bottom: 25, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E), 
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(Icons.phone_in_talk, "Contact", const Color(0xFF2ED573), () {}),
                  _actionButton(Icons.chat_bubble_outline, "Feedback", Colors.white, () {}),
                  _actionButton(Icons.person_remove_alt_1_outlined, "Remove", const Color(0xFFFF4757), () => Navigator.pop(context)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // UI COMPONENT HELPERS
  // ==========================================

  Widget _buildDropdown(List<String> items, String val, ValueChanged<String?> onChanged, {required bool isMetric, required bool isDark, required Color surfaceColor, required Color textPrimary}) {
    final dropBg = isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: dropBg, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          dropdownColor: surfaceColor,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(isMetric ? Icons.keyboard_arrow_down_rounded : Icons.calendar_today_outlined, color: textPrimary, size: 16),
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Center(child: Text(item, style: TextStyle(fontWeight: FontWeight.w900, color: textPrimary, fontSize: 13, fontFamily: "LexendExaNormal")));
            }).toList();
          },
          onChanged: onChanged,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)))).toList(),
        ),
      ),
    );
  }

  Widget _buildMainGraph(Color themePurple, Color surfaceColor, Color textPrimary, Color dividerColor, bool isDark) {
    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(15, 25, 25, 15),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: dividerColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: dividerColor, strokeWidth: 1.5)),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, reservedSize: 30, interval: 1,
                getTitlesWidget: (value, meta) {
                  final style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary.withValues(alpha: 0.5));
                  String text = '';
                  if (selectedTimeframe == "Week") {
                    const days = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'];
                    if (value.toInt() >= 0 && value.toInt() < days.length) text = days[value.toInt()];
                  } else if (selectedTimeframe == "Month") {
                    text = 'Wk ${value.toInt() + 1}';
                  } else if (selectedTimeframe == "Year") {
                    if (value.toInt() % 3 == 0) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      text = months[value.toInt()];
                    }
                  }
                  if (text.isEmpty) return const SizedBox.shrink();
                  return Padding(padding: const EdgeInsets.only(top: 10.0), child: Text(text, style: style));
                }, 
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, interval: _getIntervalY(), reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  if (value == _getMinY() || value == _getMaxY()) return const SizedBox.shrink();
                  String text = selectedMetric == 'Steps' ? '${(value / 1000).toInt()}k' : (selectedMetric == 'Glucose Level' ? value.toStringAsFixed(1) : value.toInt().toString());
                  return Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textPrimary.withValues(alpha: 0.5)));
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0, maxX: _getMaxX(),
          minY: _getMinY(), maxY: _getMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartData(),
              isCurved: true, curveSmoothness: 0.35,
              color: themePurple, barWidth: 3.5, isStrokeCapRound: true,
              dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: themePurple, strokeWidth: 1.5, strokeColor: surfaceColor)),
              belowBarData: BarAreaData(show: true, color: themePurple.withValues(alpha: 0.1)), 
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeOutCubic,
      )
    );
  }

  Widget _buildStatCard(String title, String value, Color titleColor, Color bgColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: titleColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: textPrimary)),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }
}