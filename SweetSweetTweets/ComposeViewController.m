//
//  ComposeViewController.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/11/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"


@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;


@end

@implementation ComposeViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    self.tweetTextView.text = @"Compose your tweet here...";
//    self.tweetTextView.textColor = [UIColor grayColor];
//    self.textCountLabel.textColor = [UIColor grayColor];
    self.tweetTextView.text = @"";
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetTextView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    
    
    User *user = [User currentUser];
    
    [self.userProfileImageView setImageWithURL: [NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    NSMutableString *screenname = [[NSMutableString alloc] initWithString:@"@"];
    [screenname appendString:user.screenname];
    self.screennameLabel.text = screenname;
    self.userProfileImageView.layer.cornerRadius = 5;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) onTweetButton {
    NSString * tweetContent = self.tweetTextView.text;
    [[TwitterClient sharedInstance] createNewTweet:tweetContent completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"newtweet: %@", tweetContent);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
   // textView.text = @"";

}

- (void) textViewDidChange:(UITextView *) textView {
    textView.textColor = [UIColor blackColor];
    NSUInteger num =[self.tweetTextView.text length];
    NSString *numtext;
    if (num <= 140) {
        num = 140 - num;
        numtext = [NSString stringWithFormat:@"%lu", (unsigned long)num];
    } else {
        num = num - 140;
        NSMutableString *tmp = [[NSMutableString alloc] initWithString:@"-"];
        [tmp appendString:[NSString stringWithFormat:@"%lu", (unsigned long)num]];
        numtext = tmp;
    }
    self.textCountLabel.text = numtext;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
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
