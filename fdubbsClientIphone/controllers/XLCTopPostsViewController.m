//
//  XLCTopPostsViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-17.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//


#import "EGORefreshTableHeaderView.h"
#import "XLCTopPostsViewController.h"

#import "XLCPostManager.h"
#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCTopPostSummaryViewCell.h"
#import "XLCActivityIndicator.h"

#import "XLCPostDetailPassValueDelegate.h"

@interface XLCTopPostsViewController () <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    __block BOOL _reloading;
    
    NSObject<XLCPostDetailPassValueDelegate> *postDetailPassValueDelegte ;
}

@property  __block NSArray *top10Posts;

@end

@implementation XLCTopPostsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _top10Posts = nil;
        _reloading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self addRefreshViewController];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"今日十大";
    self.titleColor = [UIColor whiteColor];
    
    // Set the barTintColor (if available). This will determine the overlay that fades in and out upon scrolling.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        //[self.navigationController.navigationBar setBarTintColor:[[XLCFlatSettings sharedInstance] mainColor]];
        //[self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    }
    
    DebugLog(@"init XLCTopPostsViewController");
    
    [self performSelector:@selector(initRefreshTopPosts) withObject:nil afterDelay:0.1];
}

- (void)initRefreshTopPosts
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadData];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

-(void)loadData
{
    
    _reloading = YES;
    
    void (^successBlock)(NSArray *) = ^(NSArray *topPosts)
    {
        _top10Posts = topPosts;
        DebugLog(@"Success to load top 10 posts!");
        
        [self.tableView reloadData];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [XLCActivityIndicator hideOnView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCPostManager sharedXLCPostManager] doLoadTop10PostsWithSuccessBlock:successBlock failBlock:failBlock];
    //[indicatorView startAnimating];
    [XLCActivityIndicator showLoadingOnView:self.view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top10PostCell";
    XLCTopPostSummaryViewCell *cell = (XLCTopPostSummaryViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCTopPostSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCPostSummary *postSummary = [_top10Posts objectAtIndex:indexPath.row];
    
    [cell setUpWithPostSummary:postSummary AtRow:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_top10Posts count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        //[refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
    }
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showPostDetail"])
    {
        NSLog(@"showPostDetail");
        NSInteger selectedIdx = [(XLCTopPostSummaryViewCell *)sender rowIndex];
        XLCPostSummary *selectedPost = [_top10Posts objectAtIndex:selectedIdx];
        postDetailPassValueDelegte = (NSObject<XLCPostDetailPassValueDelegate> *)destination;
		[postDetailPassValueDelegte passValueWithTitle:selectedPost.metaData.title board:selectedPost.metaData.board postId:selectedPost.metaData.postId];
	}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
