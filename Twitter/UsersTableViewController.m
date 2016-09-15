//
//  UsersTableTableViewController.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UserCell.h"

@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register user cell nib
    [self.usersTableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil]
              forCellReuseIdentifier:@"UserCell"];
    
    // set self as table view data source and delegate
    self.usersTableView.dataSource = self;
    self.usersTableView.delegate = self;
    self.usersTableView.estimatedRowHeight = 64;
    self.usersTableView.rowHeight = UITableViewAutomaticDimension;
    
    // add pull to refresh tweets control
    self.refreshUsersControl = [[UIRefreshControl alloc] init];
    [self.usersTableView addSubview:self.refreshUsersControl];
    [self.refreshUsersControl addTarget:self
                                 action:@selector(refreshUsers)
                       forControlEvents:UIControlEventValueChanged];
    
    // show loading indicator
    self.loadingIndicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self loadDataFromPersistentStorage];
    
    [self refreshUsers];
}

- (void)loadDataFromPersistentStorage {
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [UsersTableViewController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"generatedByApiEndPoint = %@", self.twitterRequestApiEndPoint]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                          ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    
    self.users = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUsers {
    
    NSLog(@"Fetching/refreshing users");
    
    [self.requestParams removeObjectForKey:@"cursor"];
    
    NSError *clientError;
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET"
                                                          URL:self.twitterRequestApiEndPoint
                                                   parameters:self.requestParams
                                                        error:&clientError];
    
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                self.users = [User loadUsersFromArray:json[@"users"]
                                  generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                intoManagedObjectContext:[UsersTableViewController managedObjectContext]];
                
                self.nextCursor = json[@"next_cursor_str"];
                
                [self.usersTableView reloadData];
            }
            else {
                NSLog(@"Connection Error: %@", connectionError);
            }
            [self.loadingIndicator hideAnimated:YES];
            [self.refreshUsersControl endRefreshing];
        }];
    }
    else {
        NSLog(@"Request Error: %@", clientError);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    userCell.user = self.users[indexPath.row];
    
    // if data for the fourth-last cell is requested, then obtain more data
    if (indexPath.row == self.users.count - 4) {
        NSLog(@"End of list reached...");
        [self getMoreUsers];
    }
    
    return userCell;
}

- (void) getMoreUsers {
    if (!self.nextCursor) {
        return;
    }
    
    [self.requestParams setObject:self.nextCursor forKey:@"cursor"];
    
    NSError *clientError;
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET"
                                                          URL:self.twitterRequestApiEndPoint
                                                   parameters:self.requestParams
                                                        error:&clientError];
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSArray *moreUsers = [User loadUsersFromArray:json[@"users"]
                                        generatedByApiEndPoint:self.twitterRequestApiEndPoint
                                      intoManagedObjectContext:[UsersTableViewController managedObjectContext]];
                
                self.nextCursor = json[@"next_cursor_str"];
                
                if (moreUsers.count > 0) {
                    NSLog(@"Got %lu more users", moreUsers.count);
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.users];
                    [temp addObjectsFromArray:moreUsers];
                    self.users = [temp copy];
                    [self.usersTableView reloadData];
                }
                else {
                    NSLog(@"No more users available");
                }
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // unhighlight selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
