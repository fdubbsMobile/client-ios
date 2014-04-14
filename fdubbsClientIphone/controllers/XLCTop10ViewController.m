//
//  XLCTop10ViewController.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//
#import "ProgressHUD.h"

#import "XLCUtil.h"

#import "XLCTop10ViewController.h"
#import "UIViewController+ScrollingNavbar.h"

#import "XLCPostManager.h"
#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCPostSummaryViewCell.h"

@interface XLCTop10ViewController () {
    __block NSArray *top10Posts;
}

@end

@implementation XLCTop10ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"今日十大";
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    void (^successBlock)(NSArray *) = ^(NSArray *topPosts){
        top10Posts = topPosts;
        DebugLog(@"Success to load top 10 posts!");
        [self.tableView reloadData];
    };
    
    [ProgressHUD show:@"正在努力地登录中..."];
    [[XLCPostManager sharedXLCPostManager] doLoadTop10Posts:successBlock];
    
    //[self addRefreshViewController];
    DebugLog(@"init XLCTop10ViewController");

}

-(void)addRefreshViewController{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2.0f];
}

-(void)loadData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top10PostCell";
    XLCPostSummaryViewCell *cell = (XLCPostSummaryViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCPostSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCPostSummary *post = [top10Posts objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = post.metaData.title;
    cell.replyCountLabel.text = [NSString stringWithFormat:@"回复:%@", post.count];
    cell.onwerLabel.text = [NSString stringWithFormat:@"楼主:%@", post.metaData.owner];
    cell.boardLabel.text = [NSString stringWithFormat:@"版面:%@", post.metaData.board];
    
    cell.rowIndex = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [top10Posts count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}


@end

