import 'package:bdix_vpn/service/token_service.dart';
import 'package:bdix_vpn/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/scaffold_messenger_utils.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  final UserService _userService = UserService();
  final TokenService _tokenService = TokenService();
  Future<void> _startPayment(String amount, String plan) async {
    try {
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          ipn_url: "your_ipn_url_here",
          multi_card_name: "visa,master,bkash",
          currency: SSLCurrencyType.BDT,
          product_category: "VPN Subscription",
          sdkType: SSLCSdkType.TESTBOX, // Change to LIVE in production
          store_id: "testbox",
          store_passwd: "qwerty",
          total_amount: double.parse(amount),
          tran_id: "txn_${DateTime.now().millisecondsSinceEpoch}",
        ),
      );

      SSLCTransactionInfoModel result = await sslcommerz.payNow();
      print("Payment result: ${result.toJson()}");

      if (result.status == "VALID") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Successful for $plan!"),
        ));

        // Make API request after successful payment
        await _sendSubscriptionRequest(plan);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Failed for $plan!"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
      ));
    }
  }

  Future<void> _sendSubscriptionRequest(String plan) async {
    final String? baseUrl = dotenv.env['BASE_URL'];
    final String apiUrl = "$baseUrl/api/v1/premium-user/create";
    final token = await _tokenService.getToken();
    final userId = await _tokenService.decodeUserId();
    print(" ki obostha $userId");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "userId": userId,
          "subscriptionType": plan,
          "resellerReference": "673df4d593a528af9869a8ec",
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Subscription activated for $plan!"),

        ));
        showScaffoldMessage(context, "Login again to get premium access");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.statusCode} Failed to activate subscription: ${response.body}"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 7),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/subscription_icon.svg',
                  height: 231.83,
                  width: 211.67,
                ),
                SvgPicture.asset(
                  'assets/images/subscription_crown.svg',
                  height: 90.22,
                  width: 80.87,
                ),
              ],
            ),
          ),
          const SizedBox(height: 27.17),
          const Text(
            'Upgrade to PRO',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Access To Every Country \nCancel Anytime ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8A8A8A),
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureRow('No Adds'),
          _buildFeatureRow('Faster Connection'),
          _buildFeatureRow('Worldwide Location'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPlanButton(
                  label: "1 month",
                  price: "BDT 1000/month",
                  amount: "1000",
                ),
                const SizedBox(height: 10),
                _buildPlanButton(
                  label: "1 year",
                  price: "BDT 4000/year",
                  amount: "4000",
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      backgroundColor: const Color(0xFFF2F2F2),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Try Premium Free',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '7 days free Trial. Then BDT 1000/month',
                  style: TextStyle(fontSize: 10, color: Color(0xFF545454)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Row(
      children: [
        const SizedBox(width: 160),
        SvgPicture.asset(
          'assets/images/done_icon.svg',
          height: 18,
          width: 18,
        ),
        const SizedBox(width: 8),
        Text(feature, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPlanButton({
    required String label,
    required String price,
    required String amount,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF9396BA),
            ],
            stops: [0.0, 0.7],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          onPressed: () => _startPayment(amount, label),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(color: Color(0xFFFEFEFE), fontSize: 12),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}