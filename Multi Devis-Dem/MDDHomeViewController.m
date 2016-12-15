//
//  MDDHomeViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 03/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//
#define NavigationBarFrame self.navigationController.navigationBar.frame
#import "MDDHomeViewController.h"
#import "MDDCustomTabBarController.h"
#import "CustomNavBar.h"
#import "SQLiteDbController.h"
#import "MDDVueViewController.h"
@interface MDDHomeViewController ()

@end

@implementation MDDHomeViewController
{
    NSMutableDictionary* customerInfo;
}
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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    SQLiteDbController *dbController=[[SQLiteDbController alloc]init];
    customerInfo=[dbController retrieveDetailsOfCustomer];
    
    if ([customerInfo allKeys].count==0) {
        _vueButton.hidden=YES;
        _vueLabel.hidden=YES;
    }
    else
    {
        _vueButton.hidden=NO;
        _vueLabel.hidden=NO;
    }
    //  _vueButton.hidden=YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NavigationBarFrame=CGRectMake(0,40,NavigationBarFrame.size.width, NavigationBarFrame.size.height);
    //Adding status Bar image
    UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, NavigationBarFrame.size.width, 20)];
    statusBarImage.image=[UIImage imageNamed:@"status_bar"];
    [self.navigationController.navigationBar addSubview:statusBarImage];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewQuotations"]) {
        MDDVueViewController *viewQuotationsController=[segue destinationViewController];
        viewQuotationsController.quotationDictionary=customerInfo;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
