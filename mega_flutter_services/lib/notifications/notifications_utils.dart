import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationUtils {
  static Future<void> configure({
    @required String appKey,
    @required Function(String) onUserId,
  }) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(appKey, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false,
      OSiOSSettings.inFocusDisplayOption: true
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setSubscriptionObserver((changes) {
      onUserId(changes.to.userId);
      print('=============== ONE SIGNAL LOG ===============');
      print('UserId: ${changes.to.userId}');
      print('==============================================');
    });

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }
}
