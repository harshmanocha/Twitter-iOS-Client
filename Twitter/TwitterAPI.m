//
//  TwitterAPI.m
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "TwitterAPI.h"

@implementation TwitterAPI

NSString * const tweetFavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/create.json";
NSString * const tweetUnfavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/destroy.json";
NSString * const retweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/retweet/%@.json";
NSString * const unretweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/unretweet/%@.json";

NSString * const TwitterKeyForID = @"id_str";
NSString * const TwitterKeyForRetweetedStatus = @"retweeted_status";
NSString * const TwitterKeyForUser = @"user";
NSString * const TwitterKeyForText = @"text";
NSString * const TwitterKeyForDateCreatedAt = @"created_at";
NSString * const TwitterKeyForRetweetCount = @"retweet_count";
NSString * const TwitterKeyForFavoriteCount = @"favorite_count";
NSString * const TwitterKeyForIsRetweeted = @"retweeted";
NSString * const TwitterKeyForIsFavorited = @"favorited";

+ (TWTRAPIClient *)sharedInstanceOfApiClient {
    static TWTRAPIClient *client = nil;
    if (client == nil) {
        NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
        client = [[TWTRAPIClient alloc] initWithUserID:userID];
    }
    return client;
}

+ (NSString *)userIDofCurrentSessionUser {
    return [Twitter sharedInstance].sessionStore.session.userID;
}

@end
