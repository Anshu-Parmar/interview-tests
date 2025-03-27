import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:startopreneur/core/configs/constants/identifiers.dart';

class RateAppInitWidget {

  static Future<void> showReviewDialog(BuildContext context) async {
    final RateMyApp rateMyApp = RateMyApp(
      appStoreIdentifier: Identifiers.appStoreId,
      googlePlayIdentifier: Identifiers.playStoreId,
    );

    rateMyApp.launchStore();
  }
}
