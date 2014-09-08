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


@interface UploadViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISlider *sizeSliderBar;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property NSMutableArray *shoePics;


#define kNoOfPhotoAllow 6
//number of photo allowed to save on parse

@end

@implementation UploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shoePics = [NSMutableArray new]; //array of images

    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Upload Shoe Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera Roll", @"Camera",
                            nil];
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = self.shoePics.count;
    self.scrollView.contentSize = CGSizeMake((320 * self.shoePics.count), 320);

    NSLog(@"%@", self.scrollView);
}

- (IBAction)uploadButtonPressed:(id)sender
{
    if (self.shoePics.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Picture" message:@"you need a shoe picture!" delegate:self cancelButtonTitle:@"Oops" otherButtonTitles:nil, nil];
        [alert show];

    } else {
        PFObject *shoe = [PFObject objectWithClassName:@"Shoe"];
        [shoe setObject:[PFCustomer currentCustomer] forKey:@"owner"];
        [shoe setObject:self.nameTextField.text forKey:@"name"];
        [shoe setObject:[NSNumber numberWithDouble:[self.sizeLabel.text doubleValue]]
                 forKey:@"size"];

        for (int i = 0; i < self.shoePics.count; i++) {
            UIImage *image = [self.shoePics objectAtIndex:i];
            PFFile *file = [PFFile fileWithData:UIImagePNGRepresentation(image)];
            [shoe setObject:file forKey:[NSString stringWithFormat:@"Photo%d",i]];
        }

        UIApplication* app = [UIApplication sharedApplication]; //netWorkActivityIndicator
        app.networkActivityIndicatorVisible = YES;

        [shoe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                app.networkActivityIndicatorVisible = NO;
                NSLog(@"photo saved");
                [self performSegueWithIdentifier:@"unwindToShelf" sender:self];
            }
        }];
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

-(void)showCarera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - action
- (IBAction)onSizeSliderChange:(id)sender
{
    double number = round(self.sizeSliderBar.value * 2.0) / 2.0;
    self.sizeLabel.text = [NSString stringWithFormat:@"%.1f",number];
}

- (IBAction)addButtonPressed:(id)sender
{

    if (self.shoePics.count == kNoOfPhotoAllow) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO MORE!" message:@"you can only upload 5 photo per shoe!" delegate:self cancelButtonTitle:@"Fine :(" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        //show action sheet to choose between Camera or CameraRoll
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Upload Shoe Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Camera Roll", @"Camera",
                                nil];
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            [self showImagePicker];
            break;
        case 1:
            [self showCarera];
            break;
        default:
            break;
    }
}

#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField *)textField up: (BOOL) up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed

    int movement = (up ? -movementDistance : movementDistance);

    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;

    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}


@end
