//
//  XLCFlatSettings.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCFlatSettings.h"

@implementation XLCFlatSettings

+ (XLCFlatSettings *)sharedInstance
{
    static dispatch_once_t once;
    static XLCFlatSettings *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[XLCFlatSettings alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        _mainColor = [UIColor colorWithRed:0.35f green:0.51f blue:0.91f alpha:1.00f];
        _backgroundColor = [UIColor whiteColor];
        _textFieldPlaceHolderColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
        _secondColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
        _font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        _iconImageColor = [UIColor whiteColor];
    }
    return self;
}



@end
