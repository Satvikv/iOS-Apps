//
//  MDDInventoryViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 14/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDDInventoryViewController;
@protocol InventoryViewControllerDelegate <NSObject>

-(void) getUpdatedInventory :(MDDInventoryViewController *)sender :(NSMutableDictionary *) invDic;

@end
@interface MDDInventoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inventoryTableView;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (strong,nonatomic) NSMutableDictionary *inventoryDictionary;
@property float itemVolume;
@property int articleCount;
@property (weak,nonatomic) id<InventoryViewControllerDelegate> delegate;
@property (strong,nonatomic)NSMutableString *photos_CSV;
@property (strong,nonatomic)NSMutableString *video_CSV;
@property int customer_id;
@end
