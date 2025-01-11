import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({super.key});

  // Function to launch the Play Store URL
  Future<void> _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.example.bdix_vpn';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL, // Opens the Play Store when the card is tapped
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.fromLTRB(37, 25, 37, 25),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enjoying BDX VPN?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you appreciate it, please give us 5 stars',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  onPressed: _launchURL,
                  icon: const Icon(
                    Icons.star_border,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
