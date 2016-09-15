//
//  UserCell.h
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserCell : UITableViewCell

@property (nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end
