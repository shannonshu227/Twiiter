//
//  TwitterClient.h
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error)) completion;
- (void) openURL:(NSURL *) url;

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error)) completion;
- (void) createNewTweet: (NSString *) newtweet completion:(void(^)(NSDictionary *tweet, NSError * error)) completion;

@end
