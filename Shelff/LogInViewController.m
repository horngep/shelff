//
//  ViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 29/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "LogInViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LogInViewController () <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBLoginView *fbLogInView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    //FirstTime Logging in
    self.nameLabel.text = @"Please Log In to continue";
    self.continueButton.hidden = YES;

    //requesting information
    self.fbLogInView.readPermissions = @[@"public_profile", @"user_friends"];
}

#pragma mark - FBLoginViewDelegate
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // This method will be called when the app got user information

    //TODO: get public_profile that i need
    //TODO: get friend list


    // "user" is what we got from "public_profile" readPermissions when logged in
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;


//https://developers.facebook.com/docs/facebook-login/permissions/v2.1#reference-public_profile
//    public_profile (Default)
//
//    Provides access to a subset of items that are part of a person's public profile. A person's public profile refers to the following properties on the user object by default:
//
//    id
//    name
//    first_name
//    last_name
//    link
//    gender
//    locale
//    age_range

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
