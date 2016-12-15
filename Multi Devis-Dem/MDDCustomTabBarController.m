//
//  MDDCustomTabBarController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 04/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDCustomTabBarController.h"
#import "MDDAddRoomsViewController.h"
#import "MDDFormulaireViewController.h"
#import "MDDCategoryViewController.h"
#import "MDDValidationViewController.h"
@interface MDDCustomTabBarController ()

@end

@implementation MDDCustomTabBarController

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
    //Setting the selected and Unselected images for all the tab bar items.
    
    
    UITabBarItem *formualaireTabItem=[[self.tabBar items] objectAtIndex:0];    
    [formualaireTabItem setSelectedImage:[[UIImage imageNamed:@"form-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [formualaireTabItem setImage:[[UIImage imageNamed:@"form"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    
    UITabBarItem *volumeTabItem=[self.tabBar.items objectAtIndex:1];
    volumeTabItem.selectedImage=[[UIImage imageNamed:@"calculator-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    volumeTabItem.image=[[UIImage imageNamed:@"calculator"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *categoryTabItem=[self.tabBar.items objectAtIndex:2];
    categoryTabItem.selectedImage=[[UIImage imageNamed:@"category-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    categoryTabItem.image=[[UIImage imageNamed:@"category"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *validationTabItem=[self.tabBar.items objectAtIndex:3];
    validationTabItem.selectedImage=[[UIImage imageNamed:@"validation-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    validationTabItem.image=[[UIImage imageNamed:@"validation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
