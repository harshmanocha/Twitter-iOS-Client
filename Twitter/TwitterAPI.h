//
//  TwitterAPI.h
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

@interface TwitterAPI : NSObject

extern NSString * const tweetFavoriteApiEndPoint;
extern NSString * const tweetUnfavoriteApiEndPoint;
extern NSString * const retweetApiSkeleton;
extern NSString * const unretweetApiSkeleton;

extern NSString * const TwitterKeyForID;
extern NSString * const TwitterKeyForRetweetedStatus;
extern NSString * const TwitterKeyForUser;
extern NSString * const TwitterKeyForText;
extern NSString * const TwitterKeyForDateCreatedAt;
extern NSString * const TwitterKeyForRetweetCount;
extern NSString * const TwitterKeyForFavoriteCount;
extern NSString * const TwitterKeyForIsRetweeted;
extern NSString * const TwitterKeyForIsFavorited;

+ (TWTRAPIClient *)sharedInstanceOfApiClient;

+ (NSString *)userIDofCurrentSessionUser;

@end
