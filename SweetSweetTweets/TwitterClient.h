//
//  TwitterClient.h
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error)) completion;
- (void) openURL:(NSURL *) url;

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error)) completion;
//- (void) createNewTweet: (NSString *) newtweet completion:(void(^)(Tweet *tweet, NSError * error)) completion;
- (void) retweetStatus: (NSString *) id_str completion:(void (^)(Tweet *tweet, NSError *error)) completion;
//- (void) replyStatus: (NSString *) id_str reply:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error)) completion;
- (void) updateStatusWithIdStr: (NSString *) id_str content:(NSString *)text mode: (BOOL)mode completion:(void (^)(Tweet *tweet, NSError *error)) completion;

@end
