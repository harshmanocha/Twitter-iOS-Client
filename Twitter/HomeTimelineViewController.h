//
//  HomeTimelineViewController.h
//  Twitter
//
//  Created by harsh.man on 06/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimelineViewController.h"

@interface HomeTimelineViewController : TimelineViewController

@property (strong, nonatomic) IBOutlet UITableView *homeTimelineTableView;

@end
