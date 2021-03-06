//
//  UsersTableTableViewController.m
//  Twitter
//
//  Created by harsh.man on 07/09/16.
//  Copyright © 2016 Directi. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UserCell.h"
#import "UserTimelineViewController.h"

@interface UsersTableViewController ()

@property (nonatomic) long indexPathRow;

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
    
    NSLog(@"Number of fetched users from core data: %lu", (unsigned long)self.users.count);
    if (self.users.count)
        [self.loadingIndicator hideAnimated:YES];
    else
        [self refreshUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRelationshipOnUsers:(nullable NSArray *)users {
    // Template design pattern. Implement in subclass.
}

- (void)checkForNewUsers {
    
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
                                intoManagedObjectContext:[UsersTableViewController managedObjectContext]];
                
                [self setRelationshipOnUsers:nil];
                
                self.nextCursor = json[@"next_cursor_str"];
                
                [self.usersTableView reloadData];
                [self.loadingIndicator hideAnimated:YES];
                [self.refreshUsersControl endRefreshing];
                
                [self getMoreUsers];
            }
            else {
                NSLog(@"Connection Error: %@", connectionError);
                
                [self.loadingIndicator hideAnimated:YES];
                [self.refreshUsersControl endRefreshing];
            }
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
    if (!self.nextCursor || [self.nextCursor isEqualToString:@"0"]) {   
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
                                      intoManagedObjectContext:[UsersTableViewController managedObjectContext]];
                
                self.nextCursor = json[@"next_cursor_str"];
                
                if (moreUsers.count > 0) {
                    NSLog(@"Got %lu more users", moreUsers.count);
                    [self setRelationshipOnUsers:moreUsers];
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.users];
                    [temp addObjectsFromArray:moreUsers];
                    self.users = [temp copy];
                    [self.usersTableView reloadData];
                    
                    [self getMoreUsers];
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
    
    self.indexPathRow = [indexPath row];
    [self performSegueWithIdentifier:@"userTimelineSeque"
                              sender:self];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userTimelineSeque"]) {
//        NSIndexPath *path = [self.usersTableView indexPathForSelectedRow];
//        NSLog(@"Index path row: %li", path.row);
        NSString *userID = ((User *)self.users[self.indexPathRow]).userID;
        UserTimelineViewController *destinationViewController = (UserTimelineViewController *)segue.destinationViewController;
        [destinationViewController setUserId:userID];
    }
}


@end
