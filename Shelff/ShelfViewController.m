//
//  ShelfViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 30/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ShelfViewController.h"
#import "SWRevealViewController.h"
#import "ShoeDetailViewController.h"
#import "UploadViewController.h"

@interface ShelfViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusBarButton;
@property NSMutableArray *shoePhotoArray;
@property NSArray *shoeArray;
@end

@implementation ShelfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.pagingEnabled = YES;
    self.shoeArray = [NSArray new];
    self.shoePhotoArray = [NSMutableArray new]; // for display

    [self setSideBar];
    [self profileSetUp];
    [self getShoes];
}

-(void)getShoes
{
    PFQuery *query = [PFQuery queryWithClassName:@"Shoe"];
    [query whereKey:@"owner" equalTo:self.thisCustomer];
    [query orderByAscending:@"createAt"]; //TODO: get the newest on top (this is not working)
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.shoeArray = objects;

        for (PFObject *shoe in self.shoeArray) {
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addShoeSegue"]) {

    } else if ([segue.identifier isEqualToString:@"shoeDetailSegue"]) {
        ShoeDetailViewController *vc = segue.destinationViewController;
        vc.shoe = [self.shoeArray objectAtIndex:[self.collectionView indexPathForCell:(UICollectionViewCell *)sender].row];
    } else if ([segue.identifier isEqualToString:@"logoutSegue"]) {

    }
}

#pragma mark - Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    UIImage *image = [self.shoePhotoArray objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

    //details
    imageView.frame = CGRectMake(0, 0, 319, 319);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    [cell.contentView addSubview:imageView];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shoePhotoArray.count;
}

#pragma mark - Helper Method
-(void)profileSetUp
{
    if (!self.thisCustomer) { //if not send from other one
        self.thisCustomer = [PFCustomer currentCustomer]; //got user
    } else {
        //TODO: hide right bar button item
        NSLog(@"your Friend's Shelf: %@",self.thisCustomer);
    }

    NSString *profileID = [self.thisCustomer objectForKey:@"FBid"];

    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            NSLog(@"error : %@",error);
        }
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",profileID];
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

#pragma mark - unwind from Upload VC
- (IBAction)unwindToShelfViewController:(UIStoryboardSegue *)unwindSegue
{
    UploadViewController *uvc = unwindSegue.sourceViewController;
}

@end
