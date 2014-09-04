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

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO: only show this view if its the first time useing this app

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
            
            [nextButton setTitle:@"Get Started" forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [nextButton setFrame:CGRectMake(121 + (imageView.frame.size.width *2), 480, 90, 30)];
            nextButton.titleLabel.textColor = [UIColor greenColor];

            [nextButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
            [self.scrollView addSubview:nextButton];

            if (i == 1) {
                UILabel *firstLabel = [[UILabel alloc]init];
                firstLabel.font = [UIFont fontWithName:@"Georgia" size:36];
                [firstLabel setText:@"Shelf The digital closet for your sneakers"];
                [firstLabel setFrame:CGRectMake(121, 480, 90, 30)];
                firstLabel.textColor = [UIColor greenColor];
                [self.scrollView addSubview:firstLabel];
            }

        }
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
}

@end
