import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/bottomNavigationBar_widget.dart';

class NormalSettingScreen extends StatefulWidget {
  const NormalSettingScreen({super.key});

  @override
  State<NormalSettingScreen> createState() => _NormalSettingScreenState();
}

class _NormalSettingScreenState extends State<NormalSettingScreen> {
  int? _selectedValue = 0;
  bool _isToggled = false;
  late int _currentIndex = 0;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedValue = value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 73,
            ),
            const Text(
              'Connection Mode',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFDBD2D1),
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text(
                  'OpenVPN',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Radio<int>(
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: _handleRadioValueChange,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'IPSec',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Radio<int>(
                  value: 0,
                  groupValue: _selectedValue,
                  onChanged: _handleRadioValueChange,
                ),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                const Text(
                  'ISSR',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/images/crown.svg',
                  height: 15,
                  width: 16.67,
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            const SizedBox(height: 16,),
            const Center(
              child: SizedBox(
                width: 420,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 8),
                  child: Divider(
                    color: Color(0xFFDBD2D1),
                    thickness: 1,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Text(
                  'Kill Switch',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDBD2D1),
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/images/crown.svg',
                  height: 15,
                  width: 16.67,
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  'Block internet when connecting or \nchanging servers',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8, // Adjust the scale factor to resize the Switch
                  child: Switch(
                    value: _isToggled,
                    onChanged: (bool value) {
                      setState(() {
                        _isToggled = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: SizedBox(
                width: 420,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 8),
                  child: Divider(
                    color: Color(0xFFDBD2D1),
                    thickness: 1,
                  ),
                ),
              ),
            ),
            const Row(
              children: [
                Text(
                  'Connection',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDBD2D1),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  'Connect when Prime VPN starts',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8, // Adjust the scale factor to resize the Switch
                  child: Switch(
                    value: _isToggled,
                    onChanged: (bool value) {
                      setState(() {
                        _isToggled = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Connection duration boost',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8, // Adjust the scale factor to resize the Switch
                  child: Switch(
                    value: _isToggled,
                    onChanged: (bool value) {
                      setState(() {
                        _isToggled = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: SizedBox(
                width: 420,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 8),
                  child: Divider(
                    color: Color(0xFFDBD2D1),
                    thickness: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              children: [
                Text(
                  'Notification',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDBD2D1),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const Text(
                  'Show notification when Prime VPN is \nnot connected ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8, // Adjust the scale factor to resize the Switch
                  child: Switch(
                    value: _isToggled,
                    onChanged: (bool value) {
                      setState(() {
                        _isToggled = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            const Center(
              child: SizedBox(
                width: 420,
                child: Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 8),
                  child: Divider(
                    color: Color(0xFFDBD2D1),
                    thickness: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text(
              'Account',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFDBD2D1),
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const Spacer(),
                const SizedBox(
                  height: 44,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {},
                ),
                const SizedBox(width: 16,)
              ],
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
