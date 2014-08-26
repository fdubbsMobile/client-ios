//
//  XLCFavorBoardsViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCFavorBoardsViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MONActivityIndicatorView.h"
#import "XLCBoardManager.h"
#import "XLCBoardViewCell.h"
#import "XLCBoardDetail.h"
#import "XLCBoardMetaData.h"
#import "XLCBoardDetailPassValueDelegate.h"
#import "XLCUserManager.h"

@interface XLCFavorBoardsViewController () <EGORefreshTableHeaderDelegate, MONActivityIndicatorViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    __block MONActivityIndicatorView *indicatorView;
    __block NSArray *_favorBoards;
    
    NSObject<XLCBoardDetailPassValueDelegate> *boardDetailPassValueDelegte ;
    
    BOOL hasInitialized;
}
@end

@implementation XLCFavorBoardsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _favorBoards = nil;
        hasInitialized = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialize];
}

- (void) initialize
{
    BOOL hasUserLogin = [[XLCUserManager sharedXLCUserManager] hasUserAlreadyLogin];
    NSLog(@"hasUserLogin : %d", hasUserLogin);
    if (!hasUserLogin) {
        NSLog(@"performSegueWithIdentifier:doLogin");
        [self performSegueWithIdentifier:@"doLogin" sender:self];
        
        return;
    }
    
    
    if (hasInitialized) {
        NSLog(@"XLCFavorBoardsViewController has been initialized!");
        return;
    }
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 6;
    indicatorView.radius = 15;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
    [self addRefreshViewController];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = @"我的收藏";
    self.titleColor = [UIColor whiteColor];
    
    hasInitialized = TRUE;
    
    DebugLog(@"init XLCFavorBoardsViewController");
    
    [self performSelector:@selector(initRefreshFavorBoards) withObject:nil afterDelay:0.1];
    
}


- (void)initRefreshFavorBoards
{
    //[self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
    //[self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

-(void)doPullRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
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
    BOOL hasUserLogin = [[XLCUserManager sharedXLCUserManager] hasUserAlreadyLogin];
    NSLog(@"hasUserLogin : %d", hasUserLogin);
    if (!hasUserLogin) {
        [self performSegueWithIdentifier:@"doLogin" sender:self];
        return;
    }
    
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
    
    void (^successBlock)(NSArray *) = ^(NSArray *favorBoards)
    {
        
        DebugLog(@"Success to load favor boards!");
        _favorBoards = favorBoards;
        
        [self.tableView reloadData];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [indicatorView stopAnimating];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [indicatorView stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    NSString *authCode = [[XLCUserManager sharedXLCUserManager] getUserAuthCode];
    [[XLCBoardManager sharedXLCBoardManager] doLoadFavorBoardsWithAuthCode:authCode successBlock:successBlock failBlock:failBlock];
    [indicatorView startAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (_favorBoards == nil) {
        return 0;
    }
    
    return [_favorBoards count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"favorBoardCell";
    XLCBoardViewCell *cell = (XLCBoardViewCell *)[tableView
                                                  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCBoardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    XLCBoardDetail *boardDetail = (XLCBoardDetail *)[_favorBoards objectAtIndex:indexPath.row];
    XLCBoardMetaData *boardMetaData = boardDetail.metaData;
    [[cell description] setText:boardMetaData.boardDesc];
    [[cell title] setText:boardMetaData.title];
    cell.index = indexPath.row;
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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

#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showBoardDetail"])
    {
        NSLog(@"showBoardDetail");
        NSInteger selectedIdx = [(XLCBoardViewCell *)sender index];
        XLCBoardDetail *boardDetail = (XLCBoardDetail *)[_favorBoards objectAtIndex:selectedIdx];
        XLCBoardMetaData *boardMetaData = boardDetail.metaData;
        boardDetailPassValueDelegte = (NSObject<XLCBoardDetailPassValueDelegate> *)destination;
		[boardDetailPassValueDelegte passValueWithBoardTitle:boardMetaData.title description:boardMetaData.boardDesc boardId:boardMetaData.boardId];
	}
}


@end
