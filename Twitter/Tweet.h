//
//  Tweet.h
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

/** 
 A custom subclass of @p NSManagedObject representing the properties and methods for a single tweet, along with their core data properties in a separate category.
 
 @author harsh.man
 */
@interface Tweet : NSManagedObject

/** 
 Retweet the tweet if not already retweeted. Otherwise, unretweet the tweet.
 
 @returns returns a @p BOOL indicating whether the corresponding user has retweeted this tweet (i.e. YES) or unretweeted it (i.e. NO).
 */
- (BOOL)retweet;

/**
 Like/favorite the tweet if not already liked. Otherwise, unlike or unfavorite the tweet.
 
 @returns returns a @p BOOL inficating whether the corresponding user has liked/favortited the tweet (i.e. YES) or unliked it (i.e. NO).
 */
- (BOOL)favorite;

/**
 Class method that returns a tweet from the Core Data corresponding to the id provided in the tweetDictionary. 
 Before returning the corresponding tweet, it also updates properties like retweetCount and favoriteCount in the Core Data's entity object using the updated values from the tweetDictionary.
 If corresponding tweet does not exist in the Core Data, a new Tweet is created using the data provided via the dictionary, is added to the Core Data and then retunrned.
 
 @param tweetDictionary An @p NSDictionary containing data for a tweet. The dictionary is expeted to have key-value pairs corresponding to keys id_str, text, created_at, retweet_count, favorite_count, retweeted, favorited, user, and optionally retweeted_status.
 @param apiEndPoint A string containing the apiEndPoint via which the tweet was generated. This is required to differentiate tweets for different screens like user timeline, home timeline, etc.
 @param context An instance of @p NSManagedContext indicating where the tweet instance should be fetched from and saved into before being returned.
 
 @returns returns an instance of Tweet.
 */
+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetDictionary
         generatedByApiEndPoint:(NSString *)apiEndPoint
         inManagedObjectContext:(NSManagedObjectContext *)context;

/**
 Class method that returns an array of Tweet objects.
 The tweets are returned using the data provided in the array of dictionaries. If the tweets already exist in the Core Data, then it is updated and returned. Otherwise, new tweet(s) is/are created and saved before being returned.
 
 @param tweets An array of @p NSDictionary, each of which contain data about corresponding tweet.
 @param apiEndPoint A string containing the apiEndPoint via which the tweets were generated. This is required to differentiate tweets for different screens like user timeline, home timeline, etc.
 @param context An instance of @p NSManagedContext indicating where the tweet instances should be fetched from and saved into before being returned.
 */
+ (NSArray *)loadTweetsFromArray:(NSArray *)tweets
          generatedByApiEndPoint:(NSString *)apiEndPoint
        intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Tweet+CoreDataProperties.h"
