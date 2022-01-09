#import "DartDlApiPlugin.h"
//#include "include/dart_api_dl.c"

@implementation DartDlApiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"dart_dl_api"
            binaryMessenger:[registrar messenger]];
  DartDlApiPlugin* instance = [[DartDlApiPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result([@"macOS " stringByAppendingString:[[NSProcessInfo processInfo] operatingSystemVersionString]]);
}

@end
