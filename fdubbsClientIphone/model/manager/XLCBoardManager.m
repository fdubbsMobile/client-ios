//
//  XLCBoardManager.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardManager.h"

@implementation XLCBoardManager

SINGLETON_GCD(XLCBoardManager);

- (id) init {
    if ( (self = [super init]) ) {
        // Initialization code here.
    }
    return self;
}


- (void) doLoadAllSectionsWithSuccessBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:@"/api/v1/section/all"
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray *allSections = [mappingResult array];
                                success(allSections);
                                NSLog(@"Loaded all sections : %@", allSections);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

- (void) doLoadAllBoardsInSection:(NSString *)sectionId successBlock:(void (^)(XLCSection *))success
                        failBlock:(void (^)(NSError *))failure
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/section/detail/%@", sectionId];
    NSLog(@"path is %@", path);
    
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                XLCSection *section = [mappingResult firstObject];
                                success(section);
                                NSLog(@"Loaded section %@ : %@", sectionId, section);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

@end
