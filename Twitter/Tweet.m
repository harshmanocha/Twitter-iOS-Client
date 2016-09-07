//
//  Tweet.m
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

NSString * const tweetFavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/create.json";
NSString * const tweetUnfavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/destroy.json";
NSString * const retweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/retweet/%@.json";
NSString * const unretweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/unretweet/%@.json";

- (id) initWithDictionary:(NSDictionary *)dictionary  {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = [dictionary[@"text"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        
        self.idStr = dictionary[@"id_str"];
        
        if (dictionary[@"in_reply_to_status_id_str"]) {
            self.replyToIdStr = dictionary[@"in_reply_to_status_id_str"];
        }
        
        if (dictionary[@"current_user_retweet"]) {
            self.retweetIdStr = dictionary[@"current_user_retweet"][@"id_str"];
        }
        
        if (dictionary[@"retweeted_status"]) {
            self.retweetedTweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }
        
        NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
        _client = [[TWTRAPIClient alloc] initWithUserID:userID];
    }
    return self;
}


+ (NSArray *)tweetsWithArray:(NSArray *)array; {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

- (BOOL)retweet {
    self.retweeted = !self.retweeted;
    if (self.retweeted) {
        self.retweetCount++;
        
        // retweet
        NSString *retweetApiEndPoint = [NSString stringWithFormat:retweetApiSkeleton, self.idStr];
        NSError *clientError;
        NSURLRequest *request = [self.client URLRequestWithMethod:@"POST"
                                                              URL:retweetApiEndPoint
                                                       parameters:@{@"id":self.idStr}
                                                            error:&clientError];
        if (request) {
            [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Retweet successful, retweet_id_str: ");
                }
                else {
                    NSLog(@"Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", clientError);
        }
    } else {
        self.retweetCount--;
        // unretweet
        NSString *unretweetApiEndPoint = [NSString stringWithFormat:unretweetApiSkeleton, self.idStr];
        NSError *clientError;
        NSURLRequest *request = [self.client URLRequestWithMethod:@"POST"
                                                              URL:unretweetApiEndPoint
                                                       parameters:@{@"id":self.idStr}
                                                            error:&clientError];
        if (request) {
            [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Unretweet successful");
                }
                else {
                    NSLog(@"Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", clientError);
        }
    }

    return self.retweeted;
}

- (BOOL)favorite {
    self.favorited = !self.favorited;
    
    NSDictionary *requestParams = @{@"id":self.idStr};
    
    if (self.favorited) {
        self.favoriteCount++;
        
        NSError *clientError;
        NSURLRequest *request = [self.client URLRequestWithMethod:@"POST"
                                                              URL:tweetFavoriteApiEndPoint
                                                       parameters:requestParams
                                                            error:&clientError];
        if (request) {
            [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Favorite successful");
                }
                else {
                    NSLog(@"Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", clientError);
        }
        
    } else {
        self.favoriteCount--;
        // unfavorite
        NSError *clientError;
        NSURLRequest *request = [self.client URLRequestWithMethod:@"POST"
                                                              URL:tweetUnfavoriteApiEndPoint
                                                       parameters:requestParams
                                                            error:&clientError];
        if (request) {
            [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Unfavorite successful");
                }
                else {
                    NSLog(@"Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", clientError);
        }
    }

    return self.favorited;
}

@end
