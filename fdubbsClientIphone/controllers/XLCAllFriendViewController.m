//
//  XLCAllFriendViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-9-7.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCAllFriendViewController.h"
#import "XLCActivityIndicator.h"
#import "EGORefreshTableHeaderView.h"
#import "XLCFriendManager.h"
#import "XLCFriend.h"

@interface XLCAllFriendViewController () <UITableViewDelegate, UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    __block BOOL _reloading;
    
    
    __block NSArray *_friendList;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XLCAllFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _refreshHeaderView = nil;
        _friendList = nil;
        _reloading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self addRefreshViewController];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", @"viewWillAppear here.");
    
    [self.tableView reloadData];
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
    
    // load new mails
    
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
    
    
    
    void (^successBlock)(NSArray *) = ^(NSArray *friends)
    {
        
        DebugLog(@"Success to load online friends!");
        _friendList = friends;
        
        
        [self.tableView reloadData];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    [[XLCFriendManager sharedXLCFriendManager] doLoadAllFriendsWithSuccessBlock:successBlock failBlock:failBlock];
    [XLCActivityIndicator showLoadingOnView:self.view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView
                                                dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCFriend *friend = [_friendList objectAtIndex:indexPath.row];
    [[cell textLabel] setText:friend.userId];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_friendList count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end