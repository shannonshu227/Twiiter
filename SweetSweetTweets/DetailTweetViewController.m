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


@interface DetailTweetViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation DetailTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(onHomeButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];

//
//    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
//    self.nameLabel.text = self.tweet.user.name;
//    NSMutableString *screenname = [[NSMutableString alloc] initWithString:@"@"];
//    [screenname appendString:self.tweet.user.screenname];
//    self.screennameLabel.text = screenname;
//    NSLog(@"SCREEN:%@", screenname);
//    self.userProfileImageView.layer.cornerRadius = 5;
//    self.tweetTextLabel.text = self.tweet.text;
//    NSLog(@"text:%@", self.tweet.text);
//    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"EEE MMM d HH:mm:ss"];
//    self.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    
    
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
        return cell;

    } else {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCellID"];
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

@end
