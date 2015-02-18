//
//  DetailTweetViewController.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "DetailTweetCell.h"
#import "InfoCell.h"
#import "ButtonCell.h"
#import "ComposeViewController.h"


@interface DetailTweetViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation DetailTweetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHomeButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTweetCell" bundle:nil] forCellReuseIdentifier:@"DetailTweetCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:@"ButtonCellID"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DetailTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTweetCellID"];
        cell.nameLabel.text = self.tweet.user.name;
        cell.screennameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
        [cell.userProfileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM d HH:mm:ss"];
        cell.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];
        cell.tweetTextLabel.text = self.tweet.text;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellID"];
        cell.favTextLabel.text = @"FAVORITES";
        
        cell.favCountLabel.text = [NSString stringWithFormat: @"%ld", self.tweet.favCount];
        cell.retweetTextLabel.text = @"RETWEETS";
        cell.retweetCountLabel.text = [NSString stringWithFormat:@"%ld",self.tweet.retweetCount];
        
        return cell;
        
    } else {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCellID"];
        
        [cell.replyButton addTarget:self action:@selector(onReplyTweetClicked:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.retweetButton addTarget:self action:@selector(onRetweetClicked:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.starButton addTarget:self action:@selector(onFavoriteClicked:)  forControlEvents:UIControlEventTouchUpInside];
        
//        if (self.tweet.favorited) {
//            UIImage *image = [UIImage imageNamed:@"favorite_on"];
//            [cell.starButton setImage:image forState:UIControlStateNormal];
//
//        } else {
//            UIImage *image = [UIImage imageNamed:@"favorite_hover"];
//            [cell.starButton setImage:image forState:UIControlStateNormal];
//        }
//        
        if (self.tweet.retweeted) {
            NSLog(@"retweeted");
            UIImage *image = [UIImage imageNamed:@"retweet_on"];
            [cell.retweetButton setImage:image forState:UIControlStateNormal];

        } else {
            UIImage *image = [UIImage imageNamed:@"retweet_hover"];
            [cell.retweetButton setImage:image forState:UIControlStateNormal];

        }
//
//        [cell.starButton setSelected:self.tweet.favorited];
//        [cell.retweetButton setSelected:self.tweet.retweeted];
        return cell;
        
    }
    
    
    
}




- (void) onHomeButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) onReplyButton {
    
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


-(void)onReplyTweetClicked:(UIButton*)sender
{
    BOOL reply = 1;
    [[NSUserDefaults standardUserDefaults] setBool:reply forKey:@"mode"];
    NSString *referenceTweetUsername = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenname];
    [[NSUserDefaults standardUserDefaults] setObject:referenceTweetUsername forKey:@"reference"];
    [[NSUserDefaults standardUserDefaults] setObject:self.tweet.id_str forKey:@"in_reply_to_status_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    nvc.navigationBar.translucent = NO;
    [self presentViewController:nvc animated:YES completion:nil];
    

}

-(void)onRetweetClicked:(UIButton*)sender
{
    [[TwitterClient sharedInstance] retweetStatus:self.tweet.id_str completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"retweet succeed");
    }];
//    UIImage *image = [UIImage imageNamed:@"retweet_on"];
//    [sender setImage:image forState:UIControlStateNormal];
     //[sender setSelected:YES];
}
-(void)onFavoriteClicked:(UIButton*)sender
{
    
}
@end
