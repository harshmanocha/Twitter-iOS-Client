//
//  TabBarController.h
//  Twitter
//
//  Created by harsh.man on 02/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"

@interface TabBarController : UITabBarController <TimelineDelegate>

- (void)postTweet: (NSString *)withText;

@end
