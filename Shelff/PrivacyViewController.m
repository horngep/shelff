//
//  PrivacyViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 23/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webVIew.delegate = self;
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    NSURL *url = [NSURL URLWithString:@"https://policy-portal.truste.com/core/privacy-policy/Shelff/6d5534ab-e858-42b8-83a0-885eb95fbca4#landingPage"];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [self.webVIew loadRequest:requestURL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"something went wrong when you trying to reach their profile" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alert show];
}

@end
