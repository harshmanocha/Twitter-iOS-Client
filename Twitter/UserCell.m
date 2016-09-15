//
//  UserCell.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UserCell.h"
#import "UsersTableViewController.h"

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
    
    if (user.profileImage) {
        UIImage *profileImage = [UIImage imageWithData:user.profileImage];
        [self.profileImageView setImage:profileImage];
    }
    else {
        [NSThread detachNewThreadSelector:@selector(downloadAndLoadProfileImageOfUser:)
                                 toTarget:self
                               withObject:user];
    }
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
}

- (void)downloadAndLoadProfileImageOfUser:(User *)user {
    NSString *imageUrl = user.profileImageUrl;
    if ([imageUrl hasPrefix:@"http://"])
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    user.profileImage = UIImagePNGRepresentation(tmpImage);
    NSError *error = nil;
    // Save the object to persistent store
    NSManagedObjectContext *context = [UsersTableViewController managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self.profileImageView setImage:tmpImage]; });
}

@end
