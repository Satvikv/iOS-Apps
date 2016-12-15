//
//  MDDHomeCategoryViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 26/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDHomeCategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@end
