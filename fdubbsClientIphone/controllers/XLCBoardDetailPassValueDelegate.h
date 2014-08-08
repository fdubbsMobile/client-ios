//
//  XLCBoardDetailPassValueDelegate.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-8.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLCBoardDetailPassValueDelegate <NSObject>

-(void) passValueWithBoardTitle:(NSString *)title description:(NSString *)description boardId:(NSUInteger)boardId;

@end
