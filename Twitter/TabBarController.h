//
//  TabBarController.h
//  Twitter
//
//  Created by harsh.man on 02/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "LocalizeHelper.h"

@interface TabBarController : UITabBarController <TimelineDelegate, RefreshLocalizedTextOnViewProtocol>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (void)postTweet: (NSString *)withText;

@end
