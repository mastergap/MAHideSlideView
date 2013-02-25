//
//  ViewController.m
//  SlideViewControl
//
//  Created by Michele Ambrosi on 20/02/13.
//  Copyright (c) 2013 Intesys. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+ScreenDimensions.h"

@implementation ViewController {
    MAHideSlideView *purpleSlideViewControl;
    MAHideSlideView *yellowSlideViewControl;
    MAHideSlideView *greenSlideViewControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tileable_wood_texture.png"]]];
    
    //purple MAHideSlideView initialization
    purpleSlideViewControl = [[MAHideSlideView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andCoverImage:[UIImage imageNamed:@"normal_cover.png"] andHiddenImage:[UIImage imageNamed:@"normal_hidden"]];

    [purpleSlideViewControl setButtonMode:YES];
    
    [purpleSlideViewControl addHiddenButtonTarget:self action:@selector(slideViewButtonTapped:) forEvent:UIControlEventTouchUpInside];
    
    [purpleSlideViewControl setDelegate:self];
    
    [purpleSlideViewControl setButtonTitle:@"Tap Me" forControlState:UIControlStateNormal];
    
    [purpleSlideViewControl setButtonTitleColor:[UIColor blackColor] forControlState:UIControlStateNormal];
    
    [purpleSlideViewControl setButtonTitleShadowColor:[UIColor whiteColor] forControlState:UIControlStateNormal];
    
    [purpleSlideViewControl setButtonTitleShadowOffset:CGSizeMake(0, -1)];
    
    [purpleSlideViewControl setButtonTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:30]];
    
    [self.view addSubview:purpleSlideViewControl];
    
    //yellow MAHideSlideView initialization
    yellowSlideViewControl = [[MAHideSlideView alloc] initWithFrame:CGRectMake(60, 150, 0, 0) andCoverImage:[UIImage imageNamed:@"mid_cover.png"] andHiddenImage:[UIImage imageNamed:@"mid_hidden.png"]];
    
    [self.view addSubview:yellowSlideViewControl];
    
    //green MAHideSlideView initialization
    greenSlideViewControl = [[MAHideSlideView alloc] initWithFrame:CGRectMake(80, 570, 0, 0) andCoverImage:[UIImage imageNamed:@"small_cover.png"] andHiddenImage:[UIImage imageNamed:@"small_hidden.png"]];
    
    [self.view addSubview:greenSlideViewControl];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [purpleSlideViewControl setOrigin:CGPointMake((self.view.bounds.size.width - purpleSlideViewControl.frame.size.width) / 2, (self.view.bounds.size.height - purpleSlideViewControl.frame.size.height) / 2)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slideViewButtonTapped:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"MAHideSlideView button tapped" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize nextViewSize = [UIApplication sizeInOrientation:toInterfaceOrientation];
    [UIView animateWithDuration:0.3f animations:^{
        [purpleSlideViewControl setOrigin:CGPointMake((nextViewSize.width - purpleSlideViewControl.frame.size.width) / 2, (nextViewSize.height - purpleSlideViewControl.frame.size.height) / 2)];
    }];
}

#pragma mark SlideViewControlDelegate methods
- (void)slideViewControlDidClose:(MAHideSlideView *)slideViewControl {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"MAHideSlideView closed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)slideViewControlDidOpen:(MAHideSlideView *)slideViewControl {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"MAHideSlideView opened" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
