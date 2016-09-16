//
//  HomeTimelineViewController.h
//  Twitter
//
//  Created by harsh.man on 31/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"

@interface UserTimelineViewController : TimelineViewController

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) IBOutlet UITableView *userTimelineTableView;

@end
