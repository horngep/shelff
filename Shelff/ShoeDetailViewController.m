//
//  ShoeDetailViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 03/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "ShoeDetailViewController.h"

@interface ShoeDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property NSMutableArray *shoePhotos;

#define kNoOfPhotoAllow 6

@end

//get the collection View to work first

// MAX - this is for paging
//[collectionview addgesture: scrollview.pangesture]
//collectionview.gesture = no

//scrollview content size = collection view content size
// use paging accroding to scrollview

@implementation ShoeDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shoePhotos = [NSMutableArray new]; //this is use for scrollView and pageControl purpose
    self.collectionView.pagingEnabled = YES;

    [self getPhotoFromParse];
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
                    NSLog(@"no of images is %d",self.shoePhotos.count);

                    [self.collectionView reloadData];
                }
            }];
        } else {
            break;
        }
    }
}

#pragma mark - Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.shoePhotos objectAtIndex:indexPath.row]];
    imageView.frame = CGRectMake(0, 0, 319, 319);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shoePhotos.count;
}

@end
