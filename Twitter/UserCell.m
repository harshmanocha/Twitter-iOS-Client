//
//  UserCell.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UserCell.h"
#import "UsersTableViewController.h"
#import "UIImageView+Haneke.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    // rounded corners for profile images
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3.0];
    
    /*
    SAMCache *cache = [SAMCache sharedCache];
    
    if ([cache imageExistsForKey:user.profileImageUrl]) {
        NSLog(@"Image key %@ exists in cache", user.profileImageUrl);
        UIImage *profileImage = [cache imageForKey:user.profileImageUrl];
        [self.profileImageView setImage:profileImage];
    }
    else {
        NSLog(@"Image key %@ doesn't exist in cache", user.profileImageUrl);
        [NSThread detachNewThreadSelector:@selector(downloadAndLoadProfileImageOfUser:)
                                 toTarget:self
                               withObject:user.profileImageUrl];
    }
     */
    
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    [self.profileImageView hnk_setImageFromURL:url];
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
}

@end
