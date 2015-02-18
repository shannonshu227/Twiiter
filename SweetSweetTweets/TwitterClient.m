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


- (void) retweetStatus: (NSString *) id_str completion:(void (^)(Tweet *tweet, NSError *error)) completion {
    
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", id_str];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];

        completion(tweet,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


- (void) updateStatusWithIdStr: (NSString *) id_str content:(NSString *)text mode: (BOOL)mode completion:(void (^)(Tweet *tweet, NSError *error)) completion {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:text forKey:@"status"];

    if (id_str != nil) { //reply
        [params setObject:id_str forKey:@"in_reply_to_status_id"];
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
        if (mode == 1) { NSLog(@"reply succeed"); } else { NSLog(@"new tweet succeed");}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];

}

@end


