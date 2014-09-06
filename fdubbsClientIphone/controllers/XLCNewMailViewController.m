//
//  XLCMailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCNewMailViewController.h"
#import "FRDLivelyButton.h"
#import "XLCMailManager.h"
#import "XLCMailSummary.h"
#import "XLCMailSummaryInBox.h"
#import "XLCMailSummaryViewCell.h"
#import "XLCMailDetailPassValueDelegate.h"
#import "XLCActivityIndicator.h"
#import "EGORefreshTableHeaderView.h"

@interface XLCNewMailViewController () <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    __block BOOL _reloading;
    
    
    __block NSMutableArray *_mailList;

    NSObject<XLCMailDetailPassValueDelegate> *mailDetailPassValueDelegte ;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XLCNewMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mailList = nil;
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
    
    
    
    void (^successBlock)(NSArray *) = ^(NSArray *mails)
    {
        
        DebugLog(@"Success to load new mails!");
        //_mailList = mails;
        _mailList = [[NSMutableArray alloc] initWithArray:mails];
        
        [self.tableView reloadData];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    [[XLCMailManager sharedXLCMailManager] doLoadNewMailsWithSuccessBlock:successBlock failBlock:failBlock];
    [XLCActivityIndicator showLoadingOnView:self.view];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mailViewCell";
    XLCMailSummaryViewCell *cell = (XLCMailSummaryViewCell *)[tableView
                                                dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCMailSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCMailSummary *mailSummary = [_mailList objectAtIndex:indexPath.row];
    
    XLCMailMetaData *metaData = mailSummary.mailMetaData;
    //[[cell textLabel] setText:[[mailSummary mailMetaData] title]];
    [[cell senderLabel] setText:[metaData sender]];
    [[cell dateLabel] setText:[metaData date]];
    [[cell titleLabel] setText:[metaData title]];
    cell.index = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_mailList count];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showMailDetail"])
    {
        NSLog(@"showMailDetail");
        NSInteger selectedIdx = [(XLCMailSummaryViewCell *)sender index];
        XLCMailSummary *mailSummary = [_mailList objectAtIndex:selectedIdx];
        XLCMailMetaData *metaData = mailSummary.mailMetaData;
        mailDetailPassValueDelegte = (NSObject<XLCMailDetailPassValueDelegate> *)destination;
        [mailDetailPassValueDelegte passValueWithMailNumber:metaData.mailNumber mailLink:metaData.mailLink];
        [_mailList removeObjectAtIndex:selectedIdx];
    }
}


@end
