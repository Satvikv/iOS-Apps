//
//  MDDCategoryViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listOfTasksTable;
- (IBAction)packagePress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *ecobutton;
@property (weak, nonatomic) IBOutlet UIButton *stdButton;
@property (weak, nonatomic) IBOutlet UIButton *comButton;
@property (strong) NSNumber *customer_Id;
@property int order_id;
@property (strong,nonatomic) NSString *items_CSV;
@property (strong,nonatomic) NSString *photos_CSV;
@property (strong,nonatomic) NSString *tasks_CSV;
@property (strong,nonatomic) NSString *videos_CSV;
@property float totalVolume;
@end
