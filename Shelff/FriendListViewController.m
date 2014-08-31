//
//  FriendListViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 30/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "FriendListViewController.h"
#import "SWRevealViewController.h"


@interface FriendListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSideBar];
    self.title = @"Friends";
}




#pragma mark - Table View Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"row %d",indexPath.row];
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
