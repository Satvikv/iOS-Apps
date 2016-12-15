//
//  MDDAddRoomsViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//
#define NavigationBarFrame self.navigationController.navigationBar.frame
#import "MDDAddRoomsViewController.h"
#import "PathFinder.h"
#import "CustomNavBar.h"
#import "MDDCustomTabBarController.h"
@interface MDDAddRoomsViewController ()

@end

@implementation MDDAddRoomsViewController
{
    NSMutableArray *addedRooms;
    NSMutableDictionary *inventoryDictionary;
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
    
    [self setUp];
}
-(void)getDictionary:(id)sender :(NSDictionary *)inventory
{
    inventoryDictionary=[NSMutableDictionary dictionaryWithDictionary:inventory];
}
-(void)viewDidAppear:(BOOL)animated
{
    NavigationBarFrame=CGRectMake(0,40,320,44);
    //Adding status Bar image
    UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, 320, 20)];
    statusBarImage.image=[UIImage imageNamed:@"status_bar"];
    [self.navigationController.navigationBar addSubview:statusBarImage];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
}
-(void) setUp
{
    NSString *roomsPlistPath=[PathFinder getItemsPlistDirectoryPath];
    _roomsArray=[NSArray arrayWithContentsOfFile:roomsPlistPath];
    
    addedRooms=[NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no",@"no",@"no",@"no",@"no",@"no",@"no",@"no", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _roomsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[self.rooms_table dequeueReusableCellWithIdentifier:@"RoomsCell"];
    NSDictionary *roomsDictionary=_roomsArray[indexPath.row];
    Cell.textLabel.text=roomsDictionary[@"Room_name"];
    UIImage *image;
    if ([addedRooms[indexPath.row] isEqualToString:@"no"]) {
        image=[UIImage imageNamed:@"add"];
    }
    else
    {
        image=[UIImage imageNamed:@"remove"];
    }
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(40, 0, 22, 22)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(add_remove_Button: withEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=indexPath.row+100;
    Cell.accessoryView = button;
    if (indexPath.row %2==0)
        Cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        Cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    return Cell;
}
#pragma mark-add button action
- (void)add_remove_Button:(UIButton *)sender withEvent: (UIEvent *)events{
    
    if ([addedRooms[sender.tag-100] isEqualToString:@"no"]) {
        
        [addedRooms replaceObjectAtIndex:sender.tag-100 withObject:@"yes"];
        
        [sender setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    }
    else
    {
        [addedRooms replaceObjectAtIndex:sender.tag-100 withObject:@"no"];
        [inventoryDictionary removeObjectForKey:[_roomsArray[sender.tag-100] objectForKey:@"Room_name"]];
        [sender setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
}
#pragma mark- segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Suivant"]) {
        MDDAddItemsViewController *itemsController=[segue destinationViewController];
        itemsController.delegate=self;
        itemsController.addedRoomsArray=[NSMutableArray array];
        for (int i=0; i<_roomsArray.count; i++) {
            NSString *status=addedRooms[i];
            if ([status caseInsensitiveCompare:@"yes"]==NSOrderedSame) {
                NSDictionary *roomDic=_roomsArray[i];
                [itemsController.addedRoomsArray addObject:roomDic[@"Room_name"]];
            }
        }
        itemsController.customer_Id=[_customer_Id intValue];
        itemsController.inventoryDictionary=[NSMutableDictionary dictionaryWithDictionary:inventoryDictionary];
    }
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([addedRooms containsObject:@"yes"]==NO) {
        UIAlertView *noRoomsAlert=[[UIAlertView alloc]initWithTitle:@"Pas de chambre!" message:@"S'il vous plaît ajoutez chambres pour continuer" delegate:nil cancelButtonTitle:@"bien" otherButtonTitles: nil];
        [noRoomsAlert show];
        return NO;
    }
    return YES;
}
#pragma mark- button and bar button actions
- (IBAction)submit_Rooms_Action:(UIButton *)sender {
}

- (IBAction)backPress:(UIBarButtonItem *)sender {
    [self.tabBarController setSelectedIndex:0];
}
@end
