//
//  TweetCell.h
//  Twitter
//
//  Created by harsh.man on 05/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizeHelper.h"

@class TweetCell;
@class Tweet;

@protocol TweetCellDelegate <NSObject>

/**
 Method that should be implmented by a class implementing the @p TweetCellDelegate.
 The method expects to implement the functionality for replying to a tweet.
 
 @param tweetCell The tweetCell (which has a tweet property) to which to reply to.
 */
- (void)onReply:(TweetCell *)tweetCell;

@end


/**
 TweetCell is a prototype cell for a table view class.
 It can be used for displaying a tweet inside timelines or so.
 */
@interface TweetCell : UITableViewCell <RefreshLocalizedTextOnViewProtocol>

/**
 The tweet which needs to be displayed inside a Tweet Cell.
 */
@property (nonatomic) Tweet *tweet;

/**
 A delegate implementing the @p TweetCellDelegate protocol.
 */
@property (nonatomic, weak) id <TweetCellDelegate> delegate;

@end
