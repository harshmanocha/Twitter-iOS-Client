//
//  Tweet+CoreDataProperties.m
//  Twitter
//
//  Created by harsh.man on 21/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "Tweet+CoreDataProperties.h"

@implementation Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
}

@dynamic createdAt;
@dynamic favoriteCount;
@dynamic isFavorited;
@dynamic generatedByApiEndPoint;
@dynamic tweetID;
@dynamic replyToID;
@dynamic retweetCount;
@dynamic isRetweeted;
@dynamic text;
@dynamic retweetedTweet;
@dynamic user;

@end
