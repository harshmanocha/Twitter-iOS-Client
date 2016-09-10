//
//  Tweet+CoreDataProperties.m
//  Twitter
//
//  Created by harsh.man on 09/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet+CoreDataProperties.h"

@implementation Tweet (CoreDataProperties)

@dynamic createdAt;
@dynamic favoriteCount;
@dynamic favorited;
@dynamic idStr;
@dynamic replyToId;
@dynamic retweetCount;
@dynamic retweeted;
@dynamic text;
@dynamic retweetedTweet;
@dynamic user;

@end
