import 'package:flutter/material.dart';

class HelpSupportScreen
    extends StatelessWidget {

  const HelpSupportScreen({
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

          "Help & Support",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            supportCard(

              icon: Icons.email,

              title: "Email Support",

              subtitle:
                  "support@smartparking.com",
            ),

            supportCard(

              icon: Icons.phone,

              title: "Call Support",

              subtitle:
                  "+91 9876543210",
            ),

            supportCard(

              icon: Icons.help,

              title: "FAQ",

              subtitle:
                  "Common app questions",
            ),
          ],
        ),
      ),
    );
  }

  Widget supportCard({

    required IconData icon,

    required String title,

    required String subtitle,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
              bottom: 20),

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

            width: 60,

            height: 60,

            decoration: BoxDecoration(

              color: const Color(
                      0xFF38BDF8)
                  .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                      18),
            ),

            child: Icon(

              icon,

              color:
                  const Color(
                      0xFF38BDF8),
            ),
          ),

          const SizedBox(width: 18),

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

                    fontSize: 18,

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