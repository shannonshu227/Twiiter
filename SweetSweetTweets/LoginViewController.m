//
//  LoginViewController.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            
            TweetsViewController *tvc = [[TweetsViewController alloc] init];
            
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
            [self presentViewController:nvc animated:YES completion:nil];
            
            //[self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
        } else {
            
        }
    }];
    
}
@end
