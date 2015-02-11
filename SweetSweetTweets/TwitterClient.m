//
//  TwitterClient.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/5/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"4J6lOtr2etaMlsxLin7P7hNx2";
NSString * const kTwitterConsumerSecret = @"U3IXWJnh6kIr5wfq0vMGC4VLpG0KPpk2FzmvzT0zfK5OXl3NcO";
NSString * const KTwitterBaseUrl = @"https://api.twitter.com";


@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end
@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:KTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}


- (void) loginWithCompletion:(void (^)(User *user, NSError *error)) completion {
    
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"yeah request token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL: authURL];
    }failure:^(NSError *error) {
        NSLog(@"hell no, request token fail");
        self.loginCompletion(nil,error);
    }];
}

- (void) openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got access token!");
        
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSLog(@"current user: %@", responseObject);
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get current user");
            self.loginCompletion(nil,error);
        }];
//        
//        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //NSLog(@"Tweets:%@", responseObject);
//            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//            
//            for (Tweet *tweet in tweets) {
//                NSLog(@"tweet:%@, created: %@", tweet.text, tweet.createdAt);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error getting tweets");
//        }];
    }failure:^(NSError *error) {
        NSLog(@"fail to get access token!");
        self.loginCompletion(nil,error);
    }];
    

}

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void(^)(NSArray *tweets, NSError *error)) completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        
        completion(tweets,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}


@end
