import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:url_launcher/url_launcher.dart';

import '../services/session_manager.dart';
import '../services/api_service.dart';
import 'parking_details_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
      Timer? refreshTimer;

  List<Map<String, dynamic>>
      parkingLocations = [];

  List<Map<String, dynamic>>
      filteredLocations = [];

  bool isLoading = true;

  String userName = "User";

  double userLat = 0;

  double userLng = 0;

  final TextEditingController
      searchController =
      TextEditingController();

 @override
void initState() {

  super.initState();

  Future.microtask(() async {

    if (!mounted) return;

    await loadData();

    if (!mounted) return;

    await loadParkingSummary();
  });

  refreshTimer = Timer.periodic(

    const Duration(seconds: 5),

    (_) async {

      if (!mounted) return;

      await loadParkingSummary();
    },
  );
}
  Future<void> loadData() async {

  await Future.wait([

    loadUser(),

    getUserLocation(),
  ]);

  loadParkingLocations();
  await updateSlotCounts();
  calculateDistances();

  if (mounted) {

    setState(() {

      isLoading = false;
    });
  }
}
Future<void> updateSlotCounts() async {
if (!mounted) return;
  for (var parking in parkingLocations) {

    try {

      final slots =
          await ApiService.getParkingSlots(

        parking["name"],
      );

      int available =
          slots.where((slot) {

        return slot["status"] ==
            "available";

      }).length;

      parking["slots"] =
          available;

    } catch (e) {

      debugPrint(
        e.toString(),
      );
    }
  }

  if (!mounted) return;

setState(() {});
}
  Future<void> loadUser() async {

    String name =
        await SessionManager.getUserName();

    if (mounted) {

      setState(() {

        userName = name;
      });
    }
  }

  Future<void> getUserLocation() async {

  bool serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

  if (!serviceEnabled) {

    return;
  }

  LocationPermission permission =
      await Geolocator.checkPermission();

  if (permission ==
      LocationPermission.denied) {

    permission =
        await Geolocator.requestPermission();
  }

  if (permission ==
          LocationPermission.denied ||

      permission ==
          LocationPermission.deniedForever) {

    return;
  }

  Position? position =
      await Geolocator
          .getLastKnownPosition();

  position ??=
      await Geolocator
          .getCurrentPosition(

        desiredAccuracy:
            LocationAccuracy.medium,
      );

  userLat = position.latitude;

  userLng = position.longitude;
}

  void loadParkingLocations() {

  parkingLocations = [

    {
      "name": "Junction Mall Parking",
      "location": "City Center, Durgapur",
      "lat": 23.539286625144108,
      "lng": 87.29096886112114,
      "rating": "4.8",
      "price": "₹50/hr",
      "slots": 0,
    },

    {
      "name": "Benachity Parking Hub",
      "location": "Benachity, Durgapur",
      "lat": 23.56466138571083,
      "lng": 87.28316271021974,
      "rating": "4.5",
      "price": "₹40/hr",
      "slots": 0,
    },

    {
      "name": "Durgapur Station Parking",
      "location": "Durgapur Railway Station",
      "lat": 23.49416685645393,
      "lng": 87.31763585029516,
      "rating": "4.7",
      "price": "₹60/hr",
      "slots": 0,
    },

    {
      "name": "B-Zone Smart Parking",
      "location": "B-Zone, Durgapur",
      "lat": 23.563243,
      "lng": 87.313181,
      "rating": "4.6",
      "price": "₹45/hr",
      "slots": 0,
    },

    {
      "name": "City Centre Bus Stand Parking",
      "location": "City Centre Bus Stand, Durgapur",
      "lat": 23.535705936628375,
      "lng": 87.29760206503896,
      "rating": "4.4",
      "price": "₹35/hr",
      "slots": 0,
    },

    {
      "name": "Muchipara Parking Plaza",
      "location": "Muchipara, Durgapur",
      "lat": 23.504255369861234,
      "lng": 87.353146381274,
      "rating": "4.3",
      "price": "₹30/hr",
      "slots": 0,
    },
  ];

  filteredLocations =
      List.from(parkingLocations);
}

Future<void> loadParkingSummary() async {
if (!mounted) return;
  try {

    final summary =
        await ApiService.getParkingSummary();

    for (var parking in parkingLocations) {

      final match = summary.cast<Map<String, dynamic>>().firstWhere(

  (item) =>
      item["parking_name"] ==
      parking["name"],

  orElse: () => {},
);

      if (match.isNotEmpty) {

  parking["slots"] =
      match["available"];
}
    }
    if (!mounted) return;
    setState(() {

      filteredLocations =
          List.from(parkingLocations);
    });

  } catch (e) {

    debugPrint(
      "Parking summary error: $e",
    );
  }
}



  void calculateDistances() {

    for (var parking in parkingLocations) {

      double distance =

    (userLat == 0 &&
            userLng == 0)

        ? 0

        : Geolocator.distanceBetween(

            userLat,

            userLng,

            parking["lat"],

            parking["lng"],
          );

      parking["distance"] =
          "${(distance / 1000).toStringAsFixed(1)} km";
    }

    parkingLocations.sort(

      (a, b) {

        double distA =
            double.parse(

          a["distance"]
              .replaceAll(" km", ""),
        );

        double distB =
            double.parse(

          b["distance"]
              .replaceAll(" km", ""),
        );

        return distA.compareTo(distB);
      },
    );

    filteredLocations =
        List.from(parkingLocations);
  }

  void searchParking(String value) {

    if (!mounted) return;

    setState(() {

      filteredLocations =
          parkingLocations.where((parking) {

        return parking["location"]

            .toString()

            .toLowerCase()

            .contains(

              value.toLowerCase(),
            ) ||

            parking["name"]

                .toString()

                .toLowerCase()

                .contains(

                  value.toLowerCase(),
                );

      }).toList();
    });
  }

  Future<void> openMap(

    double lat,

    double lng,
  ) async {

    final Uri url = Uri.parse(

      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    await launchUrl(

      url,

      mode:
          LaunchMode.externalApplication,
    );
  }

@override
void dispose() {

  refreshTimer?.cancel();

  searchController.dispose();

  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF06122B),

      body: SafeArea(

        child: isLoading

            ? const Center(

                child:
                    CircularProgressIndicator(),
              )

            : RefreshIndicator(

                onRefresh: loadData,

                child: SingleChildScrollView(

                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  padding:
                      const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      // ================= HEADER =================

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  "Hello, $userName 👋",

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      const TextStyle(

                                    color:
                                        Colors.white,

                                    fontSize: 30,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 8),

                                const Text(

                                  "Find nearby smart parking",

                                  style: TextStyle(

                                    color:
                                        Colors.white70,

                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(

                            padding:
                                const EdgeInsets
                                    .all(14),

                            decoration:
                                BoxDecoration(

                              color: Colors.white
                                  .withOpacity(
                                      0.08),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                            ),

                            child: const Icon(

                              Icons.notifications,

                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      // ================= SEARCH =================

                      TextField(

                        controller:
                            searchController,

                        onChanged:
                            searchParking,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              "Search parking location",

                          hintStyle:
                              const TextStyle(

                            color:
                                Colors.white54,
                          ),

                          prefixIcon:
                              const Icon(

                            Icons.search,

                            color:
                                Colors.white70,
                          ),

                          filled: true,

                          fillColor:
                              Colors.white
                                  .withOpacity(
                                      0.08),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        20),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      const Text(

                        "Nearest Parking",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 26,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Column(

                        children:
                            filteredLocations.map(

                          (parking) {

                            return Padding(

                              padding:
                                  const EdgeInsets
                                      .only(

                                bottom: 22,
                              ),

                              child:
                                  buildParkingCard(

                                context,

                                parking,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildParkingCard(

    BuildContext context,

    Map<String, dynamic> parking,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(0.08),

        borderRadius:
            BorderRadius.circular(26),
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

                  parking["name"],

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 24,

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

                  color: Colors.green
                      .withOpacity(0.2),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: Text(

                  "${parking["slots"]} Slots",

                  style: const TextStyle(

                    color: Colors.green,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(

            children: [

              const Icon(

                Icons.location_on,

                color: Colors.white70,

                size: 18,
              ),

              const SizedBox(width: 5),

              Text(

                parking["distance"],

                style: const TextStyle(

                  color: Colors.white70,
                ),
              ),

              const SizedBox(width: 18),

              const Icon(

                Icons.star,

                color: Colors.amber,

                size: 18,
              ),

              const SizedBox(width: 5),

              Text(

                parking["rating"],

                style: const TextStyle(

                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(

            parking["location"],

            style: const TextStyle(

              color: Colors.white60,

              fontSize: 15,
            ),
          ),

          const SizedBox(height: 28),

          Wrap(

            spacing: 12,

            runSpacing: 12,

            children: [

              Text(

                parking["price"],

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Row(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.white
                              .withOpacity(
                                  0.1),
                    ),

                    onPressed: () {

                      openMap(

                        parking["lat"],

                        parking["lng"],
                      );
                    },

                    child: const Text(

                      "Navigate",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(
                              0xFF18C8FF),
                    ),

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              ParkingDetailsScreen(

  parkingName:
      parking["name"],

  latitude:
      parking["lat"],

  longitude:
      parking["lng"],
)
                        ),
                      );
                    },

                    child: const Text(

                      "Book Now",

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}