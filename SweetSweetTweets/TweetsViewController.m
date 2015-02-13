//
//  TweetsViewController.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/10/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailTweetViewController.h"
#import "SVPullToRefresh.h"

@interface TweetsViewController () <UITableViewDataSource,UITableViewDelegate>
//- (IBAction)onLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@end

@implementation TweetsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop];
    }];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.title = @"Home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 128; //UITableViewAutomaticDimension;
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCellID"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCellID"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    NSLog(@"section: %ld", (long)indexPath.section);
    
    [cell.userProfileImageView setImageWithURL: [NSURL URLWithString:tweet.user.profileImageUrl]];
    
    cell.nameLabel.text = tweet.user.name;
    NSMutableString *screenname =[[NSMutableString alloc] initWithString:@"@"];
    [screenname appendString:tweet.user.screenname];
    cell.screenNameLabel.text = screenname;
    cell.tweetTextLabel.text = tweet.text;
    NSTimeInterval timeInterval = fabs([tweet.createdAt timeIntervalSinceNow]);
    int hour;
    int min;
    int sec;
    NSString *timeElapsed;
    if (timeInterval > 3600) {
        hour = timeInterval/3600;
        timeElapsed = [NSString stringWithFormat:@"%dh", hour];
    } else if(timeInterval > 60) {
        min = timeInterval / 60;
        timeElapsed = [NSString stringWithFormat:@"%dm", min];
        
    } else {
        sec = timeInterval;
        timeElapsed = [NSString stringWithFormat:@"%ds", sec];
        
    }
    cell.createdAtLabel.text = timeElapsed;
    cell.retweetFromLabel.text = @"";
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailTweetViewController *dvc = [[DetailTweetViewController alloc] init];
    dvc.tweet = self.tweets[indexPath.row];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
    nvc.navigationBar.translucent = NO;
    [self presentViewController:nvc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void) onSignOutButton {
    [User logout];
}


- (void) onNewButton {
    
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    nvc.navigationBar.translucent = NO;
    [self presentViewController:nvc animated:YES completion:nil];
    
}

- (void)insertRowAtTop {
    
    int64_t delayInSeconds = 2.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            
            self.tweets = tweets;
            [self.tableView reloadData];
            //set the scroll index so that the new data will show on top of screen
            NSLog(@"twee count: %lu", (unsigned long)self.tweets.count);
//            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
        }];
        
        
        
        [self.tableView.pullToRefreshView stopAnimating];
    });
    
}

@end
