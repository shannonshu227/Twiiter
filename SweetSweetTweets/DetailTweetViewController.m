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


@interface DetailTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTextLabel;
- (IBAction)onReplyTweetButton:(UIButton *)sender;
- (IBAction)onFavoriteButton:(UIButton *)sender;

- (IBAction)onRetweetButton:(UIButton *)sender;

@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHomeButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];


    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    NSMutableString *screenname = [[NSMutableString alloc] initWithString:@"@"];
    [screenname appendString:self.tweet.user.screenname];
    self.screennameLabel.text = screenname;
    NSLog(@"SCREEN:%@", screenname);
    self.userProfileImageView.layer.cornerRadius = 5;
    self.tweetTextLabel.text = self.tweet.text;
    NSLog(@"text:%@", self.tweet.text);
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM d HH:mm:ss"];
    self.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];

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

- (IBAction)onReplyTweetButton:(UIButton *)sender {
    NSLog(@"reply click!");

    [[TwitterClient sharedInstance] replyStatus:self.tweet.user.id_str reply:@"hello" completion:^(Tweet *tweet, NSError *error) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onFavoriteButton:(UIButton *)sender {
}

- (IBAction)onRetweetButton:(UIButton *)sender {
    NSLog(@"retweet click!");
    [[TwitterClient sharedInstance] retweetStatus:self.tweet.user.id_str completion:^(Tweet *tweet, NSError *error) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
@end
