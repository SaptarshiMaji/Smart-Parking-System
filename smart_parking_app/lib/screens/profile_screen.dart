import 'package:flutter/material.dart';

import '../services/api_service.dart';

import '../services/session_manager.dart';

import 'login_screen.dart';

import 'settings_screen.dart';

import 'notifications_screen.dart';

import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  bool isLoading = true;

  Map<String, dynamic>? profile;

  @override
  void initState() {

    super.initState();

    loadProfile();
  }

  // =========================
  // LOAD PROFILE
  // =========================

  Future<void> loadProfile() async {

  try {

    String email =
        await SessionManager
            .getUserEmail();

    final response =
        await ApiService.getProfile(
      email,
    );

    if (!mounted) return;

    if (response["success"] == true) {

      setState(() {

        profile =
            response["profile"];

        isLoading = false;
      });

    } else {

      setState(() {

        isLoading = false;
      });
    }

  } catch (e) {

    if (!mounted) return;

    setState(() {

      isLoading = false;
    });
  }
}
  // =========================
  // EDIT PROFILE
  // =========================

  Future<void> editProfileDialog() async {

    TextEditingController nameController =
        TextEditingController(
      text: profile?["name"] ?? "",
    );

    TextEditingController phoneController =
        TextEditingController(
      text: profile?["phone"] ?? "",
    );

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          backgroundColor:
              const Color(0xFF1E293B),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
                    20),
          ),

          title: const Text(

            "Edit Profile",

            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              TextField(

                controller:
                    nameController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  labelText: "Name",

                  labelStyle:
                      const TextStyle(

                    color: Colors.white70,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white10,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                    phoneController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  labelText:
                      "Phone Number",

                  labelStyle:
                      const TextStyle(

                    color: Colors.white70,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white10,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(

              onPressed: () async {

                String email =
                    await SessionManager
                        .getUserEmail();

                final response =
                    await ApiService
                        .updateProfile(

                  email: email,

                  name:
                      nameController.text,

                  phone:
                      phoneController.text,
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(

                  SnackBar(

                    content: Text(

                      response["message"],
                    ),
                  ),
                );

                loadProfile();
              },

              child: const Text(
                "Save",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        title: const Text(

          "Profile",

          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [

          IconButton(

            onPressed: loadProfile,

            icon: const Icon(

              Icons.refresh,

              color: Colors.white,
            ),
          ),
        ],
      ),

      body: isLoading

          ? const Center(

              child:
                  CircularProgressIndicator(),
            )

          : profile == null

              ? const Center(

                  child: Text(

                    "Failed to load profile",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )

              : SingleChildScrollView(

                  padding:
                      const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      // PROFILE CARD

                      Container(

                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .all(25),

                        decoration:
                            BoxDecoration(

                          color: Colors.white
                              .withOpacity(
                                  0.08),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      28),
                        ),

                        child: Column(

                          children: [

                            Container(

                              width: 110,

                              height: 110,

                              decoration:
                                  const BoxDecoration(

                                shape:
                                    BoxShape
                                        .circle,

                                gradient:
                                    LinearGradient(

                                  colors: [

                                    Color(
                                        0xFF38BDF8),

                                    Color(
                                        0xFF2563EB),
                                  ],
                                ),
                              ),

                              child:
                                  const Icon(

                                Icons.person,

                                size: 60,

                                color:
                                    Colors.white,
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            Text(

                              profile!["name"],

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,

                                fontSize: 28,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(

                              profile!["email"],

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white70,

                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(
                                height: 25),

                            Row(

                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceEvenly,

                              children: [

                                buildStatCard(

                                  profile![
                                          "total_bookings"]
                                      .toString(),

                                  "Bookings",
                                ),

                                buildStatCard(

                                  "₹${double.parse(profile!["total_payments"].toString()).toStringAsFixed(2)}",

                                  "Payments",
                                ),

                                buildStatCard(

                                  profile![
                                          "active_bookings"]
                                      .toString(),

                                  "Active",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 30),

                      // USER INFO

                      sectionTitle(
                        "User Information",
                      ),

                      const SizedBox(
                          height: 15),

                      buildInfoCard(

                        icon: Icons.phone,

                        title:
                            "Phone Number",

                        value:
                            profile!["phone"],
                      ),

                      const SizedBox(
                          height: 15),

                      buildInfoCard(

                        icon:
                            Icons.location_on,

                        title: "Location",

                        value:
                            profile!["location"],
                      ),

                      const SizedBox(
                          height: 30),

                      // BOOKING HISTORY

ExpansionTile(

  collapsedIconColor: Colors.white,

  iconColor: Colors.white,

  title: const Text(

    "Booking History",

    style: TextStyle(

      color: Colors.white,

      fontSize: 24,

      fontWeight: FontWeight.bold,
    ),
  ),

  children: [

    Padding(

      padding: const EdgeInsets.only(
        top: 15,
      ),

      child: Column(

        children: List.generate(

          profile!["booking_history"].length,

          (index) {

            final booking =
                profile!["booking_history"][index];

            return Padding(

              padding:
                  const EdgeInsets.only(
                      bottom: 15),

              child: buildBookingCard(

                parkingName:
                    booking["parking_name"],

                slot:
                    booking["slot"],

                date:
                    booking["date"],

                amount:
                    "₹${double.parse(booking["amount"].toString()).toStringAsFixed(2)}",

                status:
                    booking["status"],
              ),
            );
          },
        ),
      ),
    ),
  ],
),

const SizedBox(
    height: 30),

                      // PAYMENT HISTORY

ExpansionTile(

  collapsedIconColor: Colors.white,

  iconColor: Colors.white,

  title: const Text(

    "Payment History",

    style: TextStyle(

      color: Colors.white,

      fontSize: 24,

      fontWeight: FontWeight.bold,
    ),
  ),

  children: [

    Padding(

      padding: const EdgeInsets.only(
        top: 15,
      ),

      child: Column(

        children: List.generate(

          profile!["payment_history"].length,

          (index) {

            final payment =
                profile!["payment_history"][index];

            return Padding(

              padding:
                  const EdgeInsets.only(
                      bottom: 15),

              child: buildPaymentCard(

                amount:
                    "₹${double.parse(payment["amount"].toString()).toStringAsFixed(2)}",

                method:
                    payment["method"],

                date:
                    payment["date"],
              ),
            );
          },
        ),
      ),
    ),
  ],
),

const SizedBox(
    height: 30),

                      // SETTINGS OPTIONS

                      Container(

                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .all(20),

                        decoration:
                            BoxDecoration(

                          color: Colors.white
                              .withOpacity(
                                  0.08),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      22),
                        ),

                        child: Column(

                          children: [

                            profileOption(

                              icon: Icons.edit,

                              title:
                                  "Edit Profile",

                              onTap:
                                  editProfileDialog,
                            ),

                            profileOption(

                              icon:
                                  Icons.settings,

                              title:
                                  "Settings",

                              onTap: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              },
                            ),

                            profileOption(

                              icon:
                                  Icons.notifications,

                              title:
                                  "Notifications",

                              onTap: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        const NotificationsScreen(),
                                  ),
                                );
                              },
                            ),

                            profileOption(

                              icon:
                                  Icons.help,

                              title:
                                  "Help & Support",

                              onTap: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        const HelpSupportScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 35),

                      // LOGOUT BUTTON

                      SizedBox(

                        width:
                            double.infinity,

                        height: 60,

                        child:
                            ElevatedButton(

                          style:
                              ElevatedButton
                                  .styleFrom(

                            backgroundColor:
                                Colors.red,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),
                            ),
                          ),

                          onPressed:
                              () async {

                            await SessionManager
                                .logout();

                            Navigator
                                .pushAndRemoveUntil(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    const LoginScreen(),
                              ),

                              (route) =>
                                  false,
                            );
                          },

                          child:
                              const Row(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(

                                Icons.logout,

                                color:
                                    Colors.white,
                              ),

                              SizedBox(
                                  width: 10),

                              Text(

                                "Logout",

                                style:
                                    TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 25),
                    ],
                  ),
                ),
    );
  }

  Widget sectionTitle(
      String title) {

    return Align(

      alignment:
          Alignment.centerLeft,

      child: Text(

        title,

        style: const TextStyle(

          color: Colors.white,

          fontSize: 24,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildStatCard(

    String value,

    String label,
  ) {

    return Container(

      width: 95,

      padding:
          const EdgeInsets.symmetric(

        vertical: 18,
      ),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(

        children: [

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(

            label,

            textAlign:
                TextAlign.center,

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({

    required IconData icon,

    required String title,

    required String value,
  }) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(

        children: [

          Container(

            width: 55,

            height: 55,

            decoration: BoxDecoration(

              color: const Color(
                      0xFF38BDF8)
                  .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                      16),
            ),

            child: Icon(

              icon,

              color:
                  const Color(
                      0xFF38BDF8),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  title,

                  style:
                      const TextStyle(

                    color:
                        Colors.white70,

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 5),

                Text(

                  value,

                  style:
                      const TextStyle(

                    color: Colors.white,

                    fontSize: 17,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingCard({

    required String parkingName,

    required String slot,

    required String date,

    required String amount,

    required String status,
  }) {

    Color statusColor =
        status == "completed"

            ? Colors.green

            : status == "active"

                ? Colors.orange

                : Colors.red;

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Column(

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Expanded(

                child: Text(

                  parkingName,

                  style:
                      const TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              Container(

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 12,

                  vertical: 6,
                ),

                decoration: BoxDecoration(

                  color:
                      statusColor
                          .withOpacity(0.2),

                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),

                child: Text(

                  status.toUpperCase(),

                  style: TextStyle(

                    color:
                        statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Text(

                "Slot: $slot",

                style:
                    const TextStyle(

                  color:
                      Colors.white70,
                ),
              ),

              Text(

                amount,

                style:
                    const TextStyle(

                  color:
                      Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Align(

            alignment:
                Alignment.centerRight,

            child: Text(

              date,

              style:
                  const TextStyle(

                color:
                    Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentCard({

    required String amount,

    required String method,

    required String date,
  }) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(

        children: [

          Container(

            width: 55,

            height: 55,

            decoration: BoxDecoration(

              color: Colors.green
                  .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                      16),
            ),

            child: const Icon(

              Icons.payment,

              color: Colors.green,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  amount,

                  style:
                      const TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(

                  "$method Payment",

                  style:
                      const TextStyle(

                    color:
                        Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Text(

            date,

            style: const TextStyle(

              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileOption({

    required IconData icon,

    required String title,

    VoidCallback? onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Padding(

        padding:
            const EdgeInsets.only(
                bottom: 22),

        child: Row(

          children: [

            Container(

              width: 52,

              height: 52,

              decoration: BoxDecoration(

                color: const Color(
                        0xFF38BDF8)
                    .withOpacity(0.2),

                borderRadius:
                    BorderRadius.circular(
                        16),
              ),

              child: Icon(

                icon,

                color:
                    const Color(
                        0xFF38BDF8),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(

              child: Text(

                title,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 17,
                ),
              ),
            ),

            const Icon(

              Icons.arrow_forward_ios,

              color: Colors.white54,

              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}