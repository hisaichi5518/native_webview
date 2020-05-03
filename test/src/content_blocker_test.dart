import 'package:flutter_test/flutter_test.dart';
import 'package:native_webview/src/content_blocker.dart';

void main() {
  group("ContentBlocker", () {
    test("toMap", () async {
      final blocker = ContentBlocker(
        action: ContentBlockerAction.block(),
        trigger: ContentBlockerTrigger(urlFilter: "."),
      );

      expect(blocker.toMap(), {
        'trigger': {'url-filter': '.', 'url-filter-is-case-sensitive': false},
        'action': {'type': 'block'}
      });
    });

    test("fromMap", () async {
      final map = {
        'trigger': {'url-filter': '.', 'url-filter-is-case-sensitive': false},
        'action': {'type': 'block'}
      };
      final blocker = ContentBlocker.fromMap(map);

      expect(blocker.toMap(), map);
    });
  });

  group("ContentBlockerAction", () {
    test("block().toMap()", () async {
      final action = ContentBlockerAction.block();
      expect(action.toMap(), {'type': 'block'});
    });
    test("cssDisplayNone().toMap()", () async {
      final action = ContentBlockerAction.cssDisplayNone("*");
      expect(action.toMap(), {'type': 'css-display-none', 'selector': '*'});
    });
    test("makeHttps().toMap()", () async {
      final action = ContentBlockerAction.makeHttps();
      expect(action.toMap(), {'type': 'make-https'});
    });

    test("fromMap", () async {
      final action = ContentBlockerAction.fromMap(
        {'type': 'css-display-none', 'selector': '*'},
      );
      expect(action.toMap(), {'type': 'css-display-none', 'selector': '*'});
    });
  });

  group("ContentBlockerTriggerResourceType", () {
    test("toValue", () async {
      expect(ContentBlockerTriggerResourceType.document.toValue(), "document");
    });

    test("fromValue", () async {
      expect(
        ContentBlockerTriggerResourceType.fromValue("document"),
        ContentBlockerTriggerResourceType.document,
      );
      expect(
        ContentBlockerTriggerResourceType.fromValue("hogehoge"),
        null,
      );
    });
  });

  group("ContentBlockerTriggerLoadType", () {
    test("toValue", () async {
      expect(ContentBlockerTriggerLoadType.firstParty.toValue(), "first-party");
    });

    test("fromValue", () async {
      expect(
        ContentBlockerTriggerLoadType.fromValue("first-party"),
        ContentBlockerTriggerLoadType.firstParty,
      );
      expect(
        ContentBlockerTriggerLoadType.fromValue("hogehoge"),
        null,
      );
    });
  });

  group("ContentBlockerActionType", () {
    test("toValue", () async {
      expect(ContentBlockerActionType.block.toValue(), "block");
    });

    test("fromValue", () async {
      expect(
        ContentBlockerActionType.fromValue("block"),
        ContentBlockerActionType.block,
      );
      expect(
        ContentBlockerActionType.fromValue("hogehoge"),
        null,
      );
    });
  });
}
