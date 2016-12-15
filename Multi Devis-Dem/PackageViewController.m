//
//  PackageViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 18/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "PackageViewController.h"
#import "PathFinder.h"
@interface PackageViewController ()

@end

@implementation PackageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_packageDescriptionView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[PathFinder getHtmlPath]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
