//
//  MDDHomeCategoryViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 26/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDHomeCategoryViewController.h"
#import "PackageViewController.h"
@interface MDDHomeCategoryViewController ()

@end

@implementation MDDHomeCategoryViewController
{
    NSArray *categoryArray;
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
    categoryArray=[NSArray arrayWithObjects:@{@"Task": @" La manutention, le chargement, le transport et la livraison de l'ensemble des affaires",@"Economic":@"checkmark.png",@"Standard":@"checkmark.png",@"Comfort":@"checkmark.png"},@{@"Task": @"La protection de vos meubles à l'aide de couvertures, bull craft, papier ondulé, housse",@"Economic":@"checkmark.png",@"Standard":@"checkmark.png",@"Comfort":@"checkmark.png"},@{@"Task": @"Le démontage et le remontage de vos meubles",@"Economic":@"close_icon.png",@"Standard":@"checkmark.png",@"Comfort":@"checkmark.png"},@{@"Task": @"L’emballage et le déballage de vos objets fragiles (vaisselle, luminaire, biblio, cadres, HiFi...",@"Economic":@"close_icon.png",@"Standard":@"checkmark.png",@"Comfort":@"checkmark.png"},@{@"Task": @"L’emballage de vos objets non fragiles",@"Economic":@"close_icon.png",@"Standard":@"close_icon.png",@"Comfort":@"checkmark.png"}, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CataCell"];
    UILabel *taskLabel=(UILabel *)[cell viewWithTag:4];
    taskLabel.text=[categoryArray objectAtIndex:indexPath.row][@"Task"];
    UIImageView *economyImage=(UIImageView *)[cell viewWithTag:1];
    UIImageView *standardImage=(UIImageView *)[cell viewWithTag:2];
    UIImageView *comfortImage=(UIImageView *)[cell viewWithTag:3];
    economyImage.image=[UIImage imageNamed:[categoryArray objectAtIndex:indexPath.row][@"Economic"]];
    standardImage.image=[UIImage imageNamed:[categoryArray objectAtIndex:indexPath.row][@"Standard"]];
    comfortImage.image=[UIImage imageNamed:[categoryArray objectAtIndex:indexPath.row][@"Comfort"]];
    if (indexPath.row %2==0)
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    return cell;
}
-(IBAction)infoAction:(id)sender
{
    PackageViewController *packageDescriptor=[self.storyboard instantiateViewControllerWithIdentifier:@"PackageView"];
    [self.navigationController pushViewController:packageDescriptor animated:YES];
}
@end
