import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';

class BookingsScreen extends StatefulWidget {

  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() =>
      _BookingsScreenState();
}

class _BookingsScreenState
    extends State<BookingsScreen> {

  List<dynamic> bookings = [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadBookings();
  }

  Future<void> loadBookings() async {

  try {

    String email =
    await SessionManager
        .getUserEmail();

final data =
    await ApiService.getBookings(
        email);

    if (!mounted) return;

    // =========================
    // CUSTOM SORT
    // =========================

    data.sort((a, b) {

      Map<String, int> priority = {

        "active": 0,

        "cancelled": 1,

        "completed": 2,
      };

      int priorityA =
          priority[a["status"]] ?? 99;

      int priorityB =
          priority[b["status"]] ?? 99;

      return priorityA.compareTo(
        priorityB,
      );
    });

    setState(() {

      bookings = data;

      isLoading = false;
    });

  } catch (e) {

    if (!mounted) return;

    setState(() {

      isLoading = false;
    });
  }
}

  Future<void> cancelBooking(
    String bookingId,
  ) async {

    final response =
        await ApiService.cancelBooking(
      bookingId,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content:
            Text(response["message"]),
      ),
    );

    loadBookings();
  }

  Color getStatusColor(
    String status,
  ) {

    switch (status) {

      case "active":

        return const Color.fromARGB(255, 0, 253, 55);

      case "completed":

        return const Color.fromARGB(255, 251, 255, 0);

      case "cancelled":

        return Colors.red;

      default:

        return Colors.grey;
    }
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

          "My Bookings",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: isLoading

          ? const Center(

              child:
                  CircularProgressIndicator(),
            )

          : bookings.isEmpty

              ? buildEmptyState()

              : RefreshIndicator(

                  onRefresh: loadBookings,

                  child: ListView.builder(

                    padding:
                        const EdgeInsets.all(20),

                    itemCount:
                        bookings.length,

                    itemBuilder:

                        (context, index) {

                      final booking =
                          bookings[index];

                      return Padding(

                        padding:
                            const EdgeInsets.only(

                          bottom: 22,
                        ),

                        child: buildBookingCard(

                          booking: booking,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget buildEmptyState() {

    return Center(

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(

            Icons.local_parking,

            size: 100,

            color:
                Colors.white.withOpacity(0.3),
          ),

          const SizedBox(height: 20),

          const Text(

            "No Bookings Found",

            style: TextStyle(

              color: Colors.white70,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(

            "Your parking history will appear here",

            style: TextStyle(

              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookingCard({

    required dynamic booking,
  }) {

    String status =
        booking["status"];

    Color statusColor =
        getStatusColor(status);

    return AnimatedContainer(

      duration:
          const Duration(milliseconds: 400),

      width: double.infinity,

      padding:
          const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(0.08),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(

          color:
              statusColor.withOpacity(0.5),

          width: 1.5,
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Expanded(

                child: Text(

                  booking["parking_name"],

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              Container(

                padding:
                    const EdgeInsets.symmetric(

                  horizontal: 14,

                  vertical: 8,
                ),

                decoration: BoxDecoration(

                  color:
                      statusColor.withOpacity(
                          0.2),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: Text(

                  status.toUpperCase(),

                  style: TextStyle(

                    color: statusColor,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          buildInfoRow(

            Icons.confirmation_number,

            "Booking ID",

            booking["booking_id"],
          ),

          buildInfoRow(

            Icons.local_parking,

            "Slot",

            booking["slot"],
          ),

          buildInfoRow(

            Icons.directions_car,

            "Vehicle",

            booking["vehicle_number"],
          ),

          buildInfoRow(

            Icons.calendar_month,

            "Date",

            booking["booking_date"],
          ),

          buildInfoRow(

            Icons.access_time,

            "Timing",

            "${booking["entry_time"]} - ${booking["exit_time"]}",
          ),

          buildInfoRow(

            Icons.currency_rupee,

            "Amount",

            "₹${booking["amount"]}",
          ),

          const SizedBox(height: 25),

          Wrap(

            spacing: 12,

            runSpacing: 12,

            children: [

              ElevatedButton.icon(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(0xFF38BDF8),
                ),

                onPressed: () {

                  showDialog(

                    context: context,

                    builder: (_) {

                      return Dialog(

                        backgroundColor:
                            const Color(
                                0xFF1E293B),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                                  24),
                        ),

                        child: Padding(

                          padding:
                              const EdgeInsets
                                  .all(20),

                          child:
                              SingleChildScrollView(

                            child: Column(

                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                const Text(

                                  "Booking QR",

                                  style:
                                      TextStyle(

                                    color:
                                        Colors.white,

                                    fontSize: 22,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 25),

                                Container(

                                  padding:
                                      const EdgeInsets
                                          .all(20),

                                  decoration:
                                      BoxDecoration(

                                    color:
                                        Colors.white,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),

                                  child:
                                      QrImageView(

                                    data:
                                        booking[
                                            "booking_id"],

                                    version:
                                        QrVersions.auto,

                                    size: 220,
                                  ),
                                ),

                                const SizedBox(
                                    height: 20),

                                Text(

                                  booking[
                                      "booking_id"],

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      const TextStyle(

                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(
                                    height: 15),

                                const Text(

                                  "Show this QR at entry gate",

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      TextStyle(

                                    color:
                                        Colors.white70,
                                  ),
                                ),

                                const SizedBox(
                                    height: 25),

                                SizedBox(

                                  width:
                                      double.infinity,

                                  child:
                                      ElevatedButton(

                                    style:
                                        ElevatedButton
                                            .styleFrom(

                                      backgroundColor:
                                          const Color(
                                              0xFF38BDF8),
                                    ),

                                    onPressed: () {

                                      Navigator.pop(
                                          context);
                                    },

                                    child:
                                        const Text(

                                      "Close",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },

                icon: const Icon(

                  Icons.qr_code,

                  color: Colors.white,
                ),

                label: const Text(

                  "View QR",

                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

              if (status == "active")

                ElevatedButton.icon(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.red,
                  ),

                  onPressed: () {

                    cancelBooking(

                      booking["booking_id"],
                    );
                  },

                  icon: const Icon(

                    Icons.cancel,

                    color: Colors.white,
                  ),

                  label: const Text(

                    "Cancel",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(

    IconData icon,

    String title,

    String value,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(bottom: 16),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(

            icon,

            color:
                const Color(0xFF38BDF8),

            size: 22,
          ),

          const SizedBox(width: 12),

          Text(

            "$title: ",

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 15,
            ),
          ),

          Expanded(

            child: Text(

              value,

              style: const TextStyle(

                color: Colors.white,

                fontWeight:
                    FontWeight.bold,

                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}