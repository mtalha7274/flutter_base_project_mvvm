import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/locale.dart';

class Language extends Equatable {
  final String name;
  final Locale locale;

  const Language({required this.name, required this.locale});

  @override
  List<Object?> get props => [name, locale];

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        name: json['name'], locale: SerializedLocale.fromJson(json['locale']));
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'locale': locale.toJson()};
  }
}
