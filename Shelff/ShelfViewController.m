//
//  ShelfViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 30/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ShelfViewController.h"
#import "SWRevealViewController.h"

@interface ShelfViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *shoeArray;
@property NSMutableArray *shoePhotoArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusBarButton;

@end

@implementation ShelfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.pagingEnabled = YES;
    self.shoeArray = [NSArray new]; //for did select item / segue
    self.shoePhotoArray = [NSMutableArray new]; // for display
    NSLog(@"self.thisCustomer : %@",self.thisCustomer);

    [self setSideBar];
    [self profileSetUp];
    [self getShoes];
}

#pragma mark - Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    UIImage *image = [self.shoePhotoArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 319, 319);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shoePhotoArray.count;
}

#pragma mark - Helper Method
-(void)getShoes
{
    PFQuery *query = [PFQuery queryWithClassName:@"Shoe"];
    [query whereKey:@"owner" equalTo:self.thisCustomer];
    [query orderByAscending:@"createAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *shoe in objects) {
            PFFile *file = [shoe objectForKey:@"Photo0"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.shoePhotoArray addObject:image];
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}

-(void)profileSetUp
{

    if (!self.thisCustomer) { //if not send from other one
        self.thisCustomer = [PFCustomer currentCustomer]; //got user
        NSLog(@"in here");
        //NSLog(@"current customer is : %@",[PFCustomer currentCustomer]);
    } else {
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }

    //NSLog(@"this customer is : %@",self.thisCustomer);
    NSString *profileID = [self.thisCustomer objectForKey:@"FBid"];
    //NSLog(@"id equals %@",profileID);

    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            NSLog(@"error : %@",error);
        }
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",profileID];
            //NSLog(@"url equals %@",userImageURL);
            NSURL *url = [NSURL URLWithString:userImageURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            self.profilePictureView.image = image;
        }
    }];
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
