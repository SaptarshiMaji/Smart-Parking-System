import 'dart:convert';
import 'session_manager.dart';
import 'package:http/http.dart'
    as http;

class ApiService {

  static const String baseUrl =
      "https://smart-parking-backend-4dum.onrender.com";

  // =========================
  // REGISTER USER
  // =========================

  static Future<Map<String, dynamic>>
      registerUser({

    required String name,

    required String email,

    required String phone,

    required String password,
  }) async {

    final response = await http.post(

      Uri.parse("$baseUrl/register"),

      headers: {

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "name": name,

        "email": email,

        "phone": phone,

        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // LOGIN USER
  // =========================

  static Future<Map<String, dynamic>>
      loginUser({

    required String email,

    required String password,
  }) async {

    final response = await http.post(

      Uri.parse("$baseUrl/login"),

      headers: {

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "email": email,

        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

// =========================
// FORGOT PASSWORD
// =========================

static Future<Map<String, dynamic>>
forgotPassword({

  required String email,

  required String newPassword,

}) async {

  final response =
      await http.post(

    Uri.parse(
      "$baseUrl/forgot_password",
    ),

    headers: {

      "Content-Type":
          "application/json",
    },

    body: jsonEncode({

      "email": email,

      "new_password":
          newPassword,
    }),
  );

  return jsonDecode(
      response.body);
}

// =========================
// GET PARKING SLOTS
// =========================

static Future<List<dynamic>>
getParkingSlots(
  String parkingName,
) async {

  final encodedName =
      Uri.encodeComponent(
        parkingName,
      );

  final response = await http.get(

    Uri.parse(
      "$baseUrl/parking_slots/$encodedName",
    ),
  );

  if (response.statusCode != 200) {

    throw Exception(
      "Failed to load slots: "
      "${response.statusCode}",
    );
  }

  final data =
      jsonDecode(response.body);

  return data["slots"];
}

static Future<List<dynamic>>
getParkingSummary() async {

  final response = await http.get(

    Uri.parse(
      "$baseUrl/parking_summary",
    ),
  );

  final data =
      jsonDecode(response.body);

  return data["data"];
}

  // =========================
  // CREATE BOOKING
  // =========================

  static Future<Map<String, dynamic>>
      createBooking({

    required String userEmail,

    required String parkingName,

    required String slot,

    required String vehicleNumber,

    required String bookingDate,

    required String entryTime,

    required String exitTime,

    required double amount,
  }) async {

    final response = await http.post(

      Uri.parse(
        "$baseUrl/create_booking",
      ),

      headers: {

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "user_email":
            userEmail,

        "parking_name":
            parkingName,

        "slot":
            slot,

        "vehicle_number":
            vehicleNumber,

        "booking_date":
            bookingDate,

        "entry_time":
            entryTime,

        "exit_time":
            exitTime,

        "amount":
            amount,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // GET BOOKINGS
  // =========================

  static Future<List<dynamic>>
  getBookings(
  String email,
  ) async {

  final response = await http.get(

    Uri.parse(
      "$baseUrl/bookings/$email",
    ),
  );

  final data =
      jsonDecode(response.body);

  return data["bookings"];
  }

  // =========================
  // GET ACTIVE BOOKING
  // =========================

  static Future<Map<String, dynamic>>
getActiveBooking(
  String email,
) async {

  final response =
      await http.get(

    Uri.parse(
      "$baseUrl/active_booking/$email",
    ),
  );

  return jsonDecode(
    response.body,
  );
}

  // =========================
  // GET PROFILE
  // =========================

  static Future<Map<String, dynamic>>
      getProfile(

    String email,
  ) async {

    final response = await http.get(

      Uri.parse(
        "$baseUrl/profile/$email",
      ),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  static Future<Map<String, dynamic>>
      updateProfile({

    required String email,

    required String name,

    required String phone,
  }) async {

    final response = await http.post(

      Uri.parse(
        "$baseUrl/update_profile",
      ),

      headers: {

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "email": email,

        "name": name,

        "phone": phone,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
// CANCEL BOOKING
// =========================

static Future<Map<String, dynamic>>
    cancelBooking(

  String bookingId,
) async {

  String email =
      await SessionManager
          .getUserEmail();

  final response = await http.post(

    Uri.parse(
      "$baseUrl/cancel_booking",
    ),

    headers: {

      "Content-Type":
          "application/json",
    },

    body: jsonEncode({

      "booking_id":
          bookingId,

      "user_email":
          email,
    }),
  );

  return jsonDecode(
    response.body,
  );
}
  // =========================
  // VALIDATE QR
  // =========================

  static Future<Map<String, dynamic>>
      validateQR(

    String bookingId,
  ) async {

    final response = await http.post(

      Uri.parse(
        "$baseUrl/validate_qr",
      ),

      headers: {

        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "booking_id":
            bookingId,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // RESET BOOKINGS
  // =========================

  static Future<Map<String, dynamic>>
      resetBookings() async {

    final response = await http.post(

      Uri.parse(
        "$baseUrl/reset_bookings",
      ),
    );

    return jsonDecode(response.body);
  }
}