import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'home_screen.dart';
import 'bookings_screen.dart';
import 'qr_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [

    const HomeScreen(),

    const BookingsScreen(),

    const QRScreen(),

    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      body: AnimatedSwitcher(

        duration:
            const Duration(milliseconds: 300),

        child: IndexedStack(

          key: ValueKey(selectedIndex),

          index: selectedIndex,

          children: screens,
        ),
      ),

      // =========================
      // BOTTOM NAVBAR
      // =========================

      bottomNavigationBar: Container(

        margin: const EdgeInsets.only(

          left: 15,
          right: 15,
          bottom: 15,
        ),

        padding:
            const EdgeInsets.symmetric(

          horizontal: 12,

          vertical: 12,
        ),

        decoration: BoxDecoration(

          color: const Color(0xFF111827),

          borderRadius:
              BorderRadius.circular(28),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withOpacity(0.3),

              blurRadius: 20,

              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: SafeArea(

          child: GNav(

            rippleColor:
                Colors.white24,

            hoverColor:
                Colors.white10,

            haptic: true,

            gap: 8,

            curve: Curves.easeInOut,

            duration:
                const Duration(milliseconds: 400),

            activeColor:
                Colors.white,

            color: Colors.white70,

            iconSize: 24,

            tabBackgroundColor:
                const Color(0xFF38BDF8),

            padding:
                const EdgeInsets.symmetric(

              horizontal: 18,

              vertical: 14,
            ),

            selectedIndex:
                selectedIndex,

            onTabChange: (index) {

              setState(() {

                selectedIndex = index;
              });
            },

            tabs: const [

              // =========================
              // HOME
              // =========================

              GButton(

                icon: Icons.home_rounded,

                text: 'Home',
              ),

              // =========================
              // BOOKINGS
              // =========================

              GButton(

                icon:
                    Icons.book_online_rounded,

                text: 'Bookings',
              ),

              // =========================
              // LIVE QR
              // =========================

              GButton(

                icon:
                    Icons.qr_code_rounded,

                text: 'QR',
              ),

              // =========================
              // PROFILE
              // =========================

              GButton(

                icon:
                    Icons.person_rounded,

                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}