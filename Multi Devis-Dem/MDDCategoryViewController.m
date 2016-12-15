//
//  MDDCategoryViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//
#define NavigationBarFrame self.navigationController.navigationBar.frame
#import "MDDCategoryViewController.h"
#import "PathFinder.h"
#import "MDDValidationViewController.h"
#import "SQLiteDbController.h"
@interface MDDCategoryViewController ()

@end

@implementation MDDCategoryViewController
{
    NSMutableArray *tasksArray;
    NSMutableArray *completedTaskArray;
    SQLiteDbController *dbCtrl;
    
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
	NSString *taskPlistPath=[PathFinder getTaskPlistDirectoryPath];
    tasksArray=[NSMutableArray arrayWithContentsOfFile:taskPlistPath];
    completedTaskArray=[NSMutableArray array];
    
    dbCtrl=[[SQLiteDbController alloc]init];
    [dbCtrl createOrderTable];
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Task";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tasksArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    UIButton *checkButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    checkButton.tag=indexPath.row+100;
    NSString *task=tasksArray[indexPath.row];
    
    if ([completedTaskArray containsObject:tasksArray[indexPath.row]]==YES) {
        [checkButton setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateNormal];
    }
    else
    {
        [checkButton setImage:[UIImage imageNamed:@"check_box_empty.png"] forState:UIControlStateNormal];
    }
    [checkButton addTarget:self action:@selector(checkTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:checkButton];
    UILabel *taskLabel=(UILabel *)[cell viewWithTag:10];
    taskLabel.text=task;
    if (indexPath.row %2==0)
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    
    return cell;
}
-(void) checkTaskAction :(UIButton *) sender
{
    NSString *task=tasksArray[sender.tag-100];
    
    if (![completedTaskArray containsObject:task]) {
        [completedTaskArray addObject:task];
        [sender setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateNormal];
    }
    else {
        
        [sender setImage:[UIImage imageNamed:@"check_box_empty.png"] forState:UIControlStateNormal];
        [completedTaskArray removeObject:task];
        
    }
}
- (IBAction)packagePress:(UIButton *)sender
{
    // sender.selected=!sender.isSelected;
    if ([sender isEqual:_ecobutton]) {
        [_ecobutton setSelected:YES];
        [_stdButton setSelected:NO];
        [_comButton setSelected:NO];
        dbCtrl.category=@"Economic";
    }
    else if ([sender isEqual:_stdButton]) {
        [_ecobutton setSelected:NO];
        [_stdButton setSelected:YES];
        [_comButton setSelected:NO];
        dbCtrl.category=@"Comfort";
    }
    else  if ([sender isEqual:_comButton]) {
        [_ecobutton setSelected:NO];
        [_stdButton setSelected:NO];
        [_comButton setSelected:YES];
        dbCtrl.category=@"Standard";
    }
}
- (IBAction)backBarButtonAction:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)termineButtonAction:(id)sender {
    
    if (_ecobutton.selected==NO && _stdButton.selected==NO && _comButton.selected==NO) {
        UIAlertView *categoryAlert=[[UIAlertView alloc]initWithTitle:@"Sans catégorie!" message:@"S'il vous plaît sélectionnez une catégorie" delegate:nil cancelButtonTitle:@"bien" otherButtonTitles: nil];
        [categoryAlert show];
    }
    else if (completedTaskArray.count==0)
    {
        UIAlertView *taskAlert=[[UIAlertView alloc]initWithTitle:@"Tâche pas fait"  message:@"S'il vous plaît effectuer des tâches appropriées" delegate:nil cancelButtonTitle:@"bien" otherButtonTitles: nil];
        [taskAlert show];
    }
    else
    {
        dispatch_group_t databaseGroup=dispatch_group_create();
        dispatch_queue_t mainQ=dispatch_get_main_queue();
        
        dispatch_group_async(databaseGroup,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, (unsigned long)NULL), ^{
            dbCtrl.items_csv=_items_CSV;
            dbCtrl.photo_csv=_photos_CSV;
            dbCtrl.video_csv=_videos_CSV;
            dbCtrl.total_volume=_totalVolume;
            dbCtrl.tasks_csv=[self getTasksCSV];
            NSDateFormatter *myFormatter=[[NSDateFormatter alloc]init];
            [myFormatter setDateFormat:@"YYYY-MM-DD HH:MM:SS"];
            dbCtrl.order_create_date=[myFormatter stringFromDate:[NSDate date]];
             if (_order_id==0) {
                [dbCtrl insertIntoOrdersTableWithCustomerId:[_customer_Id intValue]];
                [dbCtrl closeConnection];
                _order_id=[dbCtrl.order_Id intValue];
            }
            else
            {
                [dbCtrl updateOrderTableWithOrderId:_order_id];
                [dbCtrl closeConnection];
            }
            
        });
        dispatch_group_notify(databaseGroup,mainQ, ^{
            [self.tabBarController setSelectedIndex:3];
            self.tabBarController.selectedViewController.tabBarItem.enabled=YES;
            UINavigationController *nextController=(UINavigationController *)self.tabBarController.selectedViewController;
            MDDValidationViewController *nextScreen=(MDDValidationViewController *)[nextController topViewController];
            nextScreen.customer_Id=_customer_Id;
        });
    }
    
    
}
-(NSString *)getTasksCSV
{
    NSMutableString *taskCSV=[NSMutableString stringWithFormat:@""];
    for (NSString  *completedTask in completedTaskArray) {
        [taskCSV appendFormat:@"%@;",completedTask];
    }
    return taskCSV;
}
@end
