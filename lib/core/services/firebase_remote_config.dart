import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/config.dart';
import '../../injection_container.dart';
import '../constants/app_constants.dart';

class FirebaseRemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<FirebaseRemoteConfigService> init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Config.debug
            ? const Duration(seconds: 5)
            : const Duration(hours: 1),
      ),
    );

    final packageInfo = sl<PackageInfo>();
    await remoteConfig.setDefaults(Config.debug
        ? {
            AppConstants.requiredMinimumVersionDebug: packageInfo.version,
            AppConstants.recommendedMinimumVersionDebug: packageInfo.version,
          }
        : Platform.isIOS
            ? {
                AppConstants.requiredMinimumVersion: packageInfo.version,
                AppConstants.recommendedMinimumVersion: packageInfo.version,
              }
            : {
                AppConstants.requiredMinimumVersionAndroid: packageInfo.version,
                AppConstants.recommendedMinimumVersionAndroid:
                    packageInfo.version,
              });

    try {
      await remoteConfig.fetchAndActivate();

      remoteConfig.onConfigUpdated.listen((event) async {
        await remoteConfig.activate();
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    return this;
  }

  String getRequiredMinimumVersion() => remoteConfig.getString(Config.debug
      ? AppConstants.requiredMinimumVersionDebug
      : Platform.isIOS
          ? AppConstants.requiredMinimumVersion
          : AppConstants.requiredMinimumVersionAndroid);

  String getRecommendedMinimumVersion() => remoteConfig.getString(Config.debug
      ? AppConstants.recommendedMinimumVersionDebug
      : Platform.isIOS
          ? AppConstants.recommendedMinimumVersion
          : AppConstants.recommendedMinimumVersionAndroid);
}
