//
//  MDDAddRoomsViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDAddItemsViewController.h"
@interface MDDAddRoomsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MDDAddItemsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *rooms_table;
@property (strong,nonatomic) NSMutableArray *roomsArray;
- (IBAction)submit_Rooms_Action:(UIButton *)sender;
- (IBAction)backPress:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NSNumber *customer_Id;
@end
