// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_sdk/src/helper/payment_config.dart';
import 'package:khalti_sdk/src/helper/payment_preference.dart';
import 'package:khalti_sdk/src/payment_page.dart';

/// The [KhaltiScope] builder.
typedef KhaltiScopeBuilder = Widget Function(
  BuildContext,
  GlobalKey<NavigatorState>,
);

/// The widget that initializes Khalti Payment Gateway and handles received deeplink.
class KhaltiScope {
  /// Launches the Khalti Payment Gateway interface.
  static Future<void> pay({
    required PaymentConfig config,
    required BuildContext context,
    bool enabledDebugging = false,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
    VoidCallback? onCancel,
    List<PaymentPreference> preferences = PaymentPreference.values,
  }) async {
    Khalti.init(
        publicKey: config.publicKey, enabledDebugging: enabledDebugging);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(config: config, preferences: preferences),
        settings: const RouteSettings(name: '/kpg'),
      ),
    );

    if (result is PaymentSuccessModel) {
      onSuccess(result);
    } else if (result is PaymentFailureModel) {
      onFailure(result);
    } else {
      onCancel?.call();
    }
  }
}
