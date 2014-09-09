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
@property NSMutableArray *friends; //array of friends from Parse

@end

@implementation FriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Friends";
    self.friends = [NSMutableArray new];

    [self setSideBar];
    [self getFriendsFromFacebookAndParse];
}

-(void)getFriendsFromFacebookAndParse
{
    //Facebook
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray *FBfriends = [result objectForKey:@"data"]; //array of friends from Facebook
        NSLog(@"friends: %lu",(unsigned long)FBfriends.count);

        //Parse
        for (NSDictionary<FBGraphUser>* friend in FBfriends) {
            PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
            [query orderByAscending:@"FBName"];
            [query whereKey:@"FBid" equalTo:friend.objectID];

            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                [self.friends addObject:object]; //array of Friends in Parse
                //get photo here


                [self.tableView reloadData];
            }];

        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"friendSegue"]) {
        ShelfViewController *svc = segue.destinationViewController;
        svc.thisCustomer = [self.friends objectAtIndex:[self.tableView indexPathForSelectedRow].row]; //sending PFObject
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
    PFObject *friend = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [friend objectForKey:@"FBName"];
    return cell;
}

#pragma mark - sidebar
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
