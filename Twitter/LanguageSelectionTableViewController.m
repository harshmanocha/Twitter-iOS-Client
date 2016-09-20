//
//  LanguageSelectionTableControllerTableViewController.m
//  Twitter
//
//  Created by harsh.man on 19/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "LanguageSelectionTableViewController.h"
#import "TimelineViewController.h"

@interface LanguageSelectionTableViewController ()

@end

@implementation LanguageSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = self.languagesTableView;
    self.checkedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self refreshLocalizedText];
    [self loadDataFromPersistentStorage];
    NSLog(@"Language selection screen opened");
    [LocalizeHelper addViewForRefreshingLocalizedText:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refreshLocalizedText {
    self.navigationItem.title = LocalizedString(@"Choose Language");
}

- (void)loadDataFromPersistentStorage {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [TimelineViewController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Language"];
    NSSortDescriptor * nameSortDescriptor;
    nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"languageName"
                                                     ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:nameSortDescriptor, nil]];
    self.supportedLanguages = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (int i=0; i<self.supportedLanguages.count; i++) {
        if ([((Language *)self.supportedLanguages[i]).isChosen boolValue]) {
            self.checkedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.supportedLanguages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell"
                                                            forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    Language *languageAtCurrentIndexPath = (Language *)self.supportedLanguages[indexPath.row];
    cell.textLabel.text = languageAtCurrentIndexPath.languageName;
    if([languageAtCurrentIndexPath.isChosen boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Language *previouslyChosenLanguage;
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [self.languagesTableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        previouslyChosenLanguage = (Language *)self.supportedLanguages[self.checkedIndexPath.row];
        previouslyChosenLanguage.isChosen = @NO;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    Language *newChosenLanguage = (Language *)self.supportedLanguages[indexPath.row];
    
    if (newChosenLanguage != previouslyChosenLanguage) {
        newChosenLanguage.isChosen = @YES;
        NSLog(@"%@ language selected by user", newChosenLanguage.languageName);
        self.checkedIndexPath = indexPath;
        LocalizationSetLanguage(newChosenLanguage.languageCode);
        
        NSError *error = nil;
        // Save the object to persistent store
        NSManagedObjectContext *context = [TimelineViewController managedObjectContext];
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
//        [[NSUserDefaults standardUserDefaults] setObject:@[newChosenLanguage.languageCode]
//                                                  forKey:@"AppleLanguages"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [self redrawViews];
    }
}

- (void)redrawViews {
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate performSelector:@selector(redrawViews)];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
