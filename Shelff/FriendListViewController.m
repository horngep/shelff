//
//  FriendListViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 30/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "FriendListViewController.h"
#import "SWRevealViewController.h"
#import "ShelfViewController.h"



@interface FriendListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *friends;

@end

@implementation FriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSideBar];
    self.title = @"Friends";
}

-(void)viewWillAppear:(BOOL)animated
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        //NSLog(@"results found : %@",result);
        self.friends = [result objectForKey:@"data"];
        //NSLog(@"Found: %i friends", self.friends.count);
        for (NSDictionary<FBGraphUser>* friend in self.friends) {
           // NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
        }
        [self.tableView reloadData];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cellID"]) {
        ShelfViewController *svc = segue.destinationViewController;
        svc.thisCustomer = [self.friends objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        // send the friend over
    }
}


#pragma mark - Table View Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSDictionary<FBGraphUser> *friend = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.name;
    return cell;
}

-(void)setSideBar
{
    SWRevealViewController *revealController = [self revealViewController];

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

@end
