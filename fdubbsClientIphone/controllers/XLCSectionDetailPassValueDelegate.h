//
//  XLCSectionDetailPassValueDelegate.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-6-5.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLCSectionDetailPassValueDelegate <NSObject>

-(void) passValueWithSectionDesc:(NSString *)sectionDesc category:(NSString *)category sectionId:(NSString *)sectionId;

@end
