#import "GeoqPlugin.h"
#if __has_include(<geoq/geoq-Swift.h>)
#import <geoq/geoq-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "geoq-Swift.h"
#endif

@implementation GeoqPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGeoqPlugin registerWithRegistrar:registrar];
}
@end
