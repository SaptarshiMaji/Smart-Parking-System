import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool darkMode = true;

  bool notifications = true;

  bool autoRefresh = true;

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

          "Settings",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          buildSwitchTile(

            title: "Dark Mode",

            subtitle:
                "Enable dark theme",

            value: darkMode,

            onChanged: (value) {

              setState(() {

                darkMode = value;
              });
            },
          ),

          buildSwitchTile(

            title: "Notifications",

            subtitle:
                "Receive booking alerts",

            value: notifications,

            onChanged: (value) {

              setState(() {

                notifications = value;
              });
            },
          ),

          buildSwitchTile(

            title: "Auto Refresh",

            subtitle:
                "Refresh booking data automatically",

            value: autoRefresh,

            onChanged: (value) {

              setState(() {

                autoRefresh = value;
              });
            },
          ),

          const SizedBox(height: 25),

          buildOption(

            icon: Icons.lock,

            title: "Privacy Policy",
          ),

          buildOption(

            icon: Icons.description,

            title: "Terms & Conditions",
          ),

          buildOption(

            icon: Icons.info,

            title: "About App",
          ),
        ],
      ),
    );
  }

  Widget buildSwitchTile({

    required String title,

    required String subtitle,

    required bool value,

    required Function(bool)
        onChanged,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
              bottom: 18),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: SwitchListTile(

        value: value,

        onChanged: onChanged,

        activeColor:
            const Color(0xFF38BDF8),

        title: Text(

          title,

          style: const TextStyle(

            color: Colors.white,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(

          subtitle,

          style: const TextStyle(

            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget buildOption({

    required IconData icon,

    required String title,
  }) {

    return Container(

      margin:
          const EdgeInsets.only(
              bottom: 18),

      decoration: BoxDecoration(

        color:
            Colors.white.withOpacity(
                0.08),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: ListTile(

        leading: Icon(

          icon,

          color:
              const Color(0xFF38BDF8),
        ),

        title: Text(

          title,

          style: const TextStyle(

            color: Colors.white,
          ),
        ),

        trailing: const Icon(

          Icons.arrow_forward_ios,

          color: Colors.white54,

          size: 16,
        ),
      ),
    );
  }
}