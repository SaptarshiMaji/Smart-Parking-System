import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/map_service.dart';

class BookingSuccessScreen
    extends StatelessWidget {

  final String bookingId;

  final String parkingName;

  final String slot;

  final String vehicleNumber;

  final String bookingDate;

  final String entryTime;

  final String exitTime;
final double latitude;

final double longitude;

  const BookingSuccessScreen({

  super.key,

  required this.bookingId,

  required this.parkingName,

  required this.slot,

  required this.vehicleNumber,

  required this.bookingDate,

  required this.entryTime,

  required this.exitTime,

  required this.latitude,

  required this.longitude,
});

  @override
  Widget build(BuildContext context) {

    // =====================================
    // QR NOW CONTAINS ONLY BOOKING ID
    // =====================================

    String qrData = bookingId;

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(height: 20),

              Container(

                width: 110,

                height: 110,

                decoration: BoxDecoration(

                  color: Colors.green
                      .withOpacity(0.15),

                  shape: BoxShape.circle,
                ),

                child: const Icon(

                  Icons.check_circle,

                  color: Colors.green,

                  size: 80,
                ),
              ),

              const SizedBox(height: 25),

              const Text(

                "Booking Confirmed!",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                "Your parking slot has been booked successfully.",

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.white70,

                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              Container(

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(

                  color:
                      Colors.white.withOpacity(0.08),

                  borderRadius:
                      BorderRadius.circular(25),
                ),

                child: Column(

                  children: [

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

                        data: qrData,

                        version:
                            QrVersions.auto,

                        size: 250,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(

                      "Scan this QR at parking entry gate",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color:
                      Colors.white.withOpacity(0.08),

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(

                  children: [

                    buildRow(
                      "Booking ID",
                      bookingId,
                    ),

                    buildRow(
                      "Parking",
                      parkingName,
                    ),

                    buildRow(
                      "Slot",
                      slot,
                    ),

                    buildRow(
                      "Vehicle",
                      vehicleNumber,
                    ),

                    buildRow(
                      "Date",
                      bookingDate,
                    ),

                    buildRow(
                      "Entry",
                      entryTime,
                    ),

                    buildRow(
                      "Exit",
                      exitTime,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color: Colors.blue
                      .withOpacity(0.15),

                  borderRadius:
                      BorderRadius.circular(20),

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

                    SizedBox(width: 15),

                    Expanded(

                      child: Text(

                        "Keep this QR safe. It will be scanned at the smart parking entry gate for automatic access.",

                        style: TextStyle(

                          color: Colors.white70,

                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.green,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                              18),
                    ),
                  ),

                  onPressed: () async {

                    await MapService
    .openGoogleMaps(

  latitude: latitude,

  longitude: longitude,
);
                  },

                  child: const Row(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [

                      Icon(

                        Icons.navigation,

                        color: Colors.white,
                      ),

                      SizedBox(width: 10),

                      Text(

                        "Navigate To Parking",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        const Color(
                            0xFF38BDF8),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                              18),
                    ),
                  ),

                  onPressed: () {

                    Navigator.popUntil(

                      context,

                      (route) =>
                          route.isFirst,
                    );
                  },

                  child: const Text(

                    "Back To Home",

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
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
          const EdgeInsets.only(bottom: 15),

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