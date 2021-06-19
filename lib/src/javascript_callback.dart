import 'dart:async';

import 'package:native_webview/src/webview_controller.dart';

typedef JsConfirmCallback = FutureOr<JsConfirmResponse> Function(
  WebViewController,
  String?,
);

typedef JsAlertCallback = FutureOr<JsAlertResponse> Function(
  WebViewController,
  String?,
);

typedef JsPromptCallback = FutureOr<JsPromptResponse> Function(
  WebViewController,
  String?,
  String?,
);

///JsConfirmResponseAction class used by [JsConfirmResponse] class.
enum JsConfirmResponseAction {
  ok,
  cancel,
}

///JsConfirmResponse class represents the response used by the [onJsConfirm] event to control a JavaScript confirm dialog.
class JsConfirmResponse {
  ///Message to be displayed in the window.
  final String? message;

  ///Title of the confirm button.
  final String? okLabel;

  ///Title of the cancel button.
  final String? cancelLabel;

  ///Whether the client will handle the confirm dialog.
  final bool handledByClient;

  ///Action used to confirm that the user hit confirm or cancel button.
  final JsConfirmResponseAction? action;

  JsConfirmResponse._(
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.handledByClient,
    this.action,
  );

  factory JsConfirmResponse.handled(JsConfirmResponseAction action) {
    return JsConfirmResponse._(null, null, null, true, action);
  }

  factory JsConfirmResponse.confirm(
    String message,
    String okLabel,
    String cancelLabel,
  ) {
    return JsConfirmResponse._(
      message,
      okLabel,
      cancelLabel,
      false,
      null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "okLabel": okLabel,
      "cancelLabel": cancelLabel,
      "handledByClient": handledByClient,
      "action": action?.index,
    };
  }
}

///JsAlertResponse class represents the response used by the [onJsAlert] event to control a JavaScript confirm dialog.
class JsAlertResponse {
  ///Message to be displayed in the window.
  final String? message;

  ///Title of the alert button.
  final String? okLabel;

  ///Whether the client will handle the alert dialog.
  final bool handledByClient;

  JsAlertResponse._(this.message, this.okLabel, this.handledByClient);

  factory JsAlertResponse.handled() {
    return JsAlertResponse._(null, null, true);
  }

  factory JsAlertResponse.alert(
    String message,
    String okLabel,
  ) {
    return JsAlertResponse._(
      message,
      okLabel,
      false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "okLabel": okLabel,
      "handledByClient": handledByClient,
    };
  }
}

enum JsPromptResponseAction {
  ok,
  cancel,
}

///JsPromptResponse class represents the response used by the [onJsPrompt] event to control a JavaScript prompt dialog.
class JsPromptResponse {
  ///Message to be displayed in the window.
  final String? message;

  ///The default value displayed in the prompt dialog.
  final String? defaultValue;

  ///Title of the confirm button.
  final String? okLabel;

  ///Title of the cancel button.
  final String? cancelLabel;

  ///Whether the client will handle the prompt dialog.
  final bool handledByClient;

  ///Action used to confirm that the user hit confirm or cancel button.
  final JsPromptResponseAction? action;

  ///Value of the prompt dialog.
  final String? value;

  factory JsPromptResponse.handled(
    JsPromptResponseAction action,
    String value,
  ) {
    return JsPromptResponse._(
      null,
      null,
      null,
      null,
      true,
      action,
      value,
    );
  }

  factory JsPromptResponse.prompt(
    String message,
    String defaultValue,
    String okLabel,
    String cancelLabel,
  ) {
    return JsPromptResponse._(
      message,
      defaultValue,
      okLabel,
      cancelLabel,
      false,
      null,
      null,
    );
  }

  JsPromptResponse._(
    this.message,
    this.defaultValue,
    this.okLabel,
    this.cancelLabel,
    this.handledByClient,
    this.action,
    this.value,
  );

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "defaultText": defaultValue,
      "okLabel": okLabel,
      "cancelLabel": cancelLabel,
      "handledByClient": handledByClient,
      "value": value,
      "action": action?.index
    };
  }
}
