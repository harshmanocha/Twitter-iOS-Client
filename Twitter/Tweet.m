//
//  Tweet.m
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Tweet.h"
#import "TwitterAPI.h"
#import "NSNumber+NegateBoolean.h"
#import "NSNumber+AddToLong.h"
#import "User.h"
#import "CoreDataHelper.h"

@implementation Tweet

NSString * const TweetEntityName = @"Tweet";
NSString * const DateFormatFromTwitterAPI = @"EEE MMM d HH:mm:ss Z y";
NSString * const LanguageLocaleForDateComingFromTwitterAPI = @"en_US_POSIX";

+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetDictionary
         generatedByApiEndPoint:(NSString *)apiEndPoint
         inManagedObjectContext:(NSManagedObjectContext *)context {
    Tweet *tweet = nil;
    NSString *tweetId = tweetDictionary[TwitterKeyForID];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:TweetEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(tweetID = %@) AND (generatedByApiEndPoint = %@)", tweetId, apiEndPoint];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        NSLog(@"Error in retrieving tweet from Core Data with tweetID: %@", tweetId);
    } else if ([matches count]) {
        tweet = [matches firstObject];
        [Tweet updateTweet:tweet withInfoFromDictionary:tweetDictionary];
        if (tweet.retweetedTweet && tweetDictionary[TwitterKeyForRetweetedStatus]) {
            tweet.retweetedTweet = [Tweet tweetWithTwitterInfo:tweetDictionary[TwitterKeyForRetweetedStatus]
                                        generatedByApiEndPoint:apiEndPoint
                                        inManagedObjectContext:context];
        }
    } else {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:TweetEntityName
                                              inManagedObjectContext:context];
        tweet.tweetID = tweetId;
        tweet.user = [User userWithDictionary:tweetDictionary[TwitterKeyForUser]
                       inManagedObjectContext:context];
        [tweet.user addTweetsObject:tweet];
        tweet.text = [tweetDictionary[TwitterKeyForText] stringByReplacingOccurrencesOfString:@"&amp;"
                                                                                   withString:@"&"];
        [Tweet updateTweet:tweet withInfoFromDictionary:tweetDictionary];
        if (tweetDictionary[TwitterKeyForRetweetedStatus]) {
            tweet.retweetedTweet = [Tweet tweetWithTwitterInfo:tweetDictionary[TwitterKeyForRetweetedStatus]
                                        generatedByApiEndPoint:apiEndPoint
                                        inManagedObjectContext:context];
        }
        tweet.generatedByApiEndPoint = apiEndPoint;
        NSString *createdAtString = tweetDictionary[TwitterKeyForDateCreatedAt];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:LanguageLocaleForDateComingFromTwitterAPI]];
        formatter.dateFormat = DateFormatFromTwitterAPI;
        tweet.createdAt = [formatter dateFromString:createdAtString];
        [CoreDataHelper saveManagedObjectContext];
    }
    return tweet;
}

+ (void)updateTweet:(Tweet *)tweet withInfoFromDictionary:(NSDictionary *)tweetDictionary {
    tweet.retweetCount = [NSNumber numberWithLong:[tweetDictionary[TwitterKeyForRetweetCount] longValue]];
    tweet.favoriteCount = [NSNumber numberWithLong:[tweetDictionary[TwitterKeyForFavoriteCount] longValue]];
    tweet.isRetweeted = [NSNumber numberWithBool:[tweetDictionary[TwitterKeyForIsRetweeted] boolValue]];
    tweet.isFavorited = [NSNumber numberWithBool:[tweetDictionary[TwitterKeyForIsFavorited] boolValue]];
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
    self.isRetweeted = [self.isRetweeted negateBool];
    if ([self.isRetweeted boolValue]) {
        self.retweetCount = [self.retweetCount addToLong:1];
        NSString *retweetApiEndPoint = [NSString stringWithFormat:retweetApiSkeleton, self.tweetID];
        NSError *clientError;
        NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"POST"
                                                                         URL:retweetApiEndPoint
                                                                  parameters:@{@"id":self.tweetID}
                                                                       error:&clientError];
        if (request) {
            [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!data) {
                    self.isRetweeted = [self.isRetweeted negateBool];
                } else NSLog(@"Retweet successful");
            }];
        }
    } else {
        self.retweetCount = [self.retweetCount addToLong:-1];
        NSString *unretweetApiEndPoint = [NSString stringWithFormat:unretweetApiSkeleton, self.tweetID];
        NSError *clientError;
        NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"POST"
                                                                         URL:unretweetApiEndPoint
                                                                  parameters:@{@"id":self.tweetID}
                                                                       error:&clientError];
        if (request) {
            [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!data) {
                    self.isRetweeted = [self.isRetweeted negateBool];
                } else NSLog(@"Unretweet successful");
            }];
        }
    }
    [CoreDataHelper saveManagedObjectContext];
    return [self.isRetweeted boolValue];
}

- (BOOL)favorite {
    self.isFavorited = [self.isFavorited negateBool];
    NSDictionary *requestParams = @{@"id":self.tweetID};
    if ([self.isFavorited boolValue]) {
        self.favoriteCount = [self.favoriteCount addToLong:1];
        NSError *clientError;
        NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"POST"
                                                                         URL:tweetFavoriteApiEndPoint
                                                                  parameters:requestParams
                                                                       error:&clientError];
        if (request) {
            [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!data) {
                     self.isFavorited = [self.isFavorited negateBool];
                }
            }];
        }
    } else {
        self.favoriteCount = [self.favoriteCount addToLong:-1];
        NSError *clientError;
        NSURLRequest *request = [[TwitterAPI sharedInstanceOfApiClient] URLRequestWithMethod:@"POST"
                                                                         URL:tweetUnfavoriteApiEndPoint
                                                                  parameters:requestParams
                                                                       error:&clientError];
        if (request) {
            [[TwitterAPI sharedInstanceOfApiClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!data) {
                     self.isFavorited = [self.isFavorited negateBool];
                }
            }];
        }
    }
    [CoreDataHelper saveManagedObjectContext];
    return [self.isFavorited boolValue];
}

@end
