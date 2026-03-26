import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // A premium, modern gradient background
    final Color gradientStart = const Color(0xFF8A98E8); // Soft periwinkle/blue
    final Color gradientEnd = const Color(0xFF5D34EC);   // Deep vibrant purple

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(), // Pushes content to the middle

              // --- 1. GLOWING LOGO/ICON ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 30, spreadRadius: 10),
                  ],
                ),
                child: const Icon(Icons.monitor_heart_outlined, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // --- 2. THE TYPOGRAPHY OVERHAUL ---
              const Text(
                "WELCOME TO",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70,
                  letterSpacing: 3.0,
                  fontFamily: "LexendExaNormal",
                ),
              ),
              const SizedBox(height: 10),
              
              // The massive "HealthMax" highlight
              const Text(
                "HealthMax.",
                style: TextStyle(
                  fontSize: 50, // Massive size!
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  fontFamily: "LexendExaNormal",
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              
              const Text(
                "Your Virtual Health Companion",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(), // Pushes buttons to the bottom area

              // --- 3. PREMIUM ACTION BUTTONS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    _buildRoleButton(
                      context, 
                      title: "User", 
                      route: '/user_homepage', // Wires directly to the user dashboard
                      textColor: gradientEnd,
                    ),
                    const SizedBox(height: 20),
                    _buildRoleButton(
                      context, 
                      title: "Healthcare Provider", 
                      route: '/hp_home', // Wires directly to the HP dashboard
                      textColor: gradientEnd,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for perfect, reusable pill buttons
  Widget _buildRoleButton(BuildContext context, {required String title, required String route, required Color textColor}) {
    return ElevatedButton(
      onPressed: () {
        // Navigates to the selected route and removes the welcome page from the backstack
        Navigator.pushReplacementNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Pure white buttons
        foregroundColor: textColor, // Purple text/ripple effect
        minimumSize: const Size(double.infinity, 65), // Thick, touch-friendly height
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35), // Perfect pill shape
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900, // Extra bold text
          letterSpacing: 1.2,
          fontFamily: "LexendExaNormal",
        ),
      ),
    );
  }
}