//
//  Tweet.m
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/7/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary: (NSDictionary *) dictionary {

    self = [super init];
    if(self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favCount  =[dictionary[@"favorite_count"] integerValue];
        self.id_str = dictionary[@"id_str"];
        self.favorited = dictionary[@"favorited"];
        self.retweeted = dictionary[@"retweeted"];


        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
    }
    
    return self;
}


+ (NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
    
}

@end

