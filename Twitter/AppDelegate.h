//
//  AppDelegate.h
//  Twitter
//
//  Created by harsh.man on 30/08/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LocalizeHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSPointerArray *viewsDrawn;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)addLanguagesToAndLoadFromCoreData;
- (void)redrawViews;
- (void)addViewForRefreshingLocalizedText:(id<RefreshLocalizedTextOnViewProtocol>)view;


@end

