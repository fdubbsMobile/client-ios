//
//  XLCCustomLinkView.m
//  DWTagList
//
//  Created by dennis on 14-5-4.
//  Copyright (c) 2014年 Terracoding LTD. All rights reserved.
//

#import "XLCCustomLinkView.h"

#define CORNER_RADIUS 10.0f
//#define LABEL_MARGIN_DEFAULT 5.0f
//#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 13.0f
#define HORIZONTAL_PADDING_DEFAULT 7.0f
#define VERTICAL_PADDING_DEFAULT 3.0f
//#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f
//#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
//#define DEFAULT_AUTOMATIC_RESIZE NO
//#define DEFAULT_SHOW_TAG_MENU NO
#define MINIMU_WIDTH  0.0f
#define DEFAULT_WIDTH  200.0f
#define DEFAULT_HEIGHT  50.0f

@interface XLCCustomLinkView () {
    CGFloat horizontalPadding;
    CGFloat verticalPadding;
    UIFont* font;
    CGSize padding;
    CGFloat minimumWidth;
}
@end

@implementation XLCCustomLinkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        //CGRect rect = [[UIScreen mainScreen] bounds];
        //CGFloat defaultWidth = rect.size.width;
        CGRect defaultFrame = CGRectMake(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
        self.frame = defaultFrame;
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_label setTextColor:TEXT_COLOR];
    [_label setShadowColor:TEXT_SHADOW_COLOR];
    [_label setShadowOffset:TEXT_SHADOW_OFFSET];
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_label];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_button setFrame:self.frame];
    [self addSubview:_button];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:CORNER_RADIUS];
    [self.layer setBorderColor:BORDER_COLOR];
    [self.layer setBorderWidth:BORDER_WIDTH];
    
    horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
    verticalPadding = VERTICAL_PADDING_DEFAULT;
    font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
    
    padding = CGSizeMake(horizontalPadding, verticalPadding);
    minimumWidth = MINIMU_WIDTH;
}

- (void)updateWithString:(id)text
{
    CGSize textSize = CGSizeZero;
    BOOL isTextAttributedString = [text isKindOfClass:[NSAttributedString class]];
    
    CGFloat maxWidth = self.frame.size.width - (horizontalPadding * 2);
    if (maxWidth <= 0) {
        maxWidth = self.frame.size.width + (horizontalPadding * 2);
    }
    
    if (isTextAttributedString) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, ((NSAttributedString *)text).string.length)];
        
        textSize = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _label.attributedText = [attributedString copy];
    } else {
        textSize = [text sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
        _label.text = text;
    }
    
    textSize.width = MAX(textSize.width, minimumWidth);
    textSize.height += padding.height*2;
    
    CGRect frame = self.frame;
    frame.size.width = textSize.width+padding.width*2;
    frame.size.height = textSize.height;
    self.frame = frame;
    
    _label.frame = CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    _label.font = font;
    
    [_button setAccessibilityLabel:self.label.text];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    [self.layer setBorderColor:borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

- (void)setLabelText:(NSString*)text
{
    [_label setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_label setTextColor:textColor];
}

- (void)setTextShadowColor:(UIColor*)textShadowColor
{
    [_label setShadowColor:textShadowColor];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset
{
    [_label setShadowOffset:textShadowOffset];
}

- (void)dealloc
{
    _label = nil;
    _button = nil;
}

#pragma mark - UIMenuController support

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:)) || (action == @selector(delete:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.label.text];
}

- (void)delete:(id)sender
{
    // TODO : add
}

@end
