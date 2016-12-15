//
//  MDDAddItemsViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDInventoryViewController.h"
@class MDDAddItemsViewController;
@protocol  MDDAddItemsViewControllerDelegate<NSObject>

-(void) getDictionary :(id)sender :(NSDictionary *)inventory;
@end
@interface MDDAddItemsViewController : UIViewController<InventoryViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *room_items_CollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rooms_Sg;
@property (strong,nonatomic) NSArray *room_items_collectionArray;
@property (strong,nonatomic) NSDictionary *room_dictionary;
@property (strong,nonatomic)NSMutableDictionary *inventoryDictionary;
@property (weak,nonatomic) id<MDDAddItemsViewControllerDelegate> delegate;
@property (strong,nonatomic) NSArray *item_details_Array;
@property (strong,nonatomic) NSDictionary *item_details_Dictionay;
@property (strong,nonatomic)  NSMutableArray *addedRoomsArray;
@property (weak, nonatomic) IBOutlet UIButton *truckButton;

@property (weak, nonatomic) IBOutlet UITextField *volumeField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonPress:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
- (IBAction)previousButtonPress:(UIButton *)sender;
@property int customer_Id;
@property int order_id;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewWidthConstraint;

@end
