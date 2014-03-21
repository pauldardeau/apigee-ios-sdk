//
//  ApigeeSessionMetricsCompiler.m
//  ApigeeAppMonitor
//
//  Copyright (c) 2012 Apigee. All rights reserved.
//

#import "NSString+UUID.h"
#import "NSDate+Apigee.h"
#import "ApigeeOpenUDID.h"
#import "ApigeeSessionMetricsCompiler.h"
#import "UIDevice+Apigee.h"
#import "ApigeeMonitoringClient.h"

#define kValueUnkown @"UNKNOWN"
#define kApigeeSessionIdKey @"kApigeeSessionIdKey"
#define kApigeeSessionTimeStampKey @"kApigeeSessionTimeStampKey"

#define kApigeeDefaultSessionTimeout (30.0f * 60.0f) // 30 min time out

@interface ApigeeSessionMetricsCompiler ()

@property (assign, nonatomic) BOOL networkChanged;
@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) NSDate *sessionStart;

- (void) networkChanged:(NSNotification *) notice;
- (void) createSession:(NSNotification *) notice;

@end

@implementation ApigeeSessionMetricsCompiler

@synthesize sessionId;

#pragma mark - Instance management

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (ApigeeSessionMetricsCompiler *) systemCompiler
{
    static ApigeeSessionMetricsCompiler *instance;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[ApigeeSessionMetricsCompiler alloc] init];

        instance.networkChanged = NO;
        [instance createSession:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(createSession:) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    
    return instance;
}

#pragma mark - Public implementation

- (ApigeeSessionMetrics *) compileMetricsForSettings:(ApigeeActiveSettings *) settings
                                              isWiFi:(BOOL)isWiFi
{
    ApigeeSessionMetrics *metrics = [[ApigeeSessionMetrics alloc] init];
    UIDevice *currentDevice = [UIDevice currentDevice];
        
    metrics.appConfigType = settings.activeConfigurationName;
    metrics.appId = [settings.instaOpsApplicationId stringValue];
    metrics.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    metrics.timeStamp = [NSDate stringFromMilliseconds:[NSDate nowAsMilliseconds]];
    metrics.sdkVersion = [ApigeeMonitoringClient sdkVersion];
    metrics.sdkType = @"iOS";
    
    if (settings.batteryStatusCaptureEnabled) {
        metrics.batteryLevel = [[NSNumber numberWithFloat: (100 * [currentDevice batteryLevel])] stringValue];
    } else {
        metrics.batteryLevel = nil;
    }

    NSLocale *locale = [NSLocale currentLocale];
    
    metrics.networkCarrier = kValueUnkown;
    metrics.networkCountry = kValueUnkown;
    metrics.deviceCountry = kValueUnkown;

    metrics.networkType = isWiFi ? @"WIFI" : @"MOBILE";
    metrics.networkSubType = kValueUnkown;
    
   
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];

    metrics.localCountry = countryName;
    metrics.localLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    metrics.deviceOSVersion = [currentDevice systemVersion];
    metrics.devicePlatform = [currentDevice systemName];
    
    if (settings.deviceModelCaptureEnabled) {
        // the 'model' property on UIDevice only gives values such as
        // 'iPhone', 'iPod', 'iPad' (very generic)
        //metrics.deviceModel = [currentDevice model];
        
        // we want more details to know the specifics
        metrics.deviceModel = [UIDevice platformStringDescriptive];
    } else {
        metrics.deviceModel = kValueUnkown;
    }

    if (settings.deviceIdCaptureEnabled) {
        metrics.deviceId = [ApigeeOpenUDID value];
    } else {
        metrics.deviceId = kValueUnkown;
    }
    
    metrics.sessionStartTime = [NSDate stringFromMilliseconds:[self.sessionStart dateAsMilliseconds]];
    metrics.sessionId = self.sessionId;
    
    if (self.networkChanged) {
        metrics.isNetworkChanged = @"true";
    } else {
        metrics.isNetworkChanged = @"false";
    }
    
    return metrics;
}

#pragma mark - Reachability notification handler

- (void) networkChanged:(NSNotification *) notice
{
    self.networkChanged = YES;
}

#pragma mark - Session lifecycle handler

- (void) createSession:(NSNotification *) notice
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.sessionId = [standardUserDefaults objectForKey:kApigeeSessionIdKey];
    self.sessionStart = [standardUserDefaults objectForKey:kApigeeSessionTimeStampKey];
    
    if ((!self.sessionStart) || ([[NSDate date] timeIntervalSinceDate:self.sessionStart] > kApigeeDefaultSessionTimeout)) {
        self.sessionId = [NSString uuid];
        self.sessionStart = [NSDate date];
        
        [standardUserDefaults setObject:self.sessionId forKey:kApigeeSessionIdKey];
        [standardUserDefaults setObject:self.sessionStart forKey:kApigeeSessionTimeStampKey];
    }
}

@end
