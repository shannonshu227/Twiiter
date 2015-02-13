//
//  DetailTweetViewController.h
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface DetailTweetViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
