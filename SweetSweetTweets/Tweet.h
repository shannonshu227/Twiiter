//
//  Tweet.h
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/7/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
//@property (nonatomic, strong) NSString *favCount;
//@property (nonatomic, strong) NSString *retweetCount;
@property NSInteger favCount;
@property NSInteger retweetCount;
@property (nonatomic, strong) NSString *id_str;
@property BOOL favorited;
@property BOOL retweeted;


- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (NSArray *) tweetsWithArray:(NSArray *) array;

@end
