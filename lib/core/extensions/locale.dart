import 'package:flutter/material.dart';

extension SerializedLocale on Locale {
  Map<String, String> toJson() => {
        'languageCode': languageCode,
        'countryCode': countryCode ?? '',
      };

  static Locale fromJson(Map<String, dynamic> json) {
    return Locale(
      json['languageCode'] ?? '',
      json['countryCode']?.isEmpty ?? true ? null : json['countryCode'],
    );
  }
}
