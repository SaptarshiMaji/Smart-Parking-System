import 'package:url_launcher/url_launcher.dart';

class MapService {

  static Future<void> openGoogleMaps({

    required double latitude,

    required double longitude,
  }) async {

    final Uri googleMapUrl = Uri.parse(

      "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving",
    );

    if (await canLaunchUrl(
      googleMapUrl,
    )) {

      await launchUrl(

        googleMapUrl,

        mode:
            LaunchMode.externalApplication,
      );

    } else {

      throw 'Could not open Google Maps';
    }
  }
}