//
//  SideBarViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 30/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

//https://github.com/John-Lluch/SWRevealViewController


#import "SideBarViewController.h"
#import "SWRevealViewController.h"


#import "FriendListViewController.h"
#import "ShelfViewController.h"

@interface SideBarViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _presentedRow;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SideBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
}
//
//- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
//{
//    //    // configure the destination view controller:
//    //    if ( [sender isKindOfClass:[UITableViewCell class]] )
//    //    {
//    //       // UILabel* c = [(SWUITableViewCell *)sender label];
//    //        UINavigationController *navController = segue.destinationViewController;
//    //        ColorViewController* cvc = [navController childViewControllers].firstObject;
//    //        if ( [cvc isKindOfClass:[ColorViewController class]] )
//    //        {
//    //            cvc.color = c.textColor;
//    //            cvc.text = c.text;
//    //        }
//    //    }
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"cell1";
            break;

        case 1:
            CellIdentifier = @"cell2";
            break;

    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}

//
//#pragma marl - UITableView Data Source
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    NSInteger row = indexPath.row;
//
//    if (nil == cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//    }
//
//    NSString *text = nil;
//    if (row == 0)
//    {
//        text = @"My Shlef";
//    }
//    else if (row == 1)
//    {
//        text = @"Friends";
//    }
//
//    cell.textLabel.text = NSLocalizedString( text,nil );
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
////
////    //TODO: use storyboard
////
////    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
//    SWRevealViewController *revealController = self.revealViewController;
//
//    NSInteger row = indexPath.row;
//
//    if ( row == _presentedRow )
//    {
//        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//        return;
//    }
//
//    UIViewController *newFrontController = nil;
//
//    if (row == 0)
//    {
//        newFrontController = [[ShelfViewController alloc] init];
//    }
//
//    else if (row == 1)
//    {
//        newFrontController = [[FriendListViewController alloc] init];
//    }
//
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//    _presentedRow = row;  // <- store the presented row
//}

@end
