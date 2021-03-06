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
#import "WebViewController.h"

@interface ShelfViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusBarButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIButton *bigButton1;
@property (weak, nonatomic) IBOutlet UIButton *bigButton2;
@property NSMutableArray *shoePhotoArray;
@property NSArray *shoeArray;
@end

@implementation ShelfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Shelff";

    self.collectionView.pagingEnabled = YES;
    [self designEnable];

    [self.collectionView reloadData];
    [self.collectionView2 reloadData];

    self.upperView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.shoeArray = [NSArray new];
    self.shoePhotoArray = [NSMutableArray new]; // for display
    self.collectionView.hidden = NO;
    self.collectionView2.hidden = YES; //hide multiple initially

    [self setSideBar];
    [self profileSetUp];
    [self getShoes];

    self.bigButton1.backgroundColor = [UIColor colorWithRed:0.19 green:0.14 blue:0.2 alpha:0.5];
    self.bigButton2.backgroundColor = [UIColor whiteColor];

//    [self.collectionView reloadData];
//    [self.collectionView2 reloadData];

}

-(void)designEnable
{
    self.upperView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];


    self.bigButton1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.bigButton2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.bigButton1.layer.cornerRadius = 5;
    self.bigButton2.layer.cornerRadius = 5;
    self.bigButton1.layer.masksToBounds = YES;
    self.bigButton2.layer.masksToBounds = YES;


    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePictureView.layer.borderWidth = 3.0f;
    self.profilePictureView.layer.cornerRadius = 30;
    self.profilePictureView.layer.masksToBounds = YES;

    self.profileButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.profileButton.layer.cornerRadius = 5;
    self.profileButton.layer.masksToBounds = YES;


    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.collectionView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}

#pragma mark - Actions

- (IBAction)onRightBarButtonItemPressed:(id)sender
{
    if ([self.plusBarButton.title isEqual:@"Add Shoe"]) {
        [self performSegueWithIdentifier:@"addShoeSegue" sender:self];

    } else if ([self.plusBarButton.title isEqual:@"Report"]){
        // action sheet
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Do you want to report this person ?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Report",
                                nil];
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        NSLog(@"BAR BUTTON ERROR!");
    }
}

- (IBAction)onDisplaySingleCollectionViewButtonPressed:(id)sender
{
    self.collectionView.hidden = NO; //show single
    self.collectionView2.hidden = YES; //hide multiple
    self.bigButton1.backgroundColor = [UIColor colorWithRed:0.19 green:0.14 blue:0.2 alpha:0.5];
    self.bigButton2.backgroundColor = [UIColor whiteColor];
}

- (IBAction)onDisplayMultipleCollectionViewButtonClick:(id)sender
{
    self.collectionView.hidden = YES;
    self.collectionView2.hidden = NO;
    self.bigButton2.backgroundColor = [UIColor colorWithRed:0.19 green:0.14 blue:0.2 alpha:0.5];
    self.bigButton1.backgroundColor = [UIColor whiteColor];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addShoeSegue"]) {

    } else if ([segue.identifier isEqualToString:@"shoeDetailSegue1"]) {
        ShoeDetailViewController *vc = segue.destinationViewController;

        vc.shoe = [self.shoeArray objectAtIndex:[self.collectionView indexPathForCell:(UICollectionViewCell *)sender].row];
        vc.thisCustomer = self.thisCustomer;

    } else if ([segue.identifier isEqualToString:@"shoeDetailSegue2"]) {
        ShoeDetailViewController *vc = segue.destinationViewController;

        vc.shoe = [self.shoeArray objectAtIndex:[self.collectionView2 indexPathForCell:(UICollectionViewCell *)sender].row];
        vc.thisCustomer = self.thisCustomer;

    }else if ([segue.identifier isEqualToString:@"logoutSegue"]) {

    } else if ([segue.identifier isEqualToString:@"toWebView"]) {
        WebViewController *wvc = segue.destinationViewController;
        wvc.displayURL = [NSURL URLWithString:self.thisCustomer[@"FBLink"]];
    }
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            //set the Report to YES
            [self.thisCustomer setObject:@YES forKey:@"Report"];
            [self.thisCustomer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"successfully reported");
            }];
            break;
        default:
            break;
    }
}

#pragma mark - Helper Method
-(void)profileSetUp
{
    if (!self.thisCustomer) { //if not send from other one

        self.thisCustomer = [PFCustomer currentCustomer]; //got user
        self.plusBarButton.title = @"Add Shoe";
        NSLog(@"New  : %@",self.thisCustomer);

    } else {
        if ([self.thisCustomer isEqual:[PFCustomer currentCustomer]]){
            self.plusBarButton.title = @"Add Shoe";

        } else {
            NSLog(@"your Friend's Shelf: %@",self.thisCustomer);
            self.plusBarButton.title = @"Report";
        }

    }

    NSString *profileID = self.thisCustomer[@"FBid"];
    self.customerLabel.text = self.thisCustomer[@"FBName"];

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

-(void)getShoes
{
    self.shoeArray = [NSArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Shoe"];
    [query whereKey:@"owner" equalTo:self.thisCustomer];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.shoeArray = objects;

        //self.shoePhotoArray = [NSMutableArray new];
        for (int x = 0; x < objects.count; ++x)
             [self.shoePhotoArray addObject:[NSNull null]];

        for (PFObject *shoe in self.shoeArray) {
            int x = [self.shoeArray indexOfObject:shoe];

            PFFile *file = [shoe objectForKey:@"Photo0"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    //TODO: save it into a Dictionary with Key:objectID Value: Photo0 instead

                    [self.shoePhotoArray replaceObjectAtIndex:x withObject:image];

                    if (![self.shoePhotoArray containsObject:[NSNull null]]){
                        [self.collectionView reloadData];
                        [self.collectionView2 reloadData];
                    }
                }

            }];
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

}


#pragma mark - Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[self.shoePhotoArray objectAtIndex:indexPath.row] isEqual:[NSNull null]]){
        NSLog(@"Error: Image is Null");
    }


    //for single
    if ([collectionView isEqual:self.collectionView]) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID1" forIndexPath:indexPath];

        UIImage *image = [self.shoePhotoArray objectAtIndex:indexPath.row];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

        //details
        imageView.frame = CGRectMake(0, 0, 312, 312); //big imageView
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:imageView];


        return cell;

    } else if ([collectionView isEqual:self.collectionView2]) { //for multiple

        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID2" forIndexPath:indexPath];

        UIImage *image = [self.shoePhotoArray objectAtIndex:indexPath.row];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

        //details
        imageView.frame = CGRectMake(0, 0, 100, 100); //small imageView
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }

        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:imageView];

        return cell;
    } else {
        NSLog(@"ERROR with CollectionView Delegate!");
        return nil;
    }


}

//fixing the offset of cells when scroll
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(303 , 303);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"COUNT %d",self.shoePhotoArray.count);
    return self.shoePhotoArray.count;
}



@end
