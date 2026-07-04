import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';

class QRScreen extends StatefulWidget {

  const QRScreen({super.key});

  @override
  State<QRScreen> createState() =>
      _QRScreenState();
}

class _QRScreenState
    extends State<QRScreen> {

  bool isLoading = true;

  Map<String, dynamic>? booking;

@override
void initState() {

  super.initState();

  Future.microtask(() {

    if (!mounted) return;

    loadActiveBooking();
  });
}

Future<void> loadActiveBooking() async {

  try {

    String email =
        await SessionManager
            .getUserEmail();

    final response =
        await ApiService
            .getActiveBooking(
                email);

    if (!mounted) return;

    if (response["success"] == true) {

      setState(() {

        booking =
            response["booking"];

        isLoading = false;
      });

    } else {

      setState(() {

        booking = null;

        isLoading = false;
      });
    }

  } catch (e) {

    if (!mounted) return;

    setState(() {

      booking = null;

      isLoading = false;
    });
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

          "Live QR",

          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [

          IconButton(

            onPressed: loadActiveBooking,

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

          : booking == null

              ? buildNoBookingUI()

              : buildQRContent(),
    );
  }

  // =========================
  // NO ACTIVE BOOKING UI
  // =========================

  Widget buildNoBookingUI() {

    return Center(

      child: Padding(

        padding:
            const EdgeInsets.all(25),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(

              Icons.qr_code_2,

              size: 120,

              color:
                  Colors.white.withOpacity(
                      0.3),
            ),

            const SizedBox(height: 25),

            const Text(

              "No Active Booking",

              style: TextStyle(

                color: Colors.white,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(

              "Book a parking slot to generate your live QR access.",

              textAlign: TextAlign.center,

              style: TextStyle(

                color: Colors.white70,

                fontSize: 16,

                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // ACTIVE QR UI
  // =========================

  Widget buildQRContent() {

    String bookingId =
        booking!["booking_id"];

    return RefreshIndicator(

      onRefresh: loadActiveBooking,

      child: SingleChildScrollView(

        physics:
            const AlwaysScrollableScrollPhysics(),

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 20),

            // =========================
            // QR CARD
            // =========================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color:
                    Colors.white.withOpacity(
                        0.08),

                borderRadius:
                    BorderRadius.circular(25),
              ),

              child: Column(

                children: [

                  const Icon(

                    Icons.qr_code_2,

                    color:
                        Color(0xFF38BDF8),

                    size: 60,
                  ),

                  const SizedBox(height: 20),

                  const Text(

                    "Active Parking QR",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 26,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Show this QR at parking entry gate",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(

                    padding:
                        const EdgeInsets.all(
                            20),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),

                    child: QrImageView(

                      data: bookingId,

                      version:
                          QrVersions.auto,

                      size: 240,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(

                    bookingId,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // BOOKING DETAILS
            // =========================

            Container(

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

                  buildRow(

                    "Parking",

                    booking!["parking_name"],
                  ),

                  buildRow(

                    "Slot",

                    booking!["slot"],
                  ),

                  buildRow(

                    "Vehicle",

                    booking![
                        "vehicle_number"],
                  ),

                  buildRow(

                    "Date",

                    booking!["booking_date"],
                  ),

                  buildRow(

                    "Timing",

                    "${booking!["entry_time"]} - ${booking!["exit_time"]}",
                  ),

                  buildRow(

                    "Booking ID",

                    bookingId,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // INFO BOX
            // =========================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.blue
                    .withOpacity(0.15),

                borderRadius:
                    BorderRadius.circular(
                        18),

                border: Border.all(

                  color: Colors.blue,
                ),
              ),

              child: const Row(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Icon(

                    Icons.info,

                    color: Colors.blue,
                  ),

                  SizedBox(width: 12),

                  Expanded(

                    child: Text(

                      "Your QR will be scanned by the ESP32 smart parking gate for automatic entry access.",

                      style: TextStyle(

                        color: Colors.white70,

                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildRow(

    String title,

    String value,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
              bottom: 18),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [

          Text(

            title,

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 16,
            ),
          ),

          Flexible(

            child: Text(

              value,

              textAlign:
                  TextAlign.right,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 16,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}