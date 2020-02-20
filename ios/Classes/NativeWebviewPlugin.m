#import "NativeWebviewPlugin.h"
#if __has_include(<native_webview/native_webview-Swift.h>)
#import <native_webview/native_webview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_webview-Swift.h"
#endif

@implementation NativeWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeWebviewPlugin registerWithRegistrar:registrar];
}
@end
