// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'webview_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$WebViewEventTearOff {
  const _$WebViewEventTearOff();

// ignore: unused_element
  ShouldOverrideUrlLoadingEvent shouldOverrideUrlLoading(
      ShouldOverrideUrlLoadingRequest request) {
    return ShouldOverrideUrlLoadingEvent(
      request,
    );
  }

// ignore: unused_element
  ProgressChangedEvent progressChanged(int progress) {
    return ProgressChangedEvent(
      progress,
    );
  }

// ignore: unused_element
  PageStartedEvent pageStarted(
      String url, String currentUrl, bool canGoBack, bool canGoForward) {
    return PageStartedEvent(
      url,
      currentUrl,
      canGoBack,
      canGoForward,
    );
  }

// ignore: unused_element
  PageFinishedEvent pageFinished(
      String url, String currentUrl, bool canGoBack, bool canGoForward) {
    return PageFinishedEvent(
      url,
      currentUrl,
      canGoBack,
      canGoForward,
    );
  }

// ignore: unused_element
  WebResourceErrorEvent webResourceError(WebResourceError error) {
    return WebResourceErrorEvent(
      error,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $WebViewEvent = _$WebViewEventTearOff();

/// @nodoc
mixin _$WebViewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $WebViewEventCopyWith<$Res> {
  factory $WebViewEventCopyWith(
          WebViewEvent value, $Res Function(WebViewEvent) then) =
      _$WebViewEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$WebViewEventCopyWithImpl<$Res> implements $WebViewEventCopyWith<$Res> {
  _$WebViewEventCopyWithImpl(this._value, this._then);

  final WebViewEvent _value;
  // ignore: unused_field
  final $Res Function(WebViewEvent) _then;
}

/// @nodoc
abstract class $ShouldOverrideUrlLoadingEventCopyWith<$Res> {
  factory $ShouldOverrideUrlLoadingEventCopyWith(
          ShouldOverrideUrlLoadingEvent value,
          $Res Function(ShouldOverrideUrlLoadingEvent) then) =
      _$ShouldOverrideUrlLoadingEventCopyWithImpl<$Res>;
  $Res call({ShouldOverrideUrlLoadingRequest request});
}

/// @nodoc
class _$ShouldOverrideUrlLoadingEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res>
    implements $ShouldOverrideUrlLoadingEventCopyWith<$Res> {
  _$ShouldOverrideUrlLoadingEventCopyWithImpl(
      ShouldOverrideUrlLoadingEvent _value,
      $Res Function(ShouldOverrideUrlLoadingEvent) _then)
      : super(_value, (v) => _then(v as ShouldOverrideUrlLoadingEvent));

  @override
  ShouldOverrideUrlLoadingEvent get _value =>
      super._value as ShouldOverrideUrlLoadingEvent;

  @override
  $Res call({
    Object request = freezed,
  }) {
    return _then(ShouldOverrideUrlLoadingEvent(
      request == freezed
          ? _value.request
          : request as ShouldOverrideUrlLoadingRequest,
    ));
  }
}

/// @nodoc
class _$ShouldOverrideUrlLoadingEvent implements ShouldOverrideUrlLoadingEvent {
  const _$ShouldOverrideUrlLoadingEvent(this.request) : assert(request != null);

  @override
  final ShouldOverrideUrlLoadingRequest request;

  @override
  String toString() {
    return 'WebViewEvent.shouldOverrideUrlLoading(request: $request)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ShouldOverrideUrlLoadingEvent &&
            (identical(other.request, request) ||
                const DeepCollectionEquality().equals(other.request, request)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(request);

  @JsonKey(ignore: true)
  @override
  $ShouldOverrideUrlLoadingEventCopyWith<ShouldOverrideUrlLoadingEvent>
      get copyWith => _$ShouldOverrideUrlLoadingEventCopyWithImpl<
          ShouldOverrideUrlLoadingEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return shouldOverrideUrlLoading(request);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (shouldOverrideUrlLoading != null) {
      return shouldOverrideUrlLoading(request);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return shouldOverrideUrlLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (shouldOverrideUrlLoading != null) {
      return shouldOverrideUrlLoading(this);
    }
    return orElse();
  }
}

abstract class ShouldOverrideUrlLoadingEvent implements WebViewEvent {
  const factory ShouldOverrideUrlLoadingEvent(
          ShouldOverrideUrlLoadingRequest request) =
      _$ShouldOverrideUrlLoadingEvent;

  ShouldOverrideUrlLoadingRequest get request;
  @JsonKey(ignore: true)
  $ShouldOverrideUrlLoadingEventCopyWith<ShouldOverrideUrlLoadingEvent>
      get copyWith;
}

/// @nodoc
abstract class $ProgressChangedEventCopyWith<$Res> {
  factory $ProgressChangedEventCopyWith(ProgressChangedEvent value,
          $Res Function(ProgressChangedEvent) then) =
      _$ProgressChangedEventCopyWithImpl<$Res>;
  $Res call({int progress});
}

/// @nodoc
class _$ProgressChangedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res>
    implements $ProgressChangedEventCopyWith<$Res> {
  _$ProgressChangedEventCopyWithImpl(
      ProgressChangedEvent _value, $Res Function(ProgressChangedEvent) _then)
      : super(_value, (v) => _then(v as ProgressChangedEvent));

  @override
  ProgressChangedEvent get _value => super._value as ProgressChangedEvent;

  @override
  $Res call({
    Object progress = freezed,
  }) {
    return _then(ProgressChangedEvent(
      progress == freezed ? _value.progress : progress as int,
    ));
  }
}

/// @nodoc
class _$ProgressChangedEvent implements ProgressChangedEvent {
  const _$ProgressChangedEvent(this.progress) : assert(progress != null);

  @override
  final int progress;

  @override
  String toString() {
    return 'WebViewEvent.progressChanged(progress: $progress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ProgressChangedEvent &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality()
                    .equals(other.progress, progress)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(progress);

  @JsonKey(ignore: true)
  @override
  $ProgressChangedEventCopyWith<ProgressChangedEvent> get copyWith =>
      _$ProgressChangedEventCopyWithImpl<ProgressChangedEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return progressChanged(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (progressChanged != null) {
      return progressChanged(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return progressChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (progressChanged != null) {
      return progressChanged(this);
    }
    return orElse();
  }
}

abstract class ProgressChangedEvent implements WebViewEvent {
  const factory ProgressChangedEvent(int progress) = _$ProgressChangedEvent;

  int get progress;
  @JsonKey(ignore: true)
  $ProgressChangedEventCopyWith<ProgressChangedEvent> get copyWith;
}

/// @nodoc
abstract class $PageStartedEventCopyWith<$Res> {
  factory $PageStartedEventCopyWith(
          PageStartedEvent value, $Res Function(PageStartedEvent) then) =
      _$PageStartedEventCopyWithImpl<$Res>;
  $Res call({String url, String currentUrl, bool canGoBack, bool canGoForward});
}

/// @nodoc
class _$PageStartedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res>
    implements $PageStartedEventCopyWith<$Res> {
  _$PageStartedEventCopyWithImpl(
      PageStartedEvent _value, $Res Function(PageStartedEvent) _then)
      : super(_value, (v) => _then(v as PageStartedEvent));

  @override
  PageStartedEvent get _value => super._value as PageStartedEvent;

  @override
  $Res call({
    Object url = freezed,
    Object currentUrl = freezed,
    Object canGoBack = freezed,
    Object canGoForward = freezed,
  }) {
    return _then(PageStartedEvent(
      url == freezed ? _value.url : url as String,
      currentUrl == freezed ? _value.currentUrl : currentUrl as String,
      canGoBack == freezed ? _value.canGoBack : canGoBack as bool,
      canGoForward == freezed ? _value.canGoForward : canGoForward as bool,
    ));
  }
}

/// @nodoc
class _$PageStartedEvent implements PageStartedEvent {
  const _$PageStartedEvent(
      this.url, this.currentUrl, this.canGoBack, this.canGoForward)
      : assert(url != null),
        assert(currentUrl != null),
        assert(canGoBack != null),
        assert(canGoForward != null);

  @override
  final String url;
  @override
  final String currentUrl;
  @override
  final bool canGoBack;
  @override
  final bool canGoForward;

  @override
  String toString() {
    return 'WebViewEvent.pageStarted(url: $url, currentUrl: $currentUrl, canGoBack: $canGoBack, canGoForward: $canGoForward)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PageStartedEvent &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.currentUrl, currentUrl) ||
                const DeepCollectionEquality()
                    .equals(other.currentUrl, currentUrl)) &&
            (identical(other.canGoBack, canGoBack) ||
                const DeepCollectionEquality()
                    .equals(other.canGoBack, canGoBack)) &&
            (identical(other.canGoForward, canGoForward) ||
                const DeepCollectionEquality()
                    .equals(other.canGoForward, canGoForward)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(currentUrl) ^
      const DeepCollectionEquality().hash(canGoBack) ^
      const DeepCollectionEquality().hash(canGoForward);

  @JsonKey(ignore: true)
  @override
  $PageStartedEventCopyWith<PageStartedEvent> get copyWith =>
      _$PageStartedEventCopyWithImpl<PageStartedEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return pageStarted(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageStarted != null) {
      return pageStarted(url, currentUrl, canGoBack, canGoForward);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return pageStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageStarted != null) {
      return pageStarted(this);
    }
    return orElse();
  }
}

abstract class PageStartedEvent implements WebViewEvent {
  const factory PageStartedEvent(
          String url, String currentUrl, bool canGoBack, bool canGoForward) =
      _$PageStartedEvent;

  String get url;
  String get currentUrl;
  bool get canGoBack;
  bool get canGoForward;
  @JsonKey(ignore: true)
  $PageStartedEventCopyWith<PageStartedEvent> get copyWith;
}

/// @nodoc
abstract class $PageFinishedEventCopyWith<$Res> {
  factory $PageFinishedEventCopyWith(
          PageFinishedEvent value, $Res Function(PageFinishedEvent) then) =
      _$PageFinishedEventCopyWithImpl<$Res>;
  $Res call({String url, String currentUrl, bool canGoBack, bool canGoForward});
}

/// @nodoc
class _$PageFinishedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res>
    implements $PageFinishedEventCopyWith<$Res> {
  _$PageFinishedEventCopyWithImpl(
      PageFinishedEvent _value, $Res Function(PageFinishedEvent) _then)
      : super(_value, (v) => _then(v as PageFinishedEvent));

  @override
  PageFinishedEvent get _value => super._value as PageFinishedEvent;

  @override
  $Res call({
    Object url = freezed,
    Object currentUrl = freezed,
    Object canGoBack = freezed,
    Object canGoForward = freezed,
  }) {
    return _then(PageFinishedEvent(
      url == freezed ? _value.url : url as String,
      currentUrl == freezed ? _value.currentUrl : currentUrl as String,
      canGoBack == freezed ? _value.canGoBack : canGoBack as bool,
      canGoForward == freezed ? _value.canGoForward : canGoForward as bool,
    ));
  }
}

/// @nodoc
class _$PageFinishedEvent implements PageFinishedEvent {
  const _$PageFinishedEvent(
      this.url, this.currentUrl, this.canGoBack, this.canGoForward)
      : assert(url != null),
        assert(currentUrl != null),
        assert(canGoBack != null),
        assert(canGoForward != null);

  @override
  final String url;
  @override
  final String currentUrl;
  @override
  final bool canGoBack;
  @override
  final bool canGoForward;

  @override
  String toString() {
    return 'WebViewEvent.pageFinished(url: $url, currentUrl: $currentUrl, canGoBack: $canGoBack, canGoForward: $canGoForward)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is PageFinishedEvent &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.currentUrl, currentUrl) ||
                const DeepCollectionEquality()
                    .equals(other.currentUrl, currentUrl)) &&
            (identical(other.canGoBack, canGoBack) ||
                const DeepCollectionEquality()
                    .equals(other.canGoBack, canGoBack)) &&
            (identical(other.canGoForward, canGoForward) ||
                const DeepCollectionEquality()
                    .equals(other.canGoForward, canGoForward)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(currentUrl) ^
      const DeepCollectionEquality().hash(canGoBack) ^
      const DeepCollectionEquality().hash(canGoForward);

  @JsonKey(ignore: true)
  @override
  $PageFinishedEventCopyWith<PageFinishedEvent> get copyWith =>
      _$PageFinishedEventCopyWithImpl<PageFinishedEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return pageFinished(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageFinished != null) {
      return pageFinished(url, currentUrl, canGoBack, canGoForward);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return pageFinished(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageFinished != null) {
      return pageFinished(this);
    }
    return orElse();
  }
}

abstract class PageFinishedEvent implements WebViewEvent {
  const factory PageFinishedEvent(
          String url, String currentUrl, bool canGoBack, bool canGoForward) =
      _$PageFinishedEvent;

  String get url;
  String get currentUrl;
  bool get canGoBack;
  bool get canGoForward;
  @JsonKey(ignore: true)
  $PageFinishedEventCopyWith<PageFinishedEvent> get copyWith;
}

/// @nodoc
abstract class $WebResourceErrorEventCopyWith<$Res> {
  factory $WebResourceErrorEventCopyWith(WebResourceErrorEvent value,
          $Res Function(WebResourceErrorEvent) then) =
      _$WebResourceErrorEventCopyWithImpl<$Res>;
  $Res call({WebResourceError error});
}

/// @nodoc
class _$WebResourceErrorEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res>
    implements $WebResourceErrorEventCopyWith<$Res> {
  _$WebResourceErrorEventCopyWithImpl(
      WebResourceErrorEvent _value, $Res Function(WebResourceErrorEvent) _then)
      : super(_value, (v) => _then(v as WebResourceErrorEvent));

  @override
  WebResourceErrorEvent get _value => super._value as WebResourceErrorEvent;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(WebResourceErrorEvent(
      error == freezed ? _value.error : error as WebResourceError,
    ));
  }
}

/// @nodoc
class _$WebResourceErrorEvent implements WebResourceErrorEvent {
  const _$WebResourceErrorEvent(this.error) : assert(error != null);

  @override
  final WebResourceError error;

  @override
  String toString() {
    return 'WebViewEvent.webResourceError(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is WebResourceErrorEvent &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $WebResourceErrorEventCopyWith<WebResourceErrorEvent> get copyWith =>
      _$WebResourceErrorEventCopyWithImpl<WebResourceErrorEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(
            ShouldOverrideUrlLoadingRequest request),
    @required TResult progressChanged(int progress),
    @required
        TResult pageStarted(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required
        TResult pageFinished(
            String url, String currentUrl, bool canGoBack, bool canGoForward),
    @required TResult webResourceError(WebResourceError error),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return webResourceError(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingRequest request),
    TResult progressChanged(int progress),
    TResult pageStarted(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult pageFinished(
        String url, String currentUrl, bool canGoBack, bool canGoForward),
    TResult webResourceError(WebResourceError error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (webResourceError != null) {
      return webResourceError(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required
        TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    @required TResult progressChanged(ProgressChangedEvent value),
    @required TResult pageStarted(PageStartedEvent value),
    @required TResult pageFinished(PageFinishedEvent value),
    @required TResult webResourceError(WebResourceErrorEvent value),
  }) {
    assert(shouldOverrideUrlLoading != null);
    assert(progressChanged != null);
    assert(pageStarted != null);
    assert(pageFinished != null);
    assert(webResourceError != null);
    return webResourceError(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult shouldOverrideUrlLoading(ShouldOverrideUrlLoadingEvent value),
    TResult progressChanged(ProgressChangedEvent value),
    TResult pageStarted(PageStartedEvent value),
    TResult pageFinished(PageFinishedEvent value),
    TResult webResourceError(WebResourceErrorEvent value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (webResourceError != null) {
      return webResourceError(this);
    }
    return orElse();
  }
}

abstract class WebResourceErrorEvent implements WebViewEvent {
  const factory WebResourceErrorEvent(WebResourceError error) =
      _$WebResourceErrorEvent;

  WebResourceError get error;
  @JsonKey(ignore: true)
  $WebResourceErrorEventCopyWith<WebResourceErrorEvent> get copyWith;
}
