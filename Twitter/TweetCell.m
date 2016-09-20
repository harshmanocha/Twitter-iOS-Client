//
//  TweetCell.m
//  Twitter
//
//  Created by harsh.man on 05/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "TweetCell.h"
#import "TimelineViewController.h"
#import "UIImageView+Haneke.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topProfileImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScreenNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTimestampConstraint;

@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*
- (void)downloadAndLoadProfileImageOfUser:(NSString *)imageUrl {
    if ([imageUrl hasPrefix:@"http://"])
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *profileImage = [[UIImage alloc] initWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self.profileImageView setImage:profileImage]; });
}
*/

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self refreshLocalizedText];
}

- (void)refreshLocalizedText {
    User *user = self.tweet.user;
    Tweet *tweetToDisplay;
    
    if (self.tweet.retweetedTweet) {
        tweetToDisplay = self.tweet.retweetedTweet;
        user = tweetToDisplay.user;
        self.retweetedByLabel.text = [NSString stringWithFormat:LocalizedString(@"%@ retweeted"), self.tweet.user.name];
        [self.retweetView setHidden:NO];
        [self.retweetedByLabel setHidden:NO];
        // update constraints dynamically
        self.topProfileImageConstraint.constant = 32;
        self.topNameConstraint.constant = 32;
        self.topScreenNameConstraint.constant = 33;
        self.topTimestampConstraint.constant = 32;
    } else {
        tweetToDisplay = self.tweet;
        [self.retweetView setHidden:YES];
        [self.retweetedByLabel setHidden:YES];
        // update constraints dynamically
        self.topProfileImageConstraint.constant = 16;
        self.topNameConstraint.constant = 16;
        self.topScreenNameConstraint.constant = 17;
        self.topTimestampConstraint.constant = 16;
    }
    
    // rounded corners for profile images
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    //    NSLog(@"URL: %@", tweetToDisplay.user.profileImageUrl);
    NSURL *url = [NSURL URLWithString:tweetToDisplay.user.profileImageUrl];
    [self.profileImageView hnk_setImageFromURL:url];
    
    self.nameLabel.text = tweetToDisplay.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweetToDisplay.user.screenname];
    self.tweetLabel.text = tweetToDisplay.text;
    
    // show relative time since now if 24 hours or less has elapsed
    NSTimeInterval secondsSinceTweet = -[self.tweet.createdAt timeIntervalSinceNow];
    
    //    NSLog(@"For the tweet by %@ - Seconds since tweet: %f and created at: %@", _tweet.user.name, secondsSinceTweet, _tweet.createdAt);
    if (secondsSinceTweet >= 86400) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:LocalizedString(@"language code")];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.timestampLabel.text = [dateFormatter stringFromDate:tweetToDisplay.createdAt];
        //        [NSDateFormatter localizedStringFromDate:tweetToDisplay.createdAt
        //                                                                  dateStyle:NSDateFormatterShortStyle
        //                                                                  timeStyle:NSDateFormatterNoStyle];
    } else if (secondsSinceTweet >= 3600) {
        // show hours
        self.timestampLabel.text = [NSString stringWithFormat:LocalizedString(@"%@h"), [LocalizeHelper localizedNumberString:@(secondsSinceTweet/3600)]];
    } else if (secondsSinceTweet >= 60){
        // show minutes
        self.timestampLabel.text = [NSString stringWithFormat:LocalizedString(@"%@m"), [LocalizeHelper localizedNumberString:@(secondsSinceTweet/60)]];
    } else {
        // show seconds
        self.timestampLabel.text = [NSString stringWithFormat:LocalizedString(@"%@s"), [LocalizeHelper localizedNumberString:@(secondsSinceTweet)]];
    }
    
    if (!self.tweet.idStr) {
        self.replyButton.enabled = self.retweetButton.enabled = self.favoriteButton.enabled = NO;
    }
    else {
        self.replyButton.enabled = self.retweetButton.enabled = self.favoriteButton.enabled = YES;
    }
    
    if ([self.tweet.retweetCount longValue] > 0) {
        self.retweetCountLabel.text = [LocalizeHelper localizedNumberString:tweetToDisplay.retweetCount];
    }
    else {
        self.retweetCountLabel.text = @"";
    }
    
    if ([tweetToDisplay.favoriteCount longValue] > 0) {
        self.favoriteCountLabel.text = [LocalizeHelper localizedNumberString:tweetToDisplay.favoriteCount];
    }
    else {
        self.favoriteCountLabel.text = @"";
    }
    
    if ([self.tweet.retweeted boolValue]) {
        self.retweetCountLabel.textColor = [UIColor greenColor];
    }
    else {
        self.retweetCountLabel.textColor = [UIColor grayColor];
    }
    
    if ([self.tweet.favorited boolValue] > 0) {
        self.favoriteCountLabel.textColor = [UIColor orangeColor];
    }
    else {
        self.favoriteCountLabel.textColor = [UIColor grayColor];
    }
    
    [self.retweetButton setSelected:[self.tweet.retweeted boolValue]];
    [self.favoriteButton setSelected:[self.tweet.favorited boolValue]];
}

- (void)highlightButton:(UIButton *)button highlight:(BOOL)highlight {
    if (highlight) {
        [button setSelected:YES];
    } else {
        [button setSelected:NO];
    }
}

- (IBAction)onReply:(id)sender {
    [self.delegate onReply:self];
}

- (IBAction)onRetweet:(id)sender {
    BOOL retweeted = [_tweet retweet];
    if (retweeted) {
        self.retweetCountLabel.textColor = [UIColor greenColor];
    } else {
        self.retweetCountLabel.textColor = [UIColor grayColor];
    }
    if (_tweet.retweetCount > 0) {
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", [_tweet.retweetCount longValue]];
    } else {
        self.retweetCountLabel.text = @"";
    }
    [self highlightButton:self.retweetButton highlight:retweeted];
    
    NSError *error = nil;
    // Save the object to persistent store
    NSManagedObjectContext *context = [TimelineViewController managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (IBAction)onFavorite:(id)sender {
    Tweet *tweetToFavorite;
    if (_tweet.retweetedTweet) {
        tweetToFavorite = _tweet.retweetedTweet;
    } else {
        tweetToFavorite = _tweet;
    }
    
    BOOL favorited = [tweetToFavorite favorite];
    if (favorited) {
        self.favoriteCountLabel.textColor = [UIColor orangeColor];
    } else {
        self.favoriteCountLabel.textColor = [UIColor grayColor];
    }
    if (tweetToFavorite.favoriteCount > 0) {
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", [tweetToFavorite.favoriteCount longValue]];
    } else {
        self.favoriteCountLabel.text = @"";
    }
    [self highlightButton:self.favoriteButton highlight:favorited];
    
    NSError *error = nil;
    // Save the object to persistent store
    NSManagedObjectContext *context = [TimelineViewController managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end
