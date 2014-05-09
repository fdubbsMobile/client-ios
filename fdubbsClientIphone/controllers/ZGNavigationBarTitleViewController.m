//
//  ZGNavigationBarTitleViewController.m
//  ZGNavigationBarTitle
//
//  Created by Kyle Fang on 9/8/13.
//  Copyright (c) 2013 Kyle Fang. All rights reserved.
//

#import "ZGNavigationBarTitleViewController.h"
#import "ZGNavigationTitleView.h"
#import <objc/runtime.h>

static char UIViewControllerTitleKey;
static char UIViewControllerSubtitleKey;
static char UIViewControllerTitleColorKey;
static char UIViewControllerSubtitleColorKey;

@implementation UIViewController (ZGNavigationSubTitle)
@dynamic title;
@dynamic subtitle;
@dynamic titleColor;
@dynamic subtitleColor;


- (NSString *)titleColor
{
    return objc_getAssociatedObject(self, &UIViewControllerTitleColorKey);
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self willChangeValueForKey:@"titleColor"];
    objc_setAssociatedObject(self, &UIViewControllerTitleColorKey, titleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"titleColor"];
    [self updateTitleColorTo:titleColor];
}

- (void)updateTitleColorTo:(UIColor *)titleColor
{
    if ([self.navigationItem.titleView isKindOfClass:[ZGNavigationTitleView class]]) {
        [(ZGNavigationTitleView *) self.navigationItem.titleView setNavigationBarTitleFontColor:titleColor];
    }
}

- (NSString *)subTitleColor
{
    return objc_getAssociatedObject(self, &UIViewControllerSubtitleColorKey);
}

- (void)setSubtitleColor:(UIColor *)subtitleColor
{
    [self willChangeValueForKey:@"subtitleColor"];
    objc_setAssociatedObject(self, &UIViewControllerSubtitleColorKey, subtitleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"subtitleColor"];
    [self updateTitleColorTo:subtitleColor];
}

- (void)updateSubtitleColorTo:(UIColor *)subtitleColor
{
    if ([self.navigationItem.titleView isKindOfClass:[ZGNavigationTitleView class]]) {
        [(ZGNavigationTitleView *) self.navigationItem.titleView setNavigationBarSubtitleFontColor:subtitleColor];
    }
}

- (NSString *)title
{
    return objc_getAssociatedObject(self, &UIViewControllerTitleKey);
}

- (void)setTitle:(NSString *)title
{
    [self willChangeValueForKey:@"title"];
    objc_setAssociatedObject(self, &UIViewControllerTitleKey, title, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"title"];
    [self updateTitleTo:title];
    self.navigationItem.title = title;
}

- (NSString *)subtitle
{
    return objc_getAssociatedObject(self, &UIViewControllerSubtitleKey);
}

- (void)setSubtitle:(NSString *)subtitle
{
    [self willChangeValueForKey:@"subtitle"];
    objc_setAssociatedObject(self, &UIViewControllerSubtitleKey, subtitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"subtitle"];
    [self updateSubtitleTo:subtitle];
}

- (void)updateTitleTo:(NSString *)title
{
    if ([self.navigationItem.titleView isKindOfClass:[ZGNavigationTitleView class]]) {
        [(ZGNavigationTitleView *) self.navigationItem.titleView setNavigationBarTitle:title];
    }
}

- (void)updateSubtitleTo:(NSString *)subtitle
{
    if ([self.navigationItem.titleView isKindOfClass:[ZGNavigationTitleView class]]) {
        [(ZGNavigationTitleView *) self.navigationItem.titleView setNavigationBarSubtitle:subtitle];
    }
}

@end

@implementation ZGNavigationBarTitleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleViewToViewController:self.topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addTitleViewToViewController:viewController];
    [super pushViewController:viewController animated:animated];
}

- (void)addTitleViewToViewController:(UIViewController *)viewController
{
    if (!viewController.navigationItem.titleView) {
        CGFloat width = 0.95 * self.view.frame.size.width;
        ZGNavigationTitleView *titleView = [[ZGNavigationTitleView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        viewController.navigationItem.titleView = titleView;
        viewController.title = viewController.title.length ? viewController.title : viewController.navigationItem.title;
    }
}

@end
