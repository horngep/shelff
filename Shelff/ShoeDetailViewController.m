//
//  ShoeDetailViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 03/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ShoeDetailViewController.h"
#import "PFCustomer.h"

@interface ShoeDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property NSMutableArray *shoePhotos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

#define kNoOfPhotoAllow 6

@end

@implementation ShoeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:0.67 green:0.8 blue:0.75 alpha:1];
    self.shoePhotos = [NSMutableArray new]; //this is use for scrollView and pageControl purpose
    self.collectionView.pagingEnabled = YES;

    self.nameLabel.text = self.shoe[@"name"];
    self.nameLabel.font = [UIFont fontWithName:@"Georgia" size:16];
    self.sizeLabel.text = [NSString stringWithFormat:@"Size %@",self.shoe[@"size"]];
    [self getPhotoFromParse];

    [self.collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    if (![self.thisCustomer isEqual:[PFCustomer currentCustomer]]) {
        [self.navigationItem setRightBarButtonItems:nil animated:YES];
    }


    [self designEnable];
}

-(void)designEnable
{

    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];



}


-(void)getPhotoFromParse
{
    for (int i = 0; i< kNoOfPhotoAllow; i++) {
        PFFile *file = [self.shoe objectForKey:[NSString stringWithFormat:@"Photo%d",i]];
        if (file) {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.shoePhotos addObject:image];
                    self.pageControl.numberOfPages =  self.shoePhotos.count;

                    [self.collectionView reloadData];
                }
            }];
        } else {
            break;
        }
    }
}

#pragma mark - delete shoe
- (IBAction)trashButtonClick:(id)sender
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this shoe?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIApplication* app = [UIApplication sharedApplication]; //netWorkActivityIndicator
        app.networkActivityIndicatorVisible = YES;

        //delete
        [self.shoe deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                app.networkActivityIndicatorVisible = NO;
                [self performSegueWithIdentifier:@"unwindSegue" sender:self];
            }
        }];
    }
}

#pragma mark - Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.shoePhotos objectAtIndex:indexPath.row]];
    imageView.frame = CGRectMake(0, 0, 319, 319);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    [cell.contentView addSubview:imageView];
    return cell;
}

//fixing the offset of cells when scroll
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(311 , 311);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shoePhotos.count;
}

//this is for collectionview (which inherit from scrollView)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

@end
