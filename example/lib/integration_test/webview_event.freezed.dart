// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'webview_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WebViewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebViewEventCopyWith<$Res> {
  factory $WebViewEventCopyWith(
          WebViewEvent value, $Res Function(WebViewEvent) then) =
      _$WebViewEventCopyWithImpl<$Res, WebViewEvent>;
}

/// @nodoc
class _$WebViewEventCopyWithImpl<$Res, $Val extends WebViewEvent>
    implements $WebViewEventCopyWith<$Res> {
  _$WebViewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ShouldOverrideUrlLoadingEventCopyWith<$Res> {
  factory _$$ShouldOverrideUrlLoadingEventCopyWith(
          _$ShouldOverrideUrlLoadingEvent value,
          $Res Function(_$ShouldOverrideUrlLoadingEvent) then) =
      __$$ShouldOverrideUrlLoadingEventCopyWithImpl<$Res>;
  @useResult
  $Res call({ShouldOverrideUrlLoadingRequest request});
}

/// @nodoc
class __$$ShouldOverrideUrlLoadingEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res, _$ShouldOverrideUrlLoadingEvent>
    implements _$$ShouldOverrideUrlLoadingEventCopyWith<$Res> {
  __$$ShouldOverrideUrlLoadingEventCopyWithImpl(
      _$ShouldOverrideUrlLoadingEvent _value,
      $Res Function(_$ShouldOverrideUrlLoadingEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? request = null,
  }) {
    return _then(_$ShouldOverrideUrlLoadingEvent(
      null == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as ShouldOverrideUrlLoadingRequest,
    ));
  }
}

/// @nodoc

class _$ShouldOverrideUrlLoadingEvent implements ShouldOverrideUrlLoadingEvent {
  const _$ShouldOverrideUrlLoadingEvent(this.request);

  @override
  final ShouldOverrideUrlLoadingRequest request;

  @override
  String toString() {
    return 'WebViewEvent.shouldOverrideUrlLoading(request: $request)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShouldOverrideUrlLoadingEvent &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShouldOverrideUrlLoadingEventCopyWith<_$ShouldOverrideUrlLoadingEvent>
      get copyWith => __$$ShouldOverrideUrlLoadingEventCopyWithImpl<
          _$ShouldOverrideUrlLoadingEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) {
    return shouldOverrideUrlLoading(request);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) {
    return shouldOverrideUrlLoading?.call(request);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) {
    if (shouldOverrideUrlLoading != null) {
      return shouldOverrideUrlLoading(request);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) {
    return shouldOverrideUrlLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) {
    return shouldOverrideUrlLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) {
    if (shouldOverrideUrlLoading != null) {
      return shouldOverrideUrlLoading(this);
    }
    return orElse();
  }
}

abstract class ShouldOverrideUrlLoadingEvent implements WebViewEvent {
  const factory ShouldOverrideUrlLoadingEvent(
          final ShouldOverrideUrlLoadingRequest request) =
      _$ShouldOverrideUrlLoadingEvent;

  ShouldOverrideUrlLoadingRequest get request;
  @JsonKey(ignore: true)
  _$$ShouldOverrideUrlLoadingEventCopyWith<_$ShouldOverrideUrlLoadingEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProgressChangedEventCopyWith<$Res> {
  factory _$$ProgressChangedEventCopyWith(_$ProgressChangedEvent value,
          $Res Function(_$ProgressChangedEvent) then) =
      __$$ProgressChangedEventCopyWithImpl<$Res>;
  @useResult
  $Res call({int progress});
}

/// @nodoc
class __$$ProgressChangedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res, _$ProgressChangedEvent>
    implements _$$ProgressChangedEventCopyWith<$Res> {
  __$$ProgressChangedEventCopyWithImpl(_$ProgressChangedEvent _value,
      $Res Function(_$ProgressChangedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
  }) {
    return _then(_$ProgressChangedEvent(
      null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ProgressChangedEvent implements ProgressChangedEvent {
  const _$ProgressChangedEvent(this.progress);

  @override
  final int progress;

  @override
  String toString() {
    return 'WebViewEvent.progressChanged(progress: $progress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressChangedEvent &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressChangedEventCopyWith<_$ProgressChangedEvent> get copyWith =>
      __$$ProgressChangedEventCopyWithImpl<_$ProgressChangedEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) {
    return progressChanged(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) {
    return progressChanged?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) {
    if (progressChanged != null) {
      return progressChanged(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) {
    return progressChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) {
    return progressChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) {
    if (progressChanged != null) {
      return progressChanged(this);
    }
    return orElse();
  }
}

abstract class ProgressChangedEvent implements WebViewEvent {
  const factory ProgressChangedEvent(final int progress) =
      _$ProgressChangedEvent;

  int get progress;
  @JsonKey(ignore: true)
  _$$ProgressChangedEventCopyWith<_$ProgressChangedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageStartedEventCopyWith<$Res> {
  factory _$$PageStartedEventCopyWith(
          _$PageStartedEvent value, $Res Function(_$PageStartedEvent) then) =
      __$$PageStartedEventCopyWithImpl<$Res>;
  @useResult
  $Res call({String url, String currentUrl, bool canGoBack, bool canGoForward});
}

/// @nodoc
class __$$PageStartedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res, _$PageStartedEvent>
    implements _$$PageStartedEventCopyWith<$Res> {
  __$$PageStartedEventCopyWithImpl(
      _$PageStartedEvent _value, $Res Function(_$PageStartedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? currentUrl = null,
    Object? canGoBack = null,
    Object? canGoForward = null,
  }) {
    return _then(_$PageStartedEvent(
      null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      null == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
      null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PageStartedEvent implements PageStartedEvent {
  const _$PageStartedEvent(
      this.url, this.currentUrl, this.canGoBack, this.canGoForward);

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
        (other.runtimeType == runtimeType &&
            other is _$PageStartedEvent &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.currentUrl, currentUrl) ||
                other.currentUrl == currentUrl) &&
            (identical(other.canGoBack, canGoBack) ||
                other.canGoBack == canGoBack) &&
            (identical(other.canGoForward, canGoForward) ||
                other.canGoForward == canGoForward));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, url, currentUrl, canGoBack, canGoForward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageStartedEventCopyWith<_$PageStartedEvent> get copyWith =>
      __$$PageStartedEventCopyWithImpl<_$PageStartedEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) {
    return pageStarted(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) {
    return pageStarted?.call(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) {
    if (pageStarted != null) {
      return pageStarted(url, currentUrl, canGoBack, canGoForward);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) {
    return pageStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) {
    return pageStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) {
    if (pageStarted != null) {
      return pageStarted(this);
    }
    return orElse();
  }
}

abstract class PageStartedEvent implements WebViewEvent {
  const factory PageStartedEvent(final String url, final String currentUrl,
      final bool canGoBack, final bool canGoForward) = _$PageStartedEvent;

  String get url;
  String get currentUrl;
  bool get canGoBack;
  bool get canGoForward;
  @JsonKey(ignore: true)
  _$$PageStartedEventCopyWith<_$PageStartedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PageFinishedEventCopyWith<$Res> {
  factory _$$PageFinishedEventCopyWith(
          _$PageFinishedEvent value, $Res Function(_$PageFinishedEvent) then) =
      __$$PageFinishedEventCopyWithImpl<$Res>;
  @useResult
  $Res call({String url, String currentUrl, bool canGoBack, bool canGoForward});
}

/// @nodoc
class __$$PageFinishedEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res, _$PageFinishedEvent>
    implements _$$PageFinishedEventCopyWith<$Res> {
  __$$PageFinishedEventCopyWithImpl(
      _$PageFinishedEvent _value, $Res Function(_$PageFinishedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? currentUrl = null,
    Object? canGoBack = null,
    Object? canGoForward = null,
  }) {
    return _then(_$PageFinishedEvent(
      null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      null == currentUrl
          ? _value.currentUrl
          : currentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      null == canGoBack
          ? _value.canGoBack
          : canGoBack // ignore: cast_nullable_to_non_nullable
              as bool,
      null == canGoForward
          ? _value.canGoForward
          : canGoForward // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PageFinishedEvent implements PageFinishedEvent {
  const _$PageFinishedEvent(
      this.url, this.currentUrl, this.canGoBack, this.canGoForward);

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
        (other.runtimeType == runtimeType &&
            other is _$PageFinishedEvent &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.currentUrl, currentUrl) ||
                other.currentUrl == currentUrl) &&
            (identical(other.canGoBack, canGoBack) ||
                other.canGoBack == canGoBack) &&
            (identical(other.canGoForward, canGoForward) ||
                other.canGoForward == canGoForward));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, url, currentUrl, canGoBack, canGoForward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageFinishedEventCopyWith<_$PageFinishedEvent> get copyWith =>
      __$$PageFinishedEventCopyWithImpl<_$PageFinishedEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) {
    return pageFinished(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) {
    return pageFinished?.call(url, currentUrl, canGoBack, canGoForward);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) {
    if (pageFinished != null) {
      return pageFinished(url, currentUrl, canGoBack, canGoForward);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) {
    return pageFinished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) {
    return pageFinished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) {
    if (pageFinished != null) {
      return pageFinished(this);
    }
    return orElse();
  }
}

abstract class PageFinishedEvent implements WebViewEvent {
  const factory PageFinishedEvent(final String url, final String currentUrl,
      final bool canGoBack, final bool canGoForward) = _$PageFinishedEvent;

  String get url;
  String get currentUrl;
  bool get canGoBack;
  bool get canGoForward;
  @JsonKey(ignore: true)
  _$$PageFinishedEventCopyWith<_$PageFinishedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WebResourceErrorEventCopyWith<$Res> {
  factory _$$WebResourceErrorEventCopyWith(_$WebResourceErrorEvent value,
          $Res Function(_$WebResourceErrorEvent) then) =
      __$$WebResourceErrorEventCopyWithImpl<$Res>;
  @useResult
  $Res call({WebResourceError error});
}

/// @nodoc
class __$$WebResourceErrorEventCopyWithImpl<$Res>
    extends _$WebViewEventCopyWithImpl<$Res, _$WebResourceErrorEvent>
    implements _$$WebResourceErrorEventCopyWith<$Res> {
  __$$WebResourceErrorEventCopyWithImpl(_$WebResourceErrorEvent _value,
      $Res Function(_$WebResourceErrorEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$WebResourceErrorEvent(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as WebResourceError,
    ));
  }
}

/// @nodoc

class _$WebResourceErrorEvent implements WebResourceErrorEvent {
  const _$WebResourceErrorEvent(this.error);

  @override
  final WebResourceError error;

  @override
  String toString() {
    return 'WebViewEvent.webResourceError(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebResourceErrorEvent &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebResourceErrorEventCopyWith<_$WebResourceErrorEvent> get copyWith =>
      __$$WebResourceErrorEventCopyWithImpl<_$WebResourceErrorEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingRequest request)
        shouldOverrideUrlLoading,
    required TResult Function(int progress) progressChanged,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageStarted,
    required TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)
        pageFinished,
    required TResult Function(WebResourceError error) webResourceError,
  }) {
    return webResourceError(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult? Function(int progress)? progressChanged,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult? Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult? Function(WebResourceError error)? webResourceError,
  }) {
    return webResourceError?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingRequest request)?
        shouldOverrideUrlLoading,
    TResult Function(int progress)? progressChanged,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageStarted,
    TResult Function(
            String url, String currentUrl, bool canGoBack, bool canGoForward)?
        pageFinished,
    TResult Function(WebResourceError error)? webResourceError,
    required TResult orElse(),
  }) {
    if (webResourceError != null) {
      return webResourceError(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ShouldOverrideUrlLoadingEvent value)
        shouldOverrideUrlLoading,
    required TResult Function(ProgressChangedEvent value) progressChanged,
    required TResult Function(PageStartedEvent value) pageStarted,
    required TResult Function(PageFinishedEvent value) pageFinished,
    required TResult Function(WebResourceErrorEvent value) webResourceError,
  }) {
    return webResourceError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult? Function(ProgressChangedEvent value)? progressChanged,
    TResult? Function(PageStartedEvent value)? pageStarted,
    TResult? Function(PageFinishedEvent value)? pageFinished,
    TResult? Function(WebResourceErrorEvent value)? webResourceError,
  }) {
    return webResourceError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ShouldOverrideUrlLoadingEvent value)?
        shouldOverrideUrlLoading,
    TResult Function(ProgressChangedEvent value)? progressChanged,
    TResult Function(PageStartedEvent value)? pageStarted,
    TResult Function(PageFinishedEvent value)? pageFinished,
    TResult Function(WebResourceErrorEvent value)? webResourceError,
    required TResult orElse(),
  }) {
    if (webResourceError != null) {
      return webResourceError(this);
    }
    return orElse();
  }
}

abstract class WebResourceErrorEvent implements WebViewEvent {
  const factory WebResourceErrorEvent(final WebResourceError error) =
      _$WebResourceErrorEvent;

  WebResourceError get error;
  @JsonKey(ignore: true)
  _$$WebResourceErrorEventCopyWith<_$WebResourceErrorEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
