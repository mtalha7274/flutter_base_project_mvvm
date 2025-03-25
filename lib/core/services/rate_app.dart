import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

import '../../config/config.dart';
import '../../main.dart';
import '../../viewmodels/providers/info_provider.dart';

Future<void> rateApp() async {
  if (Config.debug) return;

  final context = navigatorKey.currentContext;
  if (context == null) return;

  final infoStore = context.read<InfoProvider>();
  if (infoStore.rateAppCount == 0) {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      infoStore.rateAppCount++;
      await inAppReview.requestReview();
    }
  }
}
