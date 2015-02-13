//
//  User.h
//  SweetSweetTweets
//
//  Created by Xiangnan Xu on 2/7/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *id_str;

- (id) initWithDictionary:(NSDictionary *) dictionary;

+ (User *) currentUser;
+ (void) setCurrentUser:(User *) currentUser;
+ (void) logout;
@end
