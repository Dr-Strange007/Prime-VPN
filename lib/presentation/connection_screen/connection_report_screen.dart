import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/database/database_helper.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/info_card_widget.dart';
import '../../widgets/rating_card_widget.dart';

class ConnectionReportScreen extends StatefulWidget {
  const ConnectionReportScreen({super.key});

  @override
  ConnectionReportScreenState createState() => ConnectionReportScreenState();
}

class ConnectionReportScreenState extends State<ConnectionReportScreen> {
  int _currentIndex = 0;
  String sessionDuration = "00:00:00";
  String dataUsed = "0 MB";
  String publicIP = "Unknown";

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;
    publicIP = arguments?['publicIP'] ?? "Unknown";
    fetchLastSessionData();
  }

  Future<void> fetchLastSessionData() async {
    final dbHelper = DatabaseHelper();
    final lastSession = await dbHelper.getLastSession();

    if (lastSession != null) {
      final startTime = lastSession['startTime'];
      final endTime = lastSession['endTime'];
      final dataUsedValue = lastSession['dataUsed'];


      // Calculate session duration
      final startDateTime = DateTime.parse(startTime);
      final endDateTime = DateTime.parse(endTime);
      final duration = endDateTime.difference(startDateTime);
      print('Data used $dataUsedValue');


      String formatDataUsage(int dataUsedKilobytes) {
        if (dataUsedKilobytes >= 1024) {
          // Convert kilobytes to megabytes (1 MB = 1024 KB)
          return "${(dataUsedKilobytes / 1024).toStringAsFixed(2)} MB";
        } else {
          // Keep it as kilobytes if less than 1 MB
          return "$dataUsedKilobytes KB";
        }
      }


      setState(() {
        sessionDuration =
            duration.toString().split('.').first; // Format: HH:mm:ss
        dataUsed = formatDataUsage(dataUsedValue);
      });
    } else {
      setState(() {
        sessionDuration = "No data";
        dataUsed = "No data";
      });
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300.85,
              color: const Color(0xFFF6C68C),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              height: 300.85,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/report_page_map.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Connection Report',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InfoCard(
                  duration: sessionDuration,
                  dataUsed: dataUsed,
                  publicIP: publicIP,
                ),
                const SizedBox(height: 30),
                const RatingCard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
