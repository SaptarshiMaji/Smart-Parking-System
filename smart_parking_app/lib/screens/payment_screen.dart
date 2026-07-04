import 'package:flutter/material.dart';

import '../services/api_service.dart';

import '../services/session_manager.dart';

import 'booking_success_screen.dart';

class PaymentScreen extends StatefulWidget {

  final String parkingName;

  final String slot;

  final String vehicleNumber;

  final String bookingDate;

  final String entryTime;

  final String exitTime;

  final double totalPrice;
  final double latitude;
final double longitude;

  const PaymentScreen({

  super.key,

  required this.parkingName,

  required this.slot,

  required this.vehicleNumber,

  required this.bookingDate,

  required this.entryTime,

  required this.exitTime,

  required this.totalPrice,

  required this.latitude,

  required this.longitude,
});

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState
    extends State<PaymentScreen> {

  bool isLoading = false;

  Future<void> processPayment() async {

    setState(() {

      isLoading = true;
    });

    try {

      // =========================
      // GET LOGGED IN USER EMAIL
      // =========================

      String userEmail =
          await SessionManager
              .getUserEmail();

      // =========================
      // CREATE BOOKING
      // =========================

      final result =
          await ApiService.createBooking(

        userEmail:
            userEmail,

        parkingName:
            widget.parkingName,

        slot:
            widget.slot,

        vehicleNumber:
            widget.vehicleNumber,

        bookingDate:
            widget.bookingDate,

        entryTime:
            widget.entryTime,

        exitTime:
            widget.exitTime,

        amount:
            widget.totalPrice,
      );

      setState(() {

        isLoading = false;
      });

      if (result["success"]) {

        String bookingId =
            result["booking_id"];

        showDialog(

          context: context,

          builder: (_) {

            return AlertDialog(

              backgroundColor:
                  const Color(0xFF1E293B),

              title: const Text(

                "Payment Successful",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              content: const Text(

                "Your parking slot has been booked successfully.",

                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);

                    Navigator.pushReplacement(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            BookingSuccessScreen(

  bookingId:
      bookingId,

  parkingName:
      widget.parkingName,

  slot:
      widget.slot,

  vehicleNumber:
      widget.vehicleNumber,

  bookingDate:
      widget.bookingDate,

  entryTime:
      widget.entryTime,

  exitTime:
      widget.exitTime,

  latitude:
      widget.latitude,

  longitude:
      widget.longitude,
)
                      ),
                    );
                  },

                  child: const Text(

                    "OK",

                    style: TextStyle(
                      color:
                          Color(0xFF38BDF8),
                    ),
                  ),
                ),
              ],
            );
          },
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            backgroundColor: Colors.red,

            content:
                Text(result["message"]),
          ),
        );
      }

    } catch (e) {

      setState(() {

        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor: Colors.red,

          content:
              Text("Error: $e"),
        ),
      );
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

          "Payment",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color:
                      Colors.white.withOpacity(0.08),

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Row(

                      children: [

                        Icon(

                          Icons.receipt_long,

                          color:
                              Color(0xFF38BDF8),
                        ),

                        SizedBox(width: 10),

                        Text(

                          "Booking Summary",

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    buildRow(
                      "Parking",
                      widget.parkingName,
                    ),

                    buildRow(
                      "Slot",
                      widget.slot,
                    ),

                    buildRow(
                      "Vehicle",
                      widget.vehicleNumber,
                    ),

                    buildRow(
                      "Date",
                      widget.bookingDate,
                    ),

                    buildRow(
                      "Entry Time",
                      widget.entryTime,
                    ),

                    buildRow(
                      "Exit Time",
                      widget.exitTime,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(30),

                decoration: BoxDecoration(

                  gradient:
                      const LinearGradient(

                    colors: [

                      Color(0xFF38BDF8),

                      Color(0xFF2563EB),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(24),
                ),

                child: Column(

                  children: [

                    const Text(

                      "Total Amount",

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(

                      "₹${widget.totalPrice.toStringAsFixed(2)}",

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 40,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(

                      "Demo Payment Mode",

                      style: TextStyle(

                        color: Colors.white70,
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
                        const Color(
                            0xFF38BDF8),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                              18),
                    ),
                  ),

                  onPressed:
                      isLoading
                          ? null
                          : processPayment,

                  child: isLoading

                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )

                      : const Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [

                            Icon(

                              Icons.payment,

                              color:
                                  Colors.white,
                            ),

                            SizedBox(width: 10),

                            Text(

                              "Pay Now",

                              style: TextStyle(

                                fontSize: 18,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Colors.white,
                              ),
                            ),
                          ],
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
          const EdgeInsets.only(bottom: 18),

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