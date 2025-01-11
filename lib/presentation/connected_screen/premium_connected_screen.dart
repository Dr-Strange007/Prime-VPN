import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/connection_request_widgets.dart';
import '../../widgets/disconnect_dialog_box.dart';

class PremiumConnectedScreen extends StatefulWidget {
  const PremiumConnectedScreen({super.key});

  @override
  State<PremiumConnectedScreen> createState() => _PremiumConnectedScreenState();
}

class _PremiumConnectedScreenState extends State<PremiumConnectedScreen> {
  late int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Device'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            const Text(
              '1/4',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 58),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/mobile.svg',
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/desktop_image.svg',
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
