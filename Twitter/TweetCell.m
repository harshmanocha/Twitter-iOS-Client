//
//  TweetCell.m
//  Twitter
//
//  Created by harsh.man on 05/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+Haneke.h"
#import "Tweet.h"
#import "User.h"

#define LOCALIZED_RETWEETED_BY_LABEL_TEXT LocalizedString(@"%@ retweeted")
#define LOCALIZED_TIMESTAMP_LABEL_HOUR_TEXT LocalizedString(@"%@h")
#define LOCALIZED_TIMESTAMP_LABEL_MINUTE_TEXT LocalizedString(@"%@m")
#define LOCALIZED_TIMESTAMP_LABEL_SECOND_TEXT LocalizedString(@"%@s")
#define SELECTED_LANGUAGE_CODE LocalizedString(@"language code")

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

NSString * const UsernameHandleStringFormatter = @"@%@";
NSString * const EmptyString = @"";

- (void)awakeFromNib {
    [super awakeFromNib];
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
}

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
        self.retweetedByLabel.text = [NSString stringWithFormat:LOCALIZED_RETWEETED_BY_LABEL_TEXT, self.tweet.user.name];
        [self.retweetView setHidden:NO];
        [self.retweetedByLabel setHidden:NO];
        self.topProfileImageConstraint.constant = 32;
        self.topNameConstraint.constant = 32;
        self.topScreenNameConstraint.constant = 33;
        self.topTimestampConstraint.constant = 32;
    } else {
        tweetToDisplay = self.tweet;
        [self.retweetView setHidden:YES];
        [self.retweetedByLabel setHidden:YES];
        self.topProfileImageConstraint.constant = 16;
        self.topNameConstraint.constant = 16;
        self.topScreenNameConstraint.constant = 17;
        self.topTimestampConstraint.constant = 16;
    }
    self.nameLabel.text = tweetToDisplay.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:UsernameHandleStringFormatter, tweetToDisplay.user.screenName];
    self.tweetLabel.text = tweetToDisplay.text;
    [self setProfileImageViewOfUserFromTweet:tweetToDisplay];
    [self setTimestampLabelFromTweet:tweetToDisplay];
    self.replyButton.enabled = self.retweetButton.enabled = self.favoriteButton.enabled = (self.tweet.tweetID != nil);
    self.retweetCountLabel.text = ([self.tweet.retweetCount longValue] > 0) ? [LocalizeHelper localizedNumberString:tweetToDisplay.retweetCount] : EmptyString;
    self.favoriteCountLabel.text = ([tweetToDisplay.favoriteCount longValue] > 0) ? [LocalizeHelper localizedNumberString:tweetToDisplay.favoriteCount] : EmptyString;
    self.retweetCountLabel.textColor = [self.tweet.isRetweeted boolValue] ? [UIColor greenColor] : [UIColor grayColor];
    self.favoriteCountLabel.textColor = [self.tweet.isFavorited boolValue] ? [UIColor orangeColor] : [UIColor grayColor];
    [self.retweetButton setSelected:[self.tweet.isRetweeted boolValue]];
    [self.favoriteButton setSelected:[self.tweet.isFavorited boolValue]];
}

- (void)setProfileImageViewOfUserFromTweet:(Tweet *)tweetToDisplay {
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    NSURL *url = [NSURL URLWithString:tweetToDisplay.user.profileImageURL];
    [self.profileImageView hnk_setImageFromURL:url];
}

- (void)setTimestampLabelFromTweet:(Tweet *)tweetToDisplay {
    NSTimeInterval secondsSinceTweet = -[tweetToDisplay.createdAt timeIntervalSinceNow];
    if (secondsSinceTweet >= 86400) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:SELECTED_LANGUAGE_CODE];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.timestampLabel.text = [dateFormatter stringFromDate:tweetToDisplay.createdAt];
    } else if (secondsSinceTweet >= 3600) {
        self.timestampLabel.text = [NSString stringWithFormat:LOCALIZED_TIMESTAMP_LABEL_HOUR_TEXT, [LocalizeHelper localizedNumberString:@(secondsSinceTweet/3600)]];
    } else if (secondsSinceTweet >= 60){
        self.timestampLabel.text = [NSString stringWithFormat:LOCALIZED_TIMESTAMP_LABEL_MINUTE_TEXT, [LocalizeHelper localizedNumberString:@(secondsSinceTweet/60)]];
    } else {
        self.timestampLabel.text = [NSString stringWithFormat:LOCALIZED_TIMESTAMP_LABEL_SECOND_TEXT, [LocalizeHelper localizedNumberString:@(secondsSinceTweet)]];
    }
}

- (void)highlightButton:(UIButton *)button highlight:(BOOL)highlight {
    button.selected = highlight;
}

- (IBAction)onReply:(id)sender {
    [self.delegate onReply:self];
}

- (IBAction)onRetweet:(id)sender {
    BOOL retweeted = [self.tweet retweet];
    self.retweetCountLabel.textColor = retweeted ? [UIColor greenColor] : [UIColor grayColor];
    self.retweetCountLabel.text = ([self.tweet.retweetCount longValue] > 0) ? [LocalizeHelper localizedNumberString:self.tweet.retweetCount] : EmptyString;
    [self highlightButton:self.retweetButton highlight:retweeted];
}

- (IBAction)onFavorite:(id)sender {
    Tweet *tweetToFavorite = (self.tweet.retweetedTweet != nil) ? self.tweet.retweetedTweet : self.tweet;
    BOOL favorited = [tweetToFavorite favorite];
    self.favoriteCountLabel.textColor = favorited ? [UIColor orangeColor] : [UIColor grayColor];
    self.favoriteCountLabel.text = ([self.tweet.favoriteCount longValue] > 0) ? [LocalizeHelper localizedNumberString:self.tweet.favoriteCount] : EmptyString;
    [self highlightButton:self.favoriteButton highlight:favorited];
}

@end
