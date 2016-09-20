//
//  LanguageSelectionTableControllerTableViewController.h
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language+CoreDataClass.h"
#import "LocalizeHelper.h"

@interface LanguageSelectionTableViewController : UITableViewController <RefreshLocalizedTextOnViewProtocol>

@property (strong, nonatomic) IBOutlet UITableView *languagesTableView;
@property (strong, nonatomic) NSIndexPath* checkedIndexPath;
@property (strong, nonatomic) NSArray* supportedLanguages;

@end
