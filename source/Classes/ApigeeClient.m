//
//  ApigeeClient.m
//  ApigeeiOSSDK
//
//  Copyright (c) 2013 Apigee. All rights reserved.
//

#import "ApigeeClient.h"
#import "ApigeeAppIdentification.h"
#import "ApigeeMonitoringClient.h"
#import "ApigeeMonitoringOptions.h"
#import "ApigeeDefaultiOSLog.h"

/*!
 @version 2.0.10
 */
static NSString* kSDKVersion = @"2.0.10.c";


@interface ApigeeClient ()

@property (strong, nonatomic) ApigeeMonitoringClient* monitoringClient;
@property (strong, nonatomic) ApigeeAppIdentification* appIdentification;

@end


@implementation ApigeeClient

@synthesize monitoringClient;
@synthesize appIdentification;

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
{
    return [self initWithOrganizationId:organizationId
                          applicationId:applicationId
                                baseURL:nil
                               urlTerms:nil
                                options:nil];
}

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
                     baseURL:(NSString*)baseURL
{
    return [self initWithOrganizationId:organizationId
                          applicationId:applicationId
                                baseURL:baseURL
                               urlTerms:nil
                                options:nil];
}

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
                     baseURL:(NSString*)baseURL
                     options:(ApigeeMonitoringOptions*)monitoringOptions
{
   return [self initWithOrganizationId:organizationId
                         applicationId:applicationId
                               baseURL:baseURL
                              urlTerms:nil
                               options:monitoringOptions];
}

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
                     baseURL:(NSString*)baseURL
                     urlTerms:(NSString*)urlTerms
{
    return [self initWithOrganizationId:organizationId
                          applicationId:applicationId
                                baseURL:baseURL
                               urlTerms:urlTerms
                                options:nil];
}

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
                     options:(ApigeeMonitoringOptions*)monitoringOptions
{
    return [self initWithOrganizationId:organizationId
                          applicationId:applicationId
                                baseURL:nil
                                urlTerms:nil
                                options:monitoringOptions];
}

- (id)initWithOrganizationId:(NSString*)organizationId
               applicationId:(NSString*)applicationId
                     baseURL:(NSString*)baseURL
                     urlTerms:(NSString*)urlTerms
                     options:(ApigeeMonitoringOptions*)monitoringOptions
{
    self = [super init];
    if( self )
    {
        self.appIdentification =
        [[ApigeeAppIdentification alloc] initWithOrganizationId:organizationId
                                                  applicationId:applicationId];
        
        if( [baseURL length] > 0 ) {
            self.appIdentification.baseURL = baseURL;
        } else {
            self.appIdentification.baseURL = @"https://api.usergrid.com";
        }
        

        if( monitoringOptions != nil ) {
            if( monitoringOptions.monitoringEnabled ) {
                self.monitoringClient =
                    [[ApigeeMonitoringClient alloc] initWithAppIdentification:self.appIdentification
                                                                      options:monitoringOptions];
            } else {
                self.monitoringClient = nil;
            }
        } else {
            self.monitoringClient =
                [[ApigeeMonitoringClient alloc] initWithAppIdentification:self.appIdentification];
        }
            
        if( self.monitoringClient ) {
            NSLog( @"apigee: monitoringClient created" );
        } else {
            if (monitoringOptions && monitoringOptions.monitoringEnabled) {
                NSLog( @"apigee: unable to create monitoringClient" );
            }
        }
    }
    
    return self;
}


+ (NSString*)sdkVersion
{
    return kSDKVersion;
}

@end
