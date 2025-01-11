import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;

  void loadRewardedAd({required VoidCallback onAdLoaded, required VoidCallback onAdFailed}) {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          print('Ad failed to load: $error'); // Log the error
          _rewardedAd = null; // Ensure it's reset
          onAdFailed();
        },
      ),
    );
  }

  void showRewardedAd({
    required BuildContext context,
    required VoidCallback onRewardEarned,
  }) {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad not ready yet!')),
      );

    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        onRewardEarned();
      },
    );

  }
}
