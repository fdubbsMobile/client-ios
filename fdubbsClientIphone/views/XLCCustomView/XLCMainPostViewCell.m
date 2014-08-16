//
//  XLCPostDetailViewCell.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-26.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMainPostViewCell.h"

@implementation XLCMainPostViewCell



- (void)setupWithPostDetail:(XLCPostDetail *)postDetail PostOwner:(NSString *)postOwner
                    AtIndexPath:(NSIndexPath *)index
{
    heightOfCell = INITIAL_HEIGHT;
    section = index.section;
    row = index.row;
    hasQuote = (postDetail.qoute != nil);
    
    NSLog(@"has qoute : %@", hasQuote ? @"yes" : @"no");
    
    [self constructPostMetadata:postDetail];
    
    [self constructPostContent:postDetail];
    
    //[self constructPostQoute:postDetail];
    
    [self adjustViewHeight];
    [self addBottomBorderForView:self];
    
}

#pragma mark Load Post Metadata
- (void)constructPostMetadata:(XLCPostDetail *)postDetail
{
    [self layoutPostSubMetaDataView:postDetail];
    
    [self layoutTitleLabel:[NSString stringWithFormat:@"%@", postDetail.metaData.title]];
    
    CGRect frame = self.postMetadataView.frame;
    frame.size.height = self.postSubMetaView.frame.size.height + self.titleLabel.frame.size.height + 5;
    self.postMetadataView.frame = frame;
    
    heightOfCell += self.postMetadataView.frame.size.height;
    
}

- (void)layoutPostSubMetaDataView:(XLCPostDetail *)postDetail
{
    [self layoutOwnerLabel:[NSString stringWithFormat:@"%@", postDetail.metaData.owner]];
    [self layoutOwnerButton];
    
    
    [self layoutBoardLabel:[NSString stringWithFormat:@"%@版", postDetail.metaData.board]];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", postDetail.metaData.date];
    
    //CGRect frame = self.postSubMetaView.frame;
    //frame.size.height = self.ownerLabel.frame.size.height + self.boardLabel.frame.size.height + 5;
    //self.postSubMetaView.frame = frame;
}

- (void)layoutBoardLabel:(NSString *)board
{
    self.boardLabel.numberOfLines = 0;
    CGRect frame = self.boardLabel.frame;
    
    CGSize textSize = CGSizeMake(MAXFLOAT, frame.size.height);
    CGRect textRect = [board boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.boardLabel.font}
                                          context:nil];
    
    frame.size.width = textRect.size.width;
    self.boardLabel.frame = frame;
    self.boardLabel.text = board;
}


- (void)layoutOwnerLabel:(NSString *)owner
{
    self.ownerLabel.numberOfLines = 0;
    CGRect frame = self.ownerLabel.frame;
    
    CGSize textSize = CGSizeMake(MAXFLOAT, frame.size.height);
    CGRect textRect = [owner boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.ownerLabel.font}
                                          context:nil];
    
    frame.size.width = textRect.size.width;
    self.ownerLabel.frame = frame;
    self.ownerLabel.text = owner;
    
}

- (void)layoutOwnerButton
{
    [self.ownerButton successStyle];
    CGRect frame = self.ownerButton.frame;
    frame.origin.x = self.ownerLabel.frame.origin.x + self.ownerLabel.frame.size.width + 5;
    
    self.ownerButton.frame = frame;
}


- (void)layoutTitleLabel:(NSString *)title
{
    self.titleLabel.numberOfLines = 0;
    CGRect frame = self.titleLabel.frame;
    
    CGSize textSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGRect textRect = [title boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.titleLabel.font}
                                          context:nil];
    
    frame.size.height = textRect.size.height;
    frame.origin.y = self.postSubMetaView.frame.origin.y + self.postSubMetaView.frame.size.height+ 5;
    self.titleLabel.frame = frame;
    self.titleLabel.text = title;
}


#pragma mark Load Post Content

- (void)constructPostContent:(XLCPostDetail *)postDetail
{
    
    XLCContent *content = postDetail.body;
    
    NIAttributedLabel *postContentLabel =
    [self getRichContentLabelWithContent:content
                                    Font:[UIFont systemFontOfSize:15] fitsView:self.postContentView];
    
    [self.postContentView addSubview:postContentLabel];
    
    CGSize size = [postContentLabel sizeThatFits:CGSizeMake(self.postContentView.bounds.size.width, CGFLOAT_MAX)];
    postContentLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGRect contentFrame = self.postContentView.frame;
    contentFrame.origin.y = self.postMetadataView.frame.origin.y + self.postMetadataView.frame.size.height + 15;
    contentFrame.size.height = postContentLabel.frame.size.height;
    self.postContentView.frame = contentFrame;
    
    heightOfCell += self.postContentView.frame.size.height;

}

- (void)constructPostQoute:(XLCPostDetail *)postDetail
{
    if (!hasQuote) {
        return;
    }
    
    return;
    
    [self layoutPostQouteView];
    [self layoutPostQouteLabel:postDetail];
    [self layoutPostQouteBackgroundImage];
    
    heightOfCell += self.postQouteView.frame.size.height + 15;
}

- (void)layoutPostQouteView
{
    CGRect contentFrame = self.postContentView.frame;
    CGFloat x = contentFrame.origin.x;
    CGFloat y = contentFrame.origin.y + contentFrame.size.height + 15;
    CGFloat width = contentFrame.size.width;
    
    CGRect qouteFrame = CGRectMake(x, y, width, 0);
    self.postQouteView = [[UIView alloc] initWithFrame:qouteFrame];
    
    [self addSubview:self.postQouteView];
    
}

- (void)layoutPostQouteLabel:(XLCPostDetail *)postDetail
{
    
    XLCPostQoute *qoute = postDetail.qoute;
    XLCContent *content = [[XLCContent alloc] init];
    content.images = nil;
    content.text = qoute.content;
    
    
    NIAttributedLabel *postQouteLabel =
    [self getRichContentLabelWithContent:content
                                    Font:[UIFont systemFontOfSize:13] fitsView:self.postQouteView];
    
    [self.postQouteView addSubview:postQouteLabel];
    
    
    CGRect qouteFrame = self.postQouteView.frame;
    qouteFrame.size.height = postQouteLabel.frame.size.height + 10;
    self.postQouteView.frame = qouteFrame;
}

- (void)layoutPostQouteBackgroundImage
{
    UIImage *stretchableImage = [[UIImage imageNamed:@"quoteBackground"]
                                 stretchableImageWithLeftCapWidth:130 topCapHeight:14];
    UIImageView *qouteBgView = [[UIImageView alloc] initWithImage:stretchableImage];
    
    CGRect qouteFrame = self.postQouteView.frame;
    CGFloat x = qouteFrame.origin.x - 15;
    CGFloat y = qouteFrame.origin.y - 10;
    CGFloat width = qouteFrame.size.width + 30;
    CGFloat height = qouteFrame.size.height + 15;
    
    CGRect qouteBgFrame = CGRectMake(x, y, width, height);
    qouteBgView.frame = qouteBgFrame;
    [self addSubview:qouteBgView];
    
}

- (NIAttributedLabel *)getRichContentLabelWithContent:(XLCContent *)content
                                                 Font:(UIFont *)font fitsView:(UIView *)theView
{
    NIAttributedLabel *richContentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
    
    
    NSArray *images = content.images;
    NSString *contentValue = content.text;
    
    if (hasQuote) {
        contentValue = [contentValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSLog(@"content value : %@", contentValue);
    
    richContentLabel.numberOfLines = 0;
    richContentLabel.autoDetectLinks = YES;
    richContentLabel.lineBreakMode = NSLineBreakByClipping;
    richContentLabel.font = font;
    richContentLabel.text = [contentValue copy];
    
    for (XLCImage *image in images) {
        XLCCustomLinkView *imageLinkView = [[XLCCustomLinkView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [imageLinkView updateWithString:@"图片链接"];
        imageLinkView.linkRef = image.ref;
        imageLinkView.position = image.pos;
        
        [richContentLabel insertView:imageLinkView atIndex:imageLinkView.position margins:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    
    
    CGSize size = [richContentLabel sizeThatFits:CGSizeMake(theView.bounds.size.width, CGFLOAT_MAX)];
    richContentLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    return richContentLabel;
}


@end
