import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

KeyboardActionsConfig keyboardActionbuildConfig(
    BuildContext context, List<FocusNode> nodes) {
  return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: nodes
          .map((node) => KeyboardActionsItem(
              focusNode: node, displayDoneButton: true, displayArrows: false))
          .toList());
}
