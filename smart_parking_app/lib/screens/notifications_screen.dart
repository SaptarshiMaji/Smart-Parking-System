import 'package:flutter/material.dart';

class NotificationsScreen
    extends StatelessWidget {

  const NotificationsScreen({
    super.key,
  });

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

          "Notifications",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          notificationCard(

            title:
                "Booking Confirmed",

            subtitle:
                "Your slot S3 has been booked successfully.",
          ),

          notificationCard(

            title:
                "QR Verified",

            subtitle:
                "Your parking entry was successful.",
          ),

          notificationCard(

            title:
                "Booking Cancelled",

            subtitle:
                "Your booking has been cancelled.",
          ),
        ],
      ),
    );
  }

  Widget notificationCard({

    required String title,

    required String subtitle,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
              bottom: 18),

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

              color: const Color(
                      0xFF38BDF8)
                  .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                      16),
            ),

            child: const Icon(

              Icons.notifications,

              color:
                  Color(0xFF38BDF8),
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

                    color: Colors.white,

                    fontSize: 17,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(

                  subtitle,

                  style:
                      const TextStyle(

                    color:
                        Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}