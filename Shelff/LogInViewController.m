//
//  ViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 29/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "LogInViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "PFCustomer.h"

@interface LogInViewController () <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBLoginView *fbLogInView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(40, 200, 280, 192)];
//    UIImage *image = [UIImage imageNamed:@"sneaker1.png"];
//    imageHolder.image = image;
//    // optional:
//    // [imageHolder sizeToFit];
//    [self.view addSubview:imageHolder];




    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //FirstTime Logging in
    self.nameLabel.text = @"Please Log In to continue";
    self.continueButton.hidden = YES;

    //requesting information
   // self.fbLogInView = [FBLoginView new];
    self.fbLogInView.readPermissions = @[@"public_profile", @"email", @"user_friends"];


}

-(void)viewWillAppear:(BOOL)animated
{

}


#pragma mark - FBLoginViewDelegate
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // This method will be called when the app got user information

    // "user" is what we got from "public_profile" readPermissions when logged in
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;
    self.loggedInUser = user; //Get from Facebook

    //Parse
    //Check if user exist, if not, save it
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query whereKey:@"FBid" equalTo:(id)user.objectID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            PFObject *customer = [PFObject objectWithClassName:@"Customer"];
            [customer setObject:user.objectID forKey:@"FBid"];
            //NOTE: profile pic can be obtain from FBid using FBProfilePictureView
            [customer setObject:user.name forKey:@"FBName"];
            [customer setObject:user.link forKey:@"FBLink"];
            [customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"saved");
                    //set current customer as Parse
                    [PFCustomer setCurrentCustomer:(PFCustomer *)customer];
                }
            }];

        } else if (object) {
           // NSLog(@"existing user"); //Existing user

            //set current customer as Parse
            [PFCustomer setCurrentCustomer:(PFCustomer *)object];

        } else if (error) {
            NSLog(@"error : %@",error);
        }
    }];

    //https://developers.facebook.com/docs/facebook-login/permissions/v2.1#reference-public_profile
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    //Logged In User Experience
    self.continueButton.hidden = NO;

    //TODO: Perform segue to next VC
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    //Logged Out User Experience
    //For Shelff, we WONT enable Logging Out
    self.nameLabel.text = @"Please Log In to continue";
    self.continueButton.hidden = YES;
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;

    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];


        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";



    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        alertTitle = @"Log in Error";
        alertMessage = @"You must Log in with Facebook to use Shelff";


        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }

    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
@end
