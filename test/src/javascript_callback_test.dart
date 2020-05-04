import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/src/javascript_callback.dart';

void main() {
  group("JsConfirm", () {
    test("confirm", () async {
      final map = JsConfirmResponse.confirm("Message", "OK", "CANCEL").toMap();
      expect(map, {
        'message': 'Message',
        'okLabel': 'OK',
        'cancelLabel': 'CANCEL',
        'handledByClient': false,
        'action': null
      });
    });

    test("handled", () async {
      final map = JsConfirmResponse.handled(JsConfirmResponseAction.ok).toMap();
      expect(map, {
        'message': null,
        'okLabel': null,
        'cancelLabel': null,
        'handledByClient': true,
        'action': JsConfirmResponseAction.ok.index,
      });
    });
  });

  group("JsAlert", () {
    test("alert", () async {
      final map = JsAlertResponse.alert("Message", "OK").toMap();
      expect(map, {
        'message': 'Message',
        'okLabel': 'OK',
        'handledByClient': false,
      });
    });

    test("handled", () async {
      final map = JsAlertResponse.handled().toMap();
      expect(map, {
        'message': null,
        'okLabel': null,
        'handledByClient': true,
      });
    });
  });

  group("JsPrompt", () {
    test("prompt", () async {
      final map = JsPromptResponse.prompt(
        "Message",
        "DefaultText",
        "OK",
        "CANCEL",
      ).toMap();

      expect(map, {
        "message": "Message",
        "defaultText": "DefaultText",
        "okLabel": "OK",
        "cancelLabel": "CANCEL",
        "handledByClient": false,
        "value": null,
        "action": null,
      });
    });

    test("handled", () async {
      final map = JsPromptResponse.handled(
        JsPromptResponseAction.ok,
        "value",
      ).toMap();

      expect(map, {
        "message": null,
        "defaultText": null,
        "okLabel": null,
        "cancelLabel": null,
        "handledByClient": true,
        "value": "value",
        "action": JsPromptResponseAction.ok.index,
      });
    });
  });
}
