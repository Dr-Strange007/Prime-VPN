import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/bottomNavigationBar_widget.dart';

class ConnectedDeviceScreen extends StatefulWidget {
  const ConnectedDeviceScreen({super.key});

  @override
  State<ConnectedDeviceScreen> createState() => _ConnectedDeviceScreenState();
}

class _ConnectedDeviceScreenState extends State<ConnectedDeviceScreen> {
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
            const SizedBox(height: 70,),
            const Text(
              '1/4',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 70),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:  Colors.black, width: 2),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/mobile.svg',
                  height: 70,
                  width: 70,
                ),
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
