//
//  MDDViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 03/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDViewController.h"
#import "MDDHomeViewController.h"
@interface MDDViewController ()

@end

@implementation MDDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myTimer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(showProgressing) userInfo:nil repeats:YES];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)showProgressing
{
    static float progressValue=0;
    if (progressValue<=1.0f) {
        _homeScreenProgressView.progress=progressValue;
        progressValue+=0.25f;
    }
    else
    {
        [_myTimer invalidate];
       
       UINavigationController *homeScreenController=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
       [self presentViewController:homeScreenController animated:NO completion:nil];
    }
    
}

@end
