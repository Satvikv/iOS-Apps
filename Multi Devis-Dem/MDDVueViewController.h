//
//  MDDVueViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 07/03/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDVueViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *quotationsTableView;
@property (strong,nonatomic) NSMutableDictionary *quotationDictionary;
@end
