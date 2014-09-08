//
//  WebViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 07/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:self.displayURL];
    [self.webView loadRequest:requestURL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"something went wrong when you trying to reach their profile" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alert show];
}




@end
