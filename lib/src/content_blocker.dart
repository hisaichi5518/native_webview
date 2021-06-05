// Originally written by pichillilorenzo
// https://github.com/pichillilorenzo/flutter_inappwebview/

///ContentBlocker class represents a set of rules to use block content in the browser window.
///
///On iOS, it uses [WKContentRuleListStore](https://developer.apple.com/documentation/webkit/wkcontentruleliststore).
///On Android, it uses a custom implementation because such functionality doesn't exist.
///
///In general, this [article](https://developer.apple.com/documentation/safariservices/creating_a_content_blocker) can be used to get an overview about this functionality
///but on Android there are two types of [action] that are unavailable: `block-cookies` and `ignore-previous-rules`.
class ContentBlocker {
  ///Trigger of the content blocker. The trigger tells to the WebView when to perform the corresponding action.
  ContentBlockerTrigger trigger;

  ///Action associated to the trigger. The action tells to the WebView what to do when the trigger is matched.
  ContentBlockerAction action;

  ContentBlocker({
    required this.trigger,
    required this.action,
  });

  Map<String, Map<String, dynamic>> toMap() {
    return {"trigger": trigger.toMap(), "action": action.toMap()};
  }

  static ContentBlocker fromMap(Map<dynamic, Map<dynamic, dynamic>> map) {
    return ContentBlocker(
        trigger: ContentBlockerTrigger.fromMap(
            Map<String, dynamic>.from(map["trigger"]!)),
        action: ContentBlockerAction.fromMap(
            Map<String, dynamic>.from(map["action"]!)));
  }
}

///Trigger of the content blocker. The trigger tells to the WebView when to perform the corresponding action.
///A trigger dictionary must include an [ContentBlockerTrigger.urlFilter], which specifies a pattern to match the URL against.
///The remaining properties are optional and modify the behavior of the trigger.
///For example, you can limit the trigger to specific domains or have it not apply when a match is found on a specific domain.
class ContentBlockerTrigger {
  ///A regular expression pattern to match the URL against.
  String? urlFilter;

  ///Used only by iOS. A Boolean value. The default value is false.
  bool? urlFilterIsCaseSensitive;

  ///A list of [ContentBlockerTriggerResourceType] representing the resource types (how the browser intends to use the resource) that the rule should match.
  ///If not specified, the rule matches all resource types.
  late List<ContentBlockerTriggerResourceType?> resourceType;

  ///A list of strings matched to a URL's domain; limits action to a list of specific domains.
  ///Values must be lowercase ASCII, or punycode for non-ASCII. Add * in front to match domain and subdomains. Can't be used with [ContentBlockerTrigger.unlessDomain].
  List<String>? ifDomain;

  ///A list of strings matched to a URL's domain; acts on any site except domains in a provided list.
  ///Values must be lowercase ASCII, or punycode for non-ASCII. Add * in front to match domain and subdomains. Can't be used with [ContentBlockerTrigger.ifDomain].
  List<String>? unlessDomain;

  ///A list of [ContentBlockerTriggerLoadType] that can include one of two mutually exclusive values. If not specified, the rule matches all load types.
  late List<ContentBlockerTriggerLoadType?> loadType;

  ///A list of strings matched to the entire main document URL; limits the action to a specific list of URL patterns.
  ///Values must be lowercase ASCII, or punycode for non-ASCII. Can't be used with [ContentBlockerTrigger.unlessTopUrl].
  List<String>? ifTopUrl;

  ///An array of strings matched to the entire main document URL; acts on any site except URL patterns in provided list.
  ///Values must be lowercase ASCII, or punycode for non-ASCII. Can't be used with [ContentBlockerTrigger.ifTopUrl].
  List<String>? unlessTopUrl;

  ContentBlockerTrigger({
    required String? urlFilter,
    bool? urlFilterIsCaseSensitive = false,
    List<ContentBlockerTriggerResourceType?> resourceType = const [],
    List<String> ifDomain = const [],
    List<String> unlessDomain = const [],
    List<ContentBlockerTriggerLoadType?> loadType = const [],
    List<String> ifTopUrl = const [],
    List<String> unlessTopUrl = const [],
  }) {
    this.urlFilter = urlFilter;
    assert(this.urlFilter != null);
    this.resourceType = resourceType;
    this.urlFilterIsCaseSensitive = urlFilterIsCaseSensitive;
    this.ifDomain = ifDomain;
    this.unlessDomain = unlessDomain;
    assert(!(this.ifDomain!.isEmpty || this.unlessDomain!.isEmpty) == false);
    this.loadType = loadType;
    assert(this.loadType.length <= 2);
    this.ifTopUrl = ifTopUrl;
    this.unlessTopUrl = unlessTopUrl;
    assert(!(this.ifTopUrl!.isEmpty || this.unlessTopUrl!.isEmpty) == false);
  }

  Map<String, dynamic> toMap() {
    var resourceTypeStringList = <String>[];
    resourceType.forEach((type) {
      resourceTypeStringList.add(type!.toValue());
    });
    var loadTypeStringList = <String>[];
    loadType.forEach((type) {
      loadTypeStringList.add(type!.toValue());
    });

    var map = <String, dynamic>{
      "url-filter": urlFilter,
      "url-filter-is-case-sensitive": urlFilterIsCaseSensitive,
      "if-domain": ifDomain,
      "unless-domain": unlessDomain,
      "resource-type": resourceTypeStringList,
      "load-type": loadTypeStringList,
      "if-top-url": ifTopUrl,
      "unless-top-url": unlessTopUrl
    };

    map.keys
        .where((key) =>
            map[key] == null ||
            (map[key] is List && (map[key] as List).isEmpty)) // filter keys
        .toList() // create a copy to avoid concurrent modifications
        .forEach(map.remove);

    return map;
  }

  static ContentBlockerTrigger fromMap(Map<String, dynamic> map) {
    var resourceType = <ContentBlockerTriggerResourceType?>[];
    var loadType = <ContentBlockerTriggerLoadType?>[];

    var resourceTypeStringList = List<String>.from(map["resource-type"] ?? []);
    resourceTypeStringList.forEach((type) {
      resourceType.add(ContentBlockerTriggerResourceType.fromValue(type));
    });

    var loadTypeStringList = List<String>.from(map["load-type"] ?? []);
    loadTypeStringList.forEach((type) {
      loadType.add(ContentBlockerTriggerLoadType.fromValue(type));
    });

    return ContentBlockerTrigger(
      urlFilter: map["url-filter"],
      urlFilterIsCaseSensitive: map["url-filter-is-case-sensitive"],
      ifDomain: List<String>.from(map["if-domain"] ?? []),
      unlessDomain: List<String>.from(map["unless-domain"] ?? []),
      resourceType: resourceType,
      loadType: loadType,
      ifTopUrl: List<String>.from(map["if-top-url"] ?? []),
      unlessTopUrl: List<String>.from(map["unless-top-url"] ?? []),
    );
  }
}

///Action associated to the trigger. The action tells to the WebView what to do when the trigger is matched.
///When a trigger matches a resource, the browser queues the associated action for execution.
///The WebView evaluates all the triggers, it executes the actions in order.
///When a domain matches a trigger, all rules after the triggered rule that specify the same action are skipped.
///Group the rules with similar actions together to improve performance.
class ContentBlockerAction {
  ///Type of the action.
  ContentBlockerActionType? type;

  ///If the action type is [ContentBlockerActionType.cssDisplayNone], then also the [selector] property is required, otherwise it is ignored.
  ///It specify a string that defines a selector list. Use CSS identifiers as the individual selector values, separated by commas.
  String? selector;

  ContentBlockerAction.block() {
    type = ContentBlockerActionType.block;
  }

  ContentBlockerAction.cssDisplayNone(String this.selector) {
    type = ContentBlockerActionType.cssDisplayNone;
    selector = selector;
  }

  ContentBlockerAction.makeHttps() {
    type = ContentBlockerActionType.makeHttps;
  }

  ContentBlockerAction._({
    required ContentBlockerActionType? type,
    String? selector,
  }) {
    this.type = type;
    assert(this.type != null);
    if (this.type == ContentBlockerActionType.cssDisplayNone) {
      assert(selector != null);
    }
    this.selector = selector;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"type": type!.toValue(), "selector": selector};

    map.keys
        .where((key) =>
            map[key] == null ||
            (map[key] is List && (map[key] as List).isEmpty)) // filter keys
        .toList() // create a copy to avoid concurrent modifications
        .forEach(map.remove);

    return map;
  }

  static ContentBlockerAction fromMap(Map<String, dynamic> map) {
    return ContentBlockerAction._(
      type: ContentBlockerActionType.fromValue(map["type"]),
      selector: map["selector"],
    );
  }
}

///ContentBlockerTriggerResourceType class represents the possible resource type defined for a [ContentBlockerTrigger].
class ContentBlockerTriggerResourceType {
  final String _value;

  const ContentBlockerTriggerResourceType._(this._value);

  static ContentBlockerTriggerResourceType? fromValue(String value) {
    return ([
      "document",
      "image",
      "style-sheet",
      "script",
      "font",
      "media",
      "svg-document",
      "raw",
    ].contains(value))
        ? ContentBlockerTriggerResourceType._(value)
        : null;
  }

  String toValue() => _value;

  @override
  String toString() => _value;

  static const document = ContentBlockerTriggerResourceType._('document');
  static const image = ContentBlockerTriggerResourceType._('image');
  static const styleSheet = ContentBlockerTriggerResourceType._('style-sheet');
  static const script = ContentBlockerTriggerResourceType._('script');
  static const font = ContentBlockerTriggerResourceType._('font');
  static const media = ContentBlockerTriggerResourceType._('media');
  static const svgDocument =
      ContentBlockerTriggerResourceType._('svg-document');

  ///Any untyped load
  static const raw = ContentBlockerTriggerResourceType._('raw');

  @override
  bool operator ==(value) => value == _value;

  @override
  int get hashCode => _value.hashCode;
}

///ContentBlockerTriggerLoadType class represents the possible load type for a [ContentBlockerTrigger].
class ContentBlockerTriggerLoadType {
  final String _value;
  const ContentBlockerTriggerLoadType._(this._value);
  static ContentBlockerTriggerLoadType? fromValue(String value) {
    return (["first-party", "third-party"].contains(value))
        ? ContentBlockerTriggerLoadType._(value)
        : null;
  }

  String toValue() => _value;
  @override
  String toString() => _value;

  ///firstParty is triggered only if the resource has the same scheme, domain, and port as the main page resource.
  static const firstParty = ContentBlockerTriggerLoadType._('first-party');

  ///thirdParty is triggered if the resource is not from the same domain as the main page resource.
  static const thirdParty = ContentBlockerTriggerLoadType._('third-party');

  @override
  bool operator ==(value) => value == _value;

  @override
  int get hashCode => _value.hashCode;
}

///ContentBlockerActionType class represents the kind of action that can be used with a [ContentBlockerTrigger].
class ContentBlockerActionType {
  final String? _value;

  const ContentBlockerActionType._(this._value);

  static ContentBlockerActionType? fromValue(String? value) {
    return (["block", "css-display-none", "make-https"].contains(value))
        ? ContentBlockerActionType._(value)
        : null;
  }

  String? toValue() => _value;
  @override
  String toString() => _value!;

  ///Stops loading of the resource. If the resource was cached, the cache is ignored.
  static const block = ContentBlockerActionType._('block');

  ///Hides elements of the page based on a CSS selector. A selector field contains the selector list. Any matching element has its display property set to none, which hides it.
  ///
  ///**NOTE**: cssDisplayNone is not supported on Android
  static const cssDisplayNone = ContentBlockerActionType._('css-display-none');

  ///Changes a URL from http to https. URLs with a specified (nondefault) port and links using other protocols are unaffected.
  ///
  ///**NOTE**: makeHttps is not supported on Android
  static const makeHttps = ContentBlockerActionType._('make-https');

  @override
  bool operator ==(value) => value == _value;

  @override
  int get hashCode => _value.hashCode;
}
