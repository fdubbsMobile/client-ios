//
//  XLCMailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCMailViewController.h"
#import "FRDLivelyButton.h"
#import "XLCMailManager.h"
#import "XLCMailSummary.h"
#import "XLCMailSummaryInBox.h"
#import "XLCMailSummaryViewCell.h"
#import "XLCMailDetailPassValueDelegate.h"

@interface XLCMailViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __block NSArray *_mailList;
    
    __block NSUInteger _startNumber;
    __block XLCMailSummaryInBox *_mailSummaryInbox;
    
    NSObject<XLCMailDetailPassValueDelegate> *mailDetailPassValueDelegte ;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSwitchControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XLCMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mailList = nil;
        _startNumber = 0;
        _mailSummaryInbox = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    //NavBar tint color for elements:
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    FRDLivelyButton *leftBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,25)];
    [leftBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                 kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                 kFRDLivelyButtonColor: [UIColor whiteColor]
                                 }];
    [leftBarButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:NO];
    [leftBarButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    FRDLivelyButton *rightBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,25,20)];
    [rightBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                  kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                  kFRDLivelyButtonColor: [UIColor whiteColor]
                                  }];
    [rightBarButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    //[rightBarButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    self.title = @"我的信件";
    self.titleColor = [UIColor whiteColor];
    
    self.subtitle = @"我的账号";
    self.subtitleColor = [UIColor whiteColor];
    
    [_segSwitchControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}

-(void)loadData
{
    
    
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        // load new mails
        if (_mailList == nil) {
            void (^successBlock)(NSArray *) = ^(NSArray *mails)
            {
            
                DebugLog(@"Success to load new mails!");
                _mailList = mails;
            
                [self.tableView reloadData];
            
            };
            [[XLCMailManager sharedXLCMailManager] doLoadNewMailsWithSuccessBlock:successBlock failBlock:failBlock];
        } else {
            [self.tableView reloadData];
        }
        
    } else if (_segSwitchControl.selectedSegmentIndex == 1){
        // load all mails
        if (_mailSummaryInbox == nil) {
            void (^successBlock)(XLCMailSummaryInBox *) = ^(XLCMailSummaryInBox *mailSummaryInbox)
            {
            
                DebugLog(@"Success to load all mails!");
                _mailSummaryInbox = mailSummaryInbox;
                _startNumber = mailSummaryInbox.startMailNum;
            
                [self.tableView reloadData];
            
            };
        
            [[XLCMailManager sharedXLCMailManager] doLoadAllMailsInBoxWithStartNumber:_startNumber successBlock:successBlock failBlock:failBlock];
        } else {
            [self.tableView reloadData];
        }
    }
    
}

- (XLCMailSummary *)getMailSummaryByIndex:(NSUInteger)index
{
    XLCMailSummary *mailSummary;
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        mailSummary = [_mailList objectAtIndex:index];
    } else if (_segSwitchControl.selectedSegmentIndex == 1) {
        mailSummary = [_mailSummaryInbox.mailSummaryList objectAtIndex:index];
    }
    
    return mailSummary;
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
    
    XLCMailSummary *mailSummary = [self getMailSummaryByIndex:indexPath.row];
    
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
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        return [_mailList count];
    } else if (_segSwitchControl.selectedSegmentIndex == 1) {
        return [_mailSummaryInbox.mailSummaryList count];
    }
    
    return 0;
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

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    NSLog(@"Select %ld", (long)_segSwitchControl.selectedSegmentIndex);
    [self loadData];
    
    if ([self tableView:self.tableView numberOfRowsInSection:0] > 0) {
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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
        XLCMailSummary *mailSummary = [self getMailSummaryByIndex:selectedIdx];
        XLCMailMetaData *metaData = mailSummary.mailMetaData;
        mailDetailPassValueDelegte = (NSObject<XLCMailDetailPassValueDelegate> *)destination;
        [mailDetailPassValueDelegte passValueWithMailNumber:metaData.mailNumber mailLink:metaData.mailLink];
    }
}


@end
