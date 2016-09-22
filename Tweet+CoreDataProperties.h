//
//  Tweet+CoreDataProperties.h
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSNumber *favoriteCount;
@property (nullable, nonatomic, copy) NSNumber *isFavorited;
@property (nullable, nonatomic, copy) NSString *generatedByApiEndPoint;
@property (nullable, nonatomic, copy) NSString *tweetID;
@property (nullable, nonatomic, copy) NSString *replyToID;
@property (nullable, nonatomic, copy) NSNumber *retweetCount;
@property (nullable, nonatomic, copy) NSNumber *isRetweeted;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, retain) Tweet *retweetedTweet;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
