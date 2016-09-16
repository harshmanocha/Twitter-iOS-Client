//
//  Tweet.m
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

NSString * const tweetFavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/create.json";
NSString * const tweetUnfavoriteApiEndPoint = @"https://api.twitter.com/1.1/favorites/destroy.json";
NSString * const retweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/retweet/%@.json";
NSString * const unretweetApiSkeleton = @"https://api.twitter.com/1.1/statuses/unretweet/%@.json";

@implementation Tweet

+ (TWTRAPIClient *)apiClient {
    static TWTRAPIClient *client = nil;
    if (client == nil) {
        NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
        client = [[TWTRAPIClient alloc] initWithUserID:userID];
    }
    return client;
}

// Insert code here to add functionality to your managed object subclass
+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetDictionary
         generatedByApiEndPoint:(NSString *)apiEndPoint
         inManagedObjectContext:(NSManagedObjectContext *)context {
    Tweet *tweet = nil;
    
    NSString *tweetId = tweetDictionary[@"id_str"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"(idStr = %@) AND (generatedByApiEndPoint = %@)", tweetId, apiEndPoint];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        NSLog(@"Error in retrieving tweet from Core Data with tweetID: %@", tweetId);
    }
    else if ([matches count]) {
        tweet = [matches firstObject];
        tweet.retweetCount = [[NSNumber alloc] initWithLong:[tweetDictionary[@"retweet_count"] integerValue]];
        tweet.favoriteCount = [[NSNumber alloc] initWithLong:[tweetDictionary[@"favorite_count"] integerValue]];
        
        tweet.retweeted = [[NSNumber alloc] initWithBool:[tweetDictionary[@"retweeted"] boolValue]];
        tweet.favorited = [NSNumber numberWithBool:[tweetDictionary[@"favorited"] boolValue]];
    }
    else {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet"
                                              inManagedObjectContext:context];
        tweet.idStr = tweetId;
        
        tweet.user = [User userWithDictionary:tweetDictionary[@"user"]
                       inManagedObjectContext:context];
        
        [tweet.user addTweetsObject:tweet];
        
        tweet.text = [tweetDictionary[@"text"] stringByReplacingOccurrencesOfString:@"&amp;"
                                                                         withString:@"&"];
        
        NSString *createdAtString = tweetDictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        tweet.createdAt = [formatter dateFromString:createdAtString];
//        NSLog(@"Tweet by %@ createdAtString %@ created at %@", tweet.user.name, createdAtString, tweet.createdAt);
        
        tweet.retweetCount = [[NSNumber alloc] initWithLong:[tweetDictionary[@"retweet_count"] integerValue]];
        tweet.favoriteCount = [[NSNumber alloc] initWithLong:[tweetDictionary[@"favorite_count"] integerValue]];
        
        tweet.retweeted = [[NSNumber alloc] initWithBool:[tweetDictionary[@"retweeted"] boolValue]];
        tweet.favorited = [NSNumber numberWithBool:[tweetDictionary[@"favorited"] boolValue]];
        
        if (tweetDictionary[@"retweeted_status"]) {
            tweet.retweetedTweet = [Tweet tweetWithTwitterInfo:tweetDictionary[@"retweeted_status"]
                                        generatedByApiEndPoint:apiEndPoint
                                        inManagedObjectContext:context];
            
        }
        
        tweet.generatedByApiEndPoint = apiEndPoint;
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
    return tweet;
}

+ (NSArray *)loadTweetsFromArray:(NSArray *)tweetsDictArray
          generatedByApiEndPoint:(NSString *)apiEndPoint
        intoManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *tweetDictionary in tweetsDictArray) {
        Tweet *tweet = [Tweet tweetWithTwitterInfo:tweetDictionary
                        generatedByApiEndPoint:apiEndPoint
                                inManagedObjectContext:context];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

- (BOOL)retweet {
    self.retweeted = [[NSNumber alloc] initWithBool:![self.retweeted boolValue]];

    if ([self.retweeted boolValue]) {
        self.retweetCount = [[NSNumber alloc] initWithLong:([self.retweetCount longValue] + 1)];
//        self.retweetCount++;
        
        // retweet
        NSString *retweetApiEndPoint = [NSString stringWithFormat:retweetApiSkeleton, self.idStr];
        NSError *clientError;
        NSURLRequest *request = [Tweet.apiClient URLRequestWithMethod:@"POST"
                                                              URL:retweetApiEndPoint
                                                       parameters:@{@"id":self.idStr}
                                                            error:&clientError];
        if (request) {
            [Tweet.apiClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
    }
    else {
        self.retweetCount = [[NSNumber alloc] initWithLong:([self.retweetCount longValue] - 1)];
        // unretweet
        NSString *unretweetApiEndPoint = [NSString stringWithFormat:unretweetApiSkeleton, self.idStr];
        NSError *clientError;
        NSURLRequest *request = [Tweet.apiClient URLRequestWithMethod:@"POST"
                                                              URL:unretweetApiEndPoint
                                                       parameters:@{@"id":self.idStr}
                                                            error:&clientError];
        if (request) {
            [Tweet.apiClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
    
    return [self.retweeted boolValue];
}

- (BOOL)favorite {
    self.favorited = [[NSNumber alloc] initWithBool:![self.favorited boolValue]];
    
    NSDictionary *requestParams = @{@"id":self.idStr};
    
    if ([self.favorited boolValue]) {
        self.favoriteCount = [[NSNumber alloc] initWithLong:([self.favoriteCount longValue] + 1)];
        
        NSError *clientError;
        NSURLRequest *request = [Tweet.apiClient URLRequestWithMethod:@"POST"
                                                              URL:tweetFavoriteApiEndPoint
                                                       parameters:requestParams
                                                            error:&clientError];
        if (request) {
            [Tweet.apiClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Favorite successful");
                }
                else {
                    NSLog(@"Twitter Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Request Error: %@", clientError);
        }
        
    } else {
        self.favoriteCount = [[NSNumber alloc] initWithLong:([self.favoriteCount longValue] - 1)];

        // unfavorite
        NSError *clientError;
        NSURLRequest *request = [Tweet.apiClient URLRequestWithMethod:@"POST"
                                                              URL:tweetUnfavoriteApiEndPoint
                                                       parameters:requestParams
                                                            error:&clientError];
        if (request) {
            [Tweet.apiClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSLog(@"Unfavorite successful");
                }
                else {
                    NSLog(@"Connection Error: %@", connectionError);
                }
            }];
        }
        else {
            NSLog(@"Request Error: %@", clientError);
        }
    }
    
    return [self.favorited boolValue];
}

@end
