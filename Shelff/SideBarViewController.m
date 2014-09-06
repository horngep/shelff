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

    self.view.backgroundColor = [UIColor colorWithRed:0.03 green:0.54 blue:0.73 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.03 green:0.54 blue:0.73 alpha:1];

    self.tableView.separatorColor = [UIColor colorWithRed:0.03 green:0.54 blue:0.73 alpha:1];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //pbb dont need this
    static NSString *CellIdentifier = @"Cell";

    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"cell0";
            break;

        case 1:
            CellIdentifier = @"cell1";
            break;

        case 2:
            CellIdentifier = @"cell2";
            break;

        case 3:
            CellIdentifier = @"cell3";
            break;

    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.03 green:0.54 blue:0.73 alpha:1];

}

@end
