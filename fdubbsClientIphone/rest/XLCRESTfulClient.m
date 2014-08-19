//
//  XLCRESTfulClient.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "XLCRESTfulClient.h"

#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCContent.h"
#import "XLCImage.h"
#import "XLCPostDetail.h"
#import "XLCPostQoute.h"
#import "XLCPostReplies.h"
#import "XLCSectionMetaData.h"
#import "XLCSection.h"
#import "XLCBoardMetaData.h"
#import "XLCBoardDetail.h"
#import "XLCPostSummaryInBoard.h"
#import "XLCLoginResponse.h"
#import "XLCLogoutResponse.h"

@implementation XLCRESTfulClient

+ (void)initClient
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelError);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://fdubbsrestapi.duapp.com"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // HACK: Set User-Agent to Mac OS X so that Twitter will let us access the Timeline
    /*
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]]];
     */
    [client setDefaultHeader:@"User-Agent" value:@"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    // Setup post resource mapping and path mapping
    [self initPostResources:objectManager];
    
    
    NSLog(@"fxxk");
}

+ (void) initPostResources:(RKObjectManager *)objectManager
{
    [self addObjectMappingForClass:[XLCPostSummary class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/post/top10" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCPostDetail class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/post/detail/board/:boardName/:postId" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCPostReplies class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/post/reply/bid/:boardId/:mainPostId/:lastReplyId" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCSectionMetaData class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/section/all" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCSection class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/section/detail/:sectionId" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCPostSummaryInBoard class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/post/summary/board/:boardName/:listMode" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCPostSummaryInBoard class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/post/summary/board/:boardName/:listMode/:startNum" toObjectManager:objectManager];
    
    
    [self addObjectMappingForClass:[XLCBoardDetail class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/board/favor" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCLoginResponse class] method:RKRequestMethodPOST
                       pathPattern:@"/api/v1/user/login" toObjectManager:objectManager];
    
    [self addObjectMappingForClass:[XLCLogoutResponse class] method:RKRequestMethodGET
                       pathPattern:@"/api/v1/user/logout" toObjectManager:objectManager];
}


+ (void) addObjectMappingForClass:(Class)objectClass
                           method:(RKRequestMethod)method
                      pathPattern:(NSString *)pathPattern
                  toObjectManager:(RKObjectManager *)objectManager
{
    RKObjectMapping *responseMapping = [objectClass performSelector:@selector(objectMapping)];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                        method:method
                                                                                   pathPattern:pathPattern
                                                                                       keyPath:nil
                                                                                   statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
}

@end
