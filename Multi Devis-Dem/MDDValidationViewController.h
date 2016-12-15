//
//  MDDValidationViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDValidationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *quotationTable;
@property (strong,nonatomic) NSNumber *customer_Id;
//-(void)uploadAllDetailsWithCustomerId :(int) customer_id;

- (IBAction)backBarButtonPress:(UIBarButtonItem *)sender;
@end
