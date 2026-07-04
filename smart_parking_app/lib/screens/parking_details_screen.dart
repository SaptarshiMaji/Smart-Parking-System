import 'package:flutter/material.dart';

import '../services/api_service.dart';

import 'payment_screen.dart';

class ParkingDetailsScreen extends StatefulWidget {

  final String parkingName;
  final double latitude;
final double longitude;

  const ParkingDetailsScreen({

  super.key,

  required this.parkingName,

  required this.latitude,

  required this.longitude,
});

  @override
  State<ParkingDetailsScreen> createState() =>
      _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState
    extends State<ParkingDetailsScreen> {

  List<dynamic> parkingSlots = [];

  bool isLoading = true;

  String selectedSlot = "";

  final TextEditingController
      vehicleNumberController =
      TextEditingController();

  final TextEditingController
      vehicleModelController =
      TextEditingController();

  String selectedVehicleType = "SUV";

  String entryTime =
      "Select Entry Time";

  String exitTime =
      "Select Exit Time";

  String selectedDate =
      "Select Date";

  double hourlyRate = 50;

  double totalPrice = 0;

  @override
  void initState() {

    super.initState();

    loadSlots();
  }

  Future<void> loadSlots() async {

  try {

    final slots =
        await ApiService.getParkingSlots(

      widget.parkingName,
    );

    setState(() {

      parkingSlots = slots;

      isLoading = false;
    });

  } catch (e) {

    debugPrint(
      e.toString(),
    );

    setState(() {

      isLoading = false;
    });
  }
}

  void calculatePrice() {

    try {

      if (entryTime.contains("Select") ||
          exitTime.contains("Select")) {

        return;
      }

      List<String> entryParts =
          entryTime.split(":");

      List<String> exitParts =
          exitTime.split(":");

      int entryHour =
          int.parse(entryParts[0]);

      int entryMinute =
          int.parse(

        entryParts[1]
            .replaceAll(
                RegExp(r'[^0-9]'),
                ''),
      );

      int exitHour =
          int.parse(exitParts[0]);

      int exitMinute =
          int.parse(

        exitParts[1]
            .replaceAll(
                RegExp(r'[^0-9]'),
                ''),
      );

      int entryTotalMinutes =
          (entryHour * 60) +
              entryMinute;

      int exitTotalMinutes =
          (exitHour * 60) +
              exitMinute;

      int differenceMinutes =
          exitTotalMinutes -
              entryTotalMinutes;

      if (differenceMinutes <= 0) {

        differenceMinutes = 60;
      }

      double hours =
          differenceMinutes / 60;

      setState(() {

        totalPrice =
            hours * hourlyRate;
      });

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        title: const Text(

          "Parking Details",

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

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // =========================
                  // TOP CARD
                  // =========================

                  Container(

                    height: 220,

                    decoration: BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                              25),

                      gradient:
                          const LinearGradient(

                        colors: [

                          Color(0xFF38BDF8),

                          Color(0xFF2563EB),
                        ],
                      ),
                    ),

                    child: const Center(

                      child: Icon(

                        Icons.local_parking,

                        size: 100,

                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(

                    widget.parkingName,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // =========================
                  // SLOT SELECTION
                  // =========================

                  const Text(

                    "Select Parking Slot",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GridView.builder(

                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount:
                        parkingSlots.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 4,

                      crossAxisSpacing: 15,

                      mainAxisSpacing: 15,

                      childAspectRatio: 0.7,
                    ),

                    itemBuilder:
                        (context, index) {

                      final slot =
                          parkingSlots[index];

                      bool occupied =
                          slot["status"] ==
                              "occupied";

                      bool isSelected =
                          selectedSlot ==
                              slot[
                                  "slot_number"];

                      return GestureDetector(

                        onTap: occupied

                            ? null

                            : () {

                                setState(() {

                                  selectedSlot =
                                      slot[
                                          "slot_number"];
                                });
                              },

                        child: Container(

                          decoration:
                              BoxDecoration(

                            color: occupied

                                ? Colors.red
                                    .withOpacity(
                                        0.2)

                                : isSelected

                                    ? const Color(
                                            0xFF38BDF8)
                                        .withOpacity(
                                            0.3)

                                    : Colors.green
                                        .withOpacity(
                                            0.2),

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        18),

                            border:
                                Border.all(

                              color: occupied

                                  ? Colors.red

                                  : isSelected

                                      ? const Color(
                                          0xFF38BDF8)

                                      : Colors.green,

                              width: 2,
                            ),
                          ),

                          child: Column(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(

                                Icons
                                    .local_parking,

                                size: 38,

                                color: occupied

                                    ? Colors.red

                                    : isSelected

                                        ? const Color(
                                            0xFF38BDF8)

                                        : Colors.green,
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(

                                slot[
                                    "slot_number"],

                                style: TextStyle(

                                  color: occupied

                                      ? Colors.red

                                      : Colors
                                          .white,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  // =========================
                  // VEHICLE TYPE
                  // =========================

                  DropdownButtonFormField<String>(

                    value:
                        selectedVehicleType,

                    dropdownColor:
                        const Color(
                            0xFF1E293B),

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        inputDecoration(
                      "Vehicle Type",
                    ),

                    items: [

                      "SUV",

                      "Sedan",

                      "Hatchback",
                    ].map((type) {

                      return DropdownMenuItem(

                        value: type,

                        child: Text(type),
                      );
                    }).toList(),

                    onChanged: (value) {

                      setState(() {

                        selectedVehicleType =
                            value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // VEHICLE MODEL
                  // =========================

                  TextField(

                    controller:
                        vehicleModelController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        inputDecoration(
                      "Vehicle Model",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // VEHICLE NUMBER
                  // =========================

                  TextField(

                    controller:
                        vehicleNumberController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        inputDecoration(
                      "Vehicle Number",
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =========================
                  // ENTRY TIME
                  // =========================

                  GestureDetector(

                    onTap: () async {

                      TimeOfDay? picked =
                          await showTimePicker(

                        context: context,

                        initialTime:
                            TimeOfDay.now(),
                      );

                      if (picked != null) {

                        setState(() {

                          entryTime =
                              "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
                        });

                        calculatePrice();
                      }
                    },

                    child: buildTimeBox(

                      "Entry Time",

                      entryTime,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // EXIT TIME
                  // =========================

                  GestureDetector(

                    onTap: () async {

                      TimeOfDay? picked =
                          await showTimePicker(

                        context: context,

                        initialTime:
                            TimeOfDay.now(),
                      );

                      if (picked != null) {

                        setState(() {

                          exitTime =
                              "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
                        });

                        calculatePrice();
                      }
                    },

                    child: buildTimeBox(

                      "Exit Time",

                      exitTime,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // DATE
                  // =========================

                  GestureDetector(

                    onTap: () async {

                      DateTime? picked =
                          await showDatePicker(

                        context: context,

                        firstDate:
                            DateTime.now(),

                        lastDate:
                            DateTime(2030),

                        initialDate:
                            DateTime.now(),
                      );

                      if (picked != null) {

                        setState(() {

                          selectedDate =
                              "${picked.day}/${picked.month}/${picked.year}";
                        });
                      }
                    },

                    child: buildTimeBox(

                      "Booking Date",

                      selectedDate,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // =========================
                  // PRICE
                  // =========================

                  Container(

                    padding:
                        const EdgeInsets.all(
                            20),

                    decoration: BoxDecoration(

                      color: Colors.white
                          .withOpacity(0.08),

                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        const Text(

                          "Total Price",

                          style: TextStyle(

                            color:
                                Colors.white70,
                          ),
                        ),

                        Text(

                          "₹${totalPrice.toStringAsFixed(2)}",

                          style: const TextStyle(

                            color: Colors.white,

                            fontSize: 28,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // PAYMENT BUTTON
                  // =========================

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
                              BorderRadius
                                  .circular(
                                      18),
                        ),
                      ),

                      onPressed: () {

                        if (selectedSlot
                            .isEmpty) {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(

                            const SnackBar(

                              content: Text(

                                "Select parking slot",
                              ),
                            ),
                          );

                          return;
                        }

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                PaymentScreen(

                              parkingName:
                                  widget
                                      .parkingName,

                              slot:
                                  selectedSlot,

                              vehicleNumber:
                                  vehicleNumberController
                                      .text,

                              bookingDate:
                                  selectedDate,

                              entryTime:
                                  entryTime,

                              exitTime:
                                  exitTime,

                              totalPrice:
                                  totalPrice,
                              latitude:
                                  widget.latitude,

                              longitude:
                                  widget.longitude,
                            ),
                          ),
                        );
                      },

                      child: const Text(

                        "Proceed To Payment",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  InputDecoration inputDecoration(
      String hint) {

    return InputDecoration(

      hintText: hint,

      hintStyle: const TextStyle(
        color: Colors.white54,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.08),

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),
    );
  }

  Widget buildTimeBox(

    String title,

    String value,
  ) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(0.08),

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 18,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}