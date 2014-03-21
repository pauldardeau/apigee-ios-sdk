//
//  NSArray+ApigeeConfigFilters.h
//  ApigeeiOSSDK
//
//  Copyright (c) 2012 Apigee. All rights reserved.
//



@interface NSArray (ApigeeConfigFilters)

- (BOOL) isEmpty;
- (BOOL) containsPlatform:(NSString *) platform;
- (BOOL) containsCarrier:(NSString *) carrier;
- (BOOL) containsDeviceModel:(NSString *) deviceModel;
- (BOOL) containsDeviceId:(NSString *) deviceId;

@end
