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
#import "XLCParagraphContent.h"
#import "XLCParagraph.h"
#import "XLCPostDetail.h"

@implementation XLCRESTfulClient

+ (void)initClient
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://rest-api-for-fdubbs.herokuapp.com"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // HACK: Set User-Agent to Mac OS X so that Twitter will let us access the Timeline
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]]];
    
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
    RKObjectMapping *postMetaDataMapping = [RKObjectMapping mappingForClass:[XLCPostMetaData class]];
    [postMetaDataMapping addAttributeMappingsFromDictionary:@{
                                                      @"post_id" : @"postId",
                                                      @"title" : @"title",
                                                      @"owner" : @"owner",
                                                      @"nick" : @"nick",
                                                      @"date" : @"date",
                                                      @"board" : @"board"
                                                      }];
    
    
    RKObjectMapping *postSummaryMapping = [RKObjectMapping mappingForClass:[XLCPostSummary class]];
    [postSummaryMapping addAttributeMappingsFromDictionary:@{
                                                              @"count" : @"count",
                                                              @"mark_sign" : @"markSign",
                                                              @"is_sticky" : @"sticky",
                                                              @"is_no_reply" : @"nonReply"
                                                              }];
    
    
    RKRelationshipMapping* postMetaRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"post_meta_data"
                                                                                             toKeyPath:@"metaData"
                                                                                           withMapping:postMetaDataMapping];
    [postSummaryMapping addPropertyMapping:postMetaRSMapping];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *topPostRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:postSummaryMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/v1/post/top10"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:topPostRespDesc];
    
    
    RKObjectMapping *paraContentMapping = [RKObjectMapping mappingForClass:[XLCParagraphContent class]];
    [paraContentMapping addAttributeMappingsFromDictionary:@{
                                                              @"br" : @"isNewLine",
                                                              @"l" : @"isLink",
                                                              @"i" : @"isImage",
                                                              @"lr" : @"linkRef",
                                                              @"c" : @"content"
                                                              }];
    
    RKObjectMapping *paragraphMapping = [RKObjectMapping mappingForClass:[XLCParagraph class]];
    RKRelationshipMapping* paraContentRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"c"
                                                                                             toKeyPath:@"paraContent"
                                                                                           withMapping:paraContentMapping];
    [paragraphMapping addPropertyMapping:paraContentRSMapping];
    
    RKObjectMapping *postDetailMapping = [RKObjectMapping mappingForClass:[XLCPostDetail class]];
    
    RKRelationshipMapping* postBodyRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"body"
                                                                                              toKeyPath:@"body"
                                                                                            withMapping:paragraphMapping];
    RKRelationshipMapping* postQouteRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"qoute"
                                                                                           toKeyPath:@"qoute"
                                                                                         withMapping:paragraphMapping];
    RKRelationshipMapping* postSignRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"sign"
                                                                                            toKeyPath:@"sign"
                                                                                          withMapping:paragraphMapping];
    RKRelationshipMapping* postReplyRSMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"replies"
                                                                                           toKeyPath:@"replies"
                                                                                         withMapping:postDetailMapping];
    [postDetailMapping addPropertyMapping:[postMetaRSMapping copy]];
    
    [postDetailMapping addPropertyMapping:postBodyRSMapping];
    [postDetailMapping addPropertyMapping:postQouteRSMapping];
    [postDetailMapping addPropertyMapping:postSignRSMapping];
    [postDetailMapping addPropertyMapping:postReplyRSMapping];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *postDetailRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:postDetailMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/v1/post/detail/board/:boardName/:postId"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:postDetailRespDesc];
}

@end
