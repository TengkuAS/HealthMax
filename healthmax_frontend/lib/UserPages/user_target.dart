import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; 
import 'user_bottomnavbar.dart';
import 'user_glassy_profile.dart';
import 'goal_provider.dart'; 
import 'AI_Features/ai_translator_service.dart'; // <-- IMPORT AI SERVICE

class UserTargetPage extends StatefulWidget {
  const UserTargetPage({super.key});
  @override
  State<UserTargetPage> createState() => _UserTargetPageState();
}

class _UserTargetPageState extends State<UserTargetPage> {
  final Color themeBlue = const Color(0xFF5A84F1);
  final Color themePurple = const Color(0xFF8E33FF); 
  late ScrollController _scrollController;
  bool _isScrolled = false;
  bool _isAiCalculating = true; 

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _isAiCalculating = false); });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 70 && !_isScrolled) setState(() => _isScrolled = true);
      else if (_scrollController.offset <= 70 && _isScrolled) setState(() => _isScrolled = false);
    });
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final goalData = Provider.of<GoalProvider>(context);
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = isDark ? Colors.white54 : Colors.grey.shade600;
    final dividerColor = Theme.of(context).dividerColor;
    int completedTargets = goalData.targets.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: bgColor,
      body: goalData.isLoading ? Center(child: CircularProgressIndicator(color: themeBlue)) : CustomScrollView(
        controller: _scrollController, physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false, backgroundColor: themeBlue, expandedHeight: 200.0, toolbarHeight: 90.0, pinned: true, elevation: 0, scrolledUnderElevation: 0.0, surfaceTintColor: Colors.transparent,
            title: AnimatedOpacity(duration: const Duration(milliseconds: 250), opacity: _isScrolled ? 1.0 : 0.0, child: Padding(padding: const EdgeInsets.only(left: 15.0, top: 10.0), child: ShaderMask(shaderCallback: (Rect bounds) => const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.white, Colors.white, Colors.transparent], stops: [0.0, 0.85, 1.0]).createShader(bounds), blendMode: BlendMode.dstIn, child: Text(themeProvider.translate('your_target'), maxLines: 1, softWrap: false, overflow: TextOverflow.clip, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "LexendExaNormal"))))),
            actions: [Padding(padding: const EdgeInsets.only(right: 30.0, top: 10.0), child: Center(child: UserGlassyProfile(onTap: () => Navigator.pushNamed(context, '/user_settings'))))],
            flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.parallax, background: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(30, 20, 30, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [FittedBox(fit: BoxFit.scaleDown, child: Text(themeProvider.translate('your_target').replaceFirst(' ', '\n'), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: "LexendExaNormal", letterSpacing: -1.0, height: 1.1)))])))),
            bottom: PreferredSize(preferredSize: const Size.fromHeight(30), child: Transform.translate(offset: const Offset(0, 1), child: Container(height: 31, width: double.infinity, decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(40)))))),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [themePurple.withValues(alpha:0.2), surfaceColor] : [themePurple.withValues(alpha:0.1), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(30), border: Border.all(color: themePurple.withValues(alpha:0.5), width: 1.5), boxShadow: isDark ? [] : [BoxShadow(color: themePurple.withValues(alpha:0.15), blurRadius: 20, offset: const Offset(0, 10))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: themePurple.withValues(alpha:0.2), shape: BoxShape.circle), child: Icon(Icons.flag_circle_rounded, color: themePurple, size: 20)), const SizedBox(width: 10), Text(themeProvider.translate('main_goal'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: themePurple, letterSpacing: 1.5, fontFamily: "LexendExaNormal"))]),
                            GestureDetector(onTap: () => {}, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black.withValues(alpha:0.05), borderRadius: BorderRadius.circular(12)), child: Text(themeProvider.translate('edit'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary)))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        if (goalData.mainGoal.title == "N/A") ...[
                          Text(themeProvider.translate('no_goal_yet'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimary, fontFamily: "LexendExaNormal")),
                          const SizedBox(height: 8),
                          Text(themeProvider.translate('set_goal_desc'), style: TextStyle(color: textSecondary, fontSize: 13)),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // AI TRANSLATION FOR DYNAMIC GOAL TITLE
                                    FittedBox(fit: BoxFit.scaleDown, child: AiTranslatedText(goalData.mainGoal.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimary, fontFamily: "LexendExaNormal"))),
                                    const SizedBox(height: 4),
                                    FittedBox(fit: BoxFit.scaleDown, child: Text("${themeProvider.translate('target_label')} ${goalData.mainGoal.targetValue}", style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w600))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(_isAiCalculating ? "--%" : "${(goalData.mainGoal.aiProgress * 100).toInt()}%", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _isAiCalculating ? textSecondary : themePurple, fontFamily: "LexendExaNormal")),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(borderRadius: BorderRadius.circular(10), child: TweenAnimationBuilder<double>(tween: Tween<double>(begin: 0.0, end: _isAiCalculating ? 0.0 : goalData.mainGoal.aiProgress), duration: const Duration(seconds: 1), curve: Curves.easeOutCubic, builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 8, backgroundColor: isDark ? Colors.white10 : Colors.grey.shade300, valueColor: AlwaysStoppedAnimation<Color>(themePurple)))),
                          const SizedBox(height: 20),
                          
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _isAiCalculating 
                              ? Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.black.withValues(alpha:0.05), borderRadius: BorderRadius.circular(15)), child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: themePurple, strokeWidth: 2)), const SizedBox(width: 10), Expanded(child: AiTranslatedText("AI is analyzing your recent history...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white54 : Colors.black54)))]))
                              : Container(
                                  padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: themePurple.withValues(alpha:0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: themePurple.withValues(alpha:0.3))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.auto_awesome, color: themePurple, size: 18), const SizedBox(width: 10),
                                      // AI TRANSLATION FOR DYNAMIC INSIGHTS!
                                      Expanded(child: AiTranslatedText(goalData.mainGoal.aiInsightText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87, height: 1.4))),
                                    ],
                                  ),
                                ),
                          )
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(30), border: isDark ? Border.all(color: dividerColor) : null, boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 15, offset: const Offset(0, 8))]),
                    child: Column(
                      children: [
                        FittedBox(fit: BoxFit.scaleDown, child: Text("${themeProvider.translate('your_score')} ${goalData.userScore}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimary, fontFamily: "LexendExaNormal"))),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: isDark ? bgColor : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: themeBlue, width: 2.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FittedBox(fit: BoxFit.scaleDown, child: Text("$completedTargets/${goalData.targets.length} Achieved!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: themeBlue, fontFamily: "LexendExaNormal"), textAlign: TextAlign.center)),
                              const SizedBox(height: 4),
                              Text(goalData.targets.length == completedTargets ? "All targets completed! Great job!" : "Complete ${goalData.targets.length - completedTargets} more to get extra points!", style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              const SizedBox(height: 35),
                              
                              Text(themeProvider.translate('daily_goals'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textSecondary, letterSpacing: 1.5, fontFamily: "LexendExaNormal")),
                              const SizedBox(height: 15),
                              
                              if (goalData.targets.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text("No targets set.", style: TextStyle(color: textSecondary, fontWeight: FontWeight.bold)))
                              else ...goalData.targets.asMap().entries.map((entry) => _buildTargetProgress(entry.value, textPrimary, textSecondary, isDark)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UserBottomNavBar(currentIndex: 4), 
    );
  }

  Widget _buildTargetProgress(TargetItem target, Color textPrimary, Color textSecondary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Expanded(
                child: Row(
                  children: [
                    // AI TRANSLATION FOR SUB-TARGET TITLES
                    Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: AiTranslatedText(target.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textPrimary)))),
                    const SizedBox(width: 8),
                    if (target.isCompleted) Text("+${target.rewardPoints} pts", style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // AI TRANSLATION FOR SUB-TARGET DESCRIPTIONS
          AiTranslatedText(target.description, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          
          ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: target.progress, minHeight: 6, backgroundColor: isDark ? Colors.white10 : Colors.grey.shade300, valueColor: AlwaysStoppedAnimation<Color>(target.isCompleted ? const Color(0xFF2ED573) : const Color(0xFFFF4757)))),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${target.currentValue} ${target.unit} / ${target.targetValue} ${target.unit}", style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold)),
              Text("${(target.progress * 100).toInt()}%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}