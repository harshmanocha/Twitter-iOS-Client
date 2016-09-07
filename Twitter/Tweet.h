//
//  Tweet.h
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "TwitterKit/TwitterKit.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) NSInteger favoriteCount;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *replyToIdStr;
@property (nonatomic, strong) NSString *retweetIdStr;
@property (nonatomic, strong) Tweet *retweetedTweet;
@property (nonatomic, strong) TWTRAPIClient *client;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (BOOL) retweet;
- (BOOL) favorite;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
