//
//  StartViewController.m
//  Shelff
//
//  Created by I-Horng Huang on 29/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "StartViewController.h"


@interface StartViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeTextLabel;

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //For the first time use to look more smooth
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"]) {
        self.view.backgroundColor = [UIColor colorWithRed:0.013 green:0.086 blue:0.21 alpha:1];
        return;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

    
    self.scrollView.contentSize = CGSizeMake(3*320, 568);
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;


    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"background%d.png",i+1]]];
        imageView.frame = CGRectMake((i)*320, 0, 320, 568);
        [self.scrollView addSubview:imageView];

        if (i == 2) { //add button on the last view
            UIButton *nextButton = [[UIButton alloc] init];
            
            [nextButton setTitle:@"Continue" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];

            [nextButton setFrame:CGRectMake(111 + (imageView.frame.size.width *2), 120, 100, 30)];
            nextButton.titleLabel.textColor = [UIColor blackColor];

            [nextButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
            [self.scrollView addSubview:nextButton];

        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //First time using the app
    [super viewDidAppear:NO];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"]) {
        [self performSegueWithIdentifier:@"toLoginView" sender:@"ivan"];
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)buttonPressed
{
    [self performSegueWithIdentifier: @"toLoginView" sender: self];
}

#pragma mark - Scroll View Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;

    self.welcomeTextLabel.numberOfLines = 3;

    if (self.pageControl.currentPage == 0 ) {
        self.welcomeTextLabel.text = @"Welcome to Shelf";

    } else if (self.pageControl.currentPage == 1) {
        self.welcomeTextLabel.text = @"Shelf is a place for you to show off your shoe collections to your friends.";

    } else if (self.pageControl.currentPage == 2) {
        self.welcomeTextLabel.text = @"";
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}


@end
