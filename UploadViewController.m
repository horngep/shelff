//
//  UploadViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 02/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "UploadViewController.h"
#import <Parse/Parse.h>
#import "PFCustomer.h"


@interface UploadViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableArray *shoePics;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

#define kNoOfPhotoAllow 6
//number of photo allowed to save on parse

@end

@implementation UploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showImagePicker];
    self.shoePics = [NSMutableArray new]; //array of images
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake((320 * self.shoePics.count), 320);
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = self.shoePics.count;
}

- (IBAction)uploadButtonPressed:(id)sender
{
    if (self.shoePics.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Picture" message:@"you need a shoe picture!" delegate:self cancelButtonTitle:@"Oops" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        PFObject *shoe = [PFObject objectWithClassName:@"Shoe"];
        [shoe setObject:[PFCustomer currentCustomer] forKey:@"owner"];

        for (int i = 0; i < self.shoePics.count; i++) {
            UIImage *image = [self.shoePics objectAtIndex:i];
            PFFile *file = [PFFile fileWithData:UIImagePNGRepresentation(image)];
            [shoe setObject:file forKey:[NSString stringWithFormat:@"Photo%d",i]];
        }
        [shoe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"photo saved");
            }
        }];
    }
}

- (IBAction)addButtonPressed:(id)sender
{
    if (self.shoePics.count == kNoOfPhotoAllow) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO MORE!" message:@"you can only upload 5 photo per shoe!" delegate:self cancelButtonTitle:@"Fine :(" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self showImagePicker];
    }
}

- (void)showImagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    imageView.frame = CGRectMake((320 * self.shoePics.count), 0, 320, 320);
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.shoePics addObject:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Scroll View Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
}

@end
