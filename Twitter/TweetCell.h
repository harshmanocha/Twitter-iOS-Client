//
//  TweetCell.h
//  Twitter
//
//  Created by harsh.man on 05/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)onReply:(TweetCell *)tweetCell;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;

@property (nonatomic, weak) id <TweetCellDelegate> delegate;


@end