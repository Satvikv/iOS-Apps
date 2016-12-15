//
//  MDDAddItemsViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 05/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//


#import "MDDAddItemsViewController.h"
#import "PathFinder.h"
#import "CustomNavBar.h"
#import "MDDCategoryViewController.h"
#import "SQLiteDbController.h"
#define NavigationBarFrame self.navigationController.navigationBar.frame
@interface MDDAddItemsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlWidth;

@end
int *visitedArray;
int articleCount;
float itemVolume;
@implementation MDDAddItemsViewController
{
    NSMutableDictionary *colorDictionary;
    UIImageView *draggedImage;
    CGRect draggedFrame;
    NSString *selectedItemVolume;
    NSMutableArray *itemsArray;
    SQLiteDbController *databaseController;
    NSMutableString *photos_CSV;
    NSMutableString *video_CSV;
    NSMutableString *items_CSV;
    int draggedItemRow;
    float offsetXval;
    
}
@synthesize inventoryDictionary;
-(void) initialisingCollections
{
    
    itemsArray=[NSMutableArray array];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([inventoryDictionary allKeys].count==0) {
        UIImageView *truckToolTip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tooltip.png"]];
        CGRect toolTipFrame=truckToolTip.frame;
        toolTipFrame.origin=CGPointZero;
        toolTipFrame.size=CGSizeMake(90, 70);
        truckToolTip.frame=toolTipFrame;
        truckToolTip.center=CGPointMake(_truckButton.center.x,_truckButton.center.y-_truckButton.frame.size.height);
        UILabel *itemName=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 60)];
        itemName.textAlignment=NSTextAlignmentJustified;
        itemName.textColor=[UIColor whiteColor];
        itemName.font=[UIFont fontWithName:@"Avenir-Book" size:13];
        itemName.text=@"Glisséz l'icône dans le camion";
        itemName.numberOfLines=3;
        [truckToolTip addSubview:itemName];
        [self.view addSubview:truckToolTip];
        [UIView animateWithDuration:3.0f animations:^{
            truckToolTip.alpha=0;      //  [toolTipView removeFromSuperview];
        } completion:^(BOOL finished) {
            [truckToolTip removeFromSuperview];
        }];
        
    }
    
    NavigationBarFrame=CGRectMake(0,40,320,44);
    //Adding status Bar image
    UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, 320, 20)];
    statusBarImage.image=[UIImage imageNamed:@"status_bar"];
    [self.navigationController.navigationBar addSubview:statusBarImage];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_delegate getDictionary:self :inventoryDictionary];
    // [_room_items_CollectionView setContentOffset:CGPointZero];
}
-(void) dataToLoad
{
    NSArray *array=[inventoryDictionary allKeys];
    for (NSString *room in _addedRoomsArray) {
      unsigned int index=(unsigned int)[_addedRoomsArray indexOfObject:room];
        if ([array containsObject:room]) {
            visitedArray[index]=1;
            articleCount+=[[inventoryDictionary objectForKey:room] count];
        }
        else
            visitedArray[index]=0;
    }
    for (int index=0;index<[array count];index++){
        for (NSDictionary *itemDictionary in [inventoryDictionary objectForKey:array[index]]) {
            itemVolume+=[itemDictionary[@"Volume"] floatValue];
        }
    }
    if ([inventoryDictionary allKeys].count!=0) {
        [_truckButton setImage:[UIImage imageNamed:@"truck_loaded.png"] forState:UIControlStateNormal];
    }
    _volumeField.text=[NSString stringWithFormat:@"%0.1f",itemVolume];
    
}
-(void)getUpdatedInventory:(MDDInventoryViewController *)sender :(NSMutableDictionary *)invDic
{
    for (NSString *room in _addedRoomsArray) {
        NSArray *array=[invDic allKeys];
        if (![array containsObject:room]) {
          unsigned  int index=(unsigned int)[_addedRoomsArray indexOfObject:room];
            visitedArray[index]=0;
        }
    }
    itemVolume=sender.itemVolume;
    articleCount=sender.articleCount;
    _volumeField.text=[NSString stringWithFormat:@"%0.1f",sender.itemVolume];
    inventoryDictionary=invDic;
    if ([invDic allKeys].count==0) {
        [_truckButton setImage:[UIImage imageNamed:@"truck_empty.png"] forState:UIControlStateNormal];
    }
}
-(void) setUp
{
    // creating a dictionary for colors
    dispatch_group_t taskgroup=dispatch_group_create();
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_group_async(taskgroup, mainQueue, ^{
        colorDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:[ UIColor colorWithRed:255.0/255.0 green:162.0/255.0 blue: 0/255.0 alpha:1.0],@"YELLOW",[UIColor colorWithRed:235/255.0 green:64/255.0 blue: 7/255.0 alpha:1.0]
                         ,@"RED",[UIColor colorWithRed:7.0/255.0 green:189/255.0 blue:245/255.0 alpha:1.0],@"BLUE",[UIColor colorWithRed:118/255.0 green:50/255.0 blue: 161/255.0 alpha:1.0],@"VIOLET",[UIColor colorWithRed:235/255.0 green:113/255.0 blue: 7/255.0 alpha:1.0],@"ORANGE",[UIColor colorWithRed:222.0/255.0 green:0/255.0 blue:170/255.0 alpha:1.0],@"PINK",[UIColor colorWithRed:133/255.0 green:132/255.0 blue: 131/255.0 alpha:1.0]
                         ,@"BLACK",[UIColor colorWithRed:67/255.0 green:176/255.0 blue: 37/255.0 alpha:1.0],@"GREEN", nil];
        
        // loading the plist data into an array
        NSString *plistPath=[PathFinder getItemsPlistDirectoryPath];
        _room_items_collectionArray=[NSArray arrayWithContentsOfFile:plistPath];
        
        
    });
    // Rooms segment set up by inserting using the added rooms array
    
    dispatch_group_async(taskgroup, mainQueue, ^{
        [_rooms_Sg removeAllSegments];
        [_rooms_Sg setTitleTextAttributes:
         @{
           NSForegroundColorAttributeName : [UIColor whiteColor],
           NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]
           }
                                 forState:UIControlStateNormal];
        for (int room=0; room<_addedRoomsArray.count; room++) {
            
            [_rooms_Sg insertSegmentWithTitle:_addedRoomsArray[room] atIndex:room animated:NO];
            [_rooms_Sg setWidth:160 forSegmentAtIndex:room];
            NSString *color=[self getRoomDictionaryForEachRoom:room][@"Color"];
            UIColor *backColor=[colorDictionary objectForKey:color];
            [[_rooms_Sg.subviews objectAtIndex:room] setBackgroundColor:backColor];
        }
        
        [_rooms_Sg sizeToFit];
        [_rooms_Sg setSelectedSegmentIndex:0];
        //  _rooms_Sg.frame=CGRectMake(0, 0, 160*_rooms_Sg.numberOfSegments, 28);
        visitedArray=(int *)malloc(4*_rooms_Sg.numberOfSegments);
        visitedArray[0]=0;
        _segmentViewWidthConstraint.constant=160*_rooms_Sg.numberOfSegments;
        _segmentedControlWidth.constant=_segmentViewWidthConstraint.constant;
    });
    //adding the pan gesture recogniser to the view.
    dispatch_group_async(taskgroup, mainQueue, ^{
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragImage:)]];
        
    });
    dispatch_group_async(taskgroup, mainQueue, ^{
        [self initialisingCollections];
        
    });
    dispatch_group_async(taskgroup, mainQueue, ^{
        [self dataToLoad];
        
    });
    dispatch_group_notify(taskgroup, mainQueue, ^{
        [_room_items_CollectionView reloadData];
    });
    
    //inistialising variables
    articleCount=0;
    itemVolume=0.0f;
    
    
}

- (IBAction)truckButtonPress:(UIButton *)sender {
    
}
#pragma mark- Rooms Segment action
- (IBAction)roomsSegmentPress:(UISegmentedControl *)sender {
    
    //Reloading the data for every selection of the segment
    [_room_items_CollectionView reloadData];
    offsetXval=0;
    [_room_items_CollectionView setContentOffset:CGPointZero];
}


//Getting the item details
-(NSMutableDictionary *) getItemDetailsForEachItem :(NSInteger )item
{
    
    _item_details_Array=[self getRoomDictionaryForEachRoom:_rooms_Sg.selectedSegmentIndex][@"Room_items"];
    NSMutableDictionary *itemsDictionary=[NSMutableDictionary dictionaryWithDictionary:_item_details_Array[item]];
    return itemsDictionary;
}




- (void)dragImage:(UIPanGestureRecognizer *)sender
{
    if([sender isKindOfClass:[UIPanGestureRecognizer class]])
    {
        //Getting the index path for the item
        NSIndexPath *indexPath=[_room_items_CollectionView indexPathForItemAtPoint:[sender locationInView:_room_items_CollectionView]];
        UICollectionViewCell *cell=[_room_items_CollectionView cellForItemAtIndexPath:indexPath];
        NSMutableDictionary *draggedItemDic;
        
        
        // Copying the item's image into an image view and showing that view  all the way during draggging.
        if(draggedImage==nil)
        {
            draggedItemRow=(unsigned int)indexPath.item;
            
            UIImageView *cellImage=(UIImageView *)[cell viewWithTag:1];
            draggedImage=[[UIImageView alloc]initWithImage:cellImage.image];
            draggedImage.frame=cellImage.frame;
            draggedImage.alpha=0.5;
            CGPoint point=[cell convertPoint:cellImage.center toView:self.view];
            draggedImage.center=point;
            draggedFrame=draggedImage.frame;
            [self.view addSubview:draggedImage];
        }
        
        //When the dragging starts changing the frame of the dragged image for every move.
        if(sender.state==UIGestureRecognizerStateBegan || sender.state==UIGestureRecognizerStateChanged)
        {
            
            CGPoint nextPoint=[sender translationInView:self.view];
            CGPoint currentPoint=draggedImage.center;
            
            currentPoint.x += nextPoint.x;
            currentPoint.y += nextPoint.y;
            
            draggedImage.center=currentPoint;
            [sender setTranslation:CGPointZero inView:self.view];
        }
        
        
        // After the image rached the target or the cart , making it disappeared and if not reached animating the view to reach its original point.
        if(sender.state==UIGestureRecognizerStateEnded)
        {
            
            if(CGRectContainsPoint(_truckButton.frame, draggedImage.center)==YES)
            {
                articleCount++;
                if (visitedArray[_rooms_Sg.selectedSegmentIndex]==0) {
                    itemsArray =[NSMutableArray array];
                }
                else{
                    itemsArray=[inventoryDictionary objectForKey:_addedRoomsArray[_rooms_Sg.selectedSegmentIndex]];
                }
                draggedItemDic=[self getItemDetailsForEachItem:draggedItemRow];
                [draggedItemDic setObject:[NSHomeDirectory() stringByAppendingPathComponent:@"camera.png"] forKey:@"Camera"];
                [itemsArray addObject:draggedItemDic];
                visitedArray[_rooms_Sg.selectedSegmentIndex]=1;
                [inventoryDictionary setObject:itemsArray forKey:_addedRoomsArray[_rooms_Sg.selectedSegmentIndex]];
                [_truckButton setImage:[UIImage imageNamed:@"truck_loaded.png"] forState:UIControlStateNormal];
                draggedImage.frame=draggedFrame;
                [sender setTranslation:CGPointZero inView:self.view];
                [draggedImage removeFromSuperview];
                draggedImage=nil;
                itemVolume+=[draggedItemDic[@"Volume"] floatValue];
                _volumeField.text=[NSString stringWithFormat:@"%0.1f",itemVolume];
            }
            else
            {
                //[itemsArray removeObject:draggedItemDic];
                [UIView animateWithDuration:0.5f animations:^{
                    draggedImage.frame=draggedFrame;
                    self.view.userInteractionEnabled=NO;
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled=YES;
                    [sender setTranslation:CGPointZero inView:self.view];
                    [draggedImage removeFromSuperview];
                    draggedImage=nil;
                    
                }];
            }
        }
    }
    
}
- (IBAction)nextButtonPress:(UIButton *)sender {
    offsetXval+=320;
    //int contentOfSetYvalue=_room_items_CollectionView.contentOffset.y;
    if (offsetXval <=_room_items_CollectionView.contentSize.width) {
        [_room_items_CollectionView setContentOffset:CGPointMake(offsetXval, 0) animated:YES];
        _previousButton.enabled=YES;
        if (offsetXval+320 >_room_items_CollectionView.contentSize.width) {
            sender.enabled=NO;
        }
    }
    
    
}
- (IBAction)previousButtonPress:(UIButton *)sender {
    
    offsetXval-=320;
    if (offsetXval>=0) {
        [_room_items_CollectionView setContentOffset:CGPointMake(offsetXval, 0) animated:YES];
        _nextButton.enabled=YES;
        if (offsetXval-320<0) {
            sender.enabled=NO;
        }
    }
}
#pragma mark- collection view data source
// Getting the room details from the collection array.

-(NSDictionary *) getRoomDictionaryForEachRoom : (int) room{
    
    for (NSDictionary *roomDic in _room_items_collectionArray) {
        if ([[roomDic objectForKey:@"Room_name"] caseInsensitiveCompare:_addedRoomsArray[room]]==NSOrderedSame) {
            _room_dictionary=roomDic;
            break;
        }
    }
    return _room_dictionary;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *itemCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell"forIndexPath:indexPath];
    UIImageView *itemIcon=(UIImageView *)[itemCell viewWithTag:1];
    
    UILabel *itemName=(UILabel *)[itemCell viewWithTag:2];
    itemName.text=[self getItemDetailsForEachItem:indexPath.item][@"Name"];
    itemIcon.image=[UIImage imageNamed:[[self getItemDetailsForEachItem:indexPath.item] objectForKey:@"Icon"]];
    
    if(collectionView.contentOffset.x==0)
    {
        if (collectionView.contentSize.width<self.view.frame.size.width) {
            _previousButton.enabled=NO;
            _nextButton.enabled=NO;
        }
        else{
            _previousButton.enabled=NO;
            _nextButton.enabled=YES;
        }
        
    }
    
    return itemCell;
}

//Data source protocol method for the number of cells to be loaded in the collection view.
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _item_details_Array=[self getRoomDictionaryForEachRoom:_rooms_Sg.selectedSegmentIndex][@"Room_items"];
    return _item_details_Array.count;
}
#pragma mark- collection view delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *selectedCell=[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *toolTipView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tooltip.png"]];
    CGPoint point=[collectionView convertPoint:CGPointMake(selectedCell.center.x, selectedCell.center.y) toView:self.view];
    toolTipView.frame=CGRectMake(point.x-(selectedCell.frame.size.width), point.y-(selectedCell.frame.size.height), 120, 60);
    UILabel *itemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 60)];
    itemName.textAlignment=NSTextAlignmentCenter;
    itemName.textColor=[UIColor whiteColor];
    itemName.font=[UIFont fontWithName:@"Avenir-Book" size:13];
    itemName.text=[self getItemDetailsForEachItem:indexPath.item][@"Name"];
    [toolTipView addSubview:itemName];
    [self.view addSubview:toolTipView];
    [UIView animateWithDuration:2.0f animations:^{
        toolTipView.alpha=0;      //  [toolTipView removeFromSuperview];
    } completion:^(BOOL finished) {
        [toolTipView removeFromSuperview];
    }];
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([inventoryDictionary allKeys].count==0) {
        UIAlertView *noItemsAlert=[[UIAlertView alloc]initWithTitle:@"Pas d'articles!" message:@"S'il vous plaît ajouter des articles dans le panier" delegate:nil cancelButtonTitle:@"Bein" otherButtonTitles: nil];
        [noItemsAlert show];
        return NO;
    }
    return YES;
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Suivant"]) {
        MDDInventoryViewController *inventoryController=[segue destinationViewController];
        inventoryController.delegate=self;
        inventoryController.inventoryDictionary=inventoryDictionary;
        inventoryController.itemVolume=itemVolume;
        inventoryController.articleCount=articleCount;
        inventoryController.customer_id=_customer_Id;
    }
}
# pragma mark - Save all details
- (IBAction)suivantPress:(id)sender {
    
    if ([inventoryDictionary allKeys].count==0) {
        UIAlertView *noItemsAlert=[[UIAlertView alloc]initWithTitle:@"Pas d'articles!" message:@"S'il vous plaît ajouter des articles dans le panier" delegate:nil cancelButtonTitle:@"bien" otherButtonTitles: nil];
        [noItemsAlert show];
    }
    else{
        [self.tabBarController setSelectedIndex:2];
        self.tabBarController.selectedViewController.tabBarItem.enabled=YES;
        UINavigationController *nextController=(UINavigationController *)self.tabBarController.selectedViewController;
        
        MDDCategoryViewController *categoryController= (MDDCategoryViewController *)[nextController viewControllers][0];
        categoryController.customer_Id=[NSNumber numberWithInt:_customer_Id];
        [self getStringsFromDictionary];
        categoryController.items_CSV=items_CSV;
        categoryController.photos_CSV=photos_CSV;
        categoryController.totalVolume=itemVolume;
        categoryController.videos_CSV=video_CSV;
    }
}
-(void) getStringsFromDictionary
{
    items_CSV=[NSMutableString stringWithString:@""];
    photos_CSV=[NSMutableString stringWithString:@""];
    video_CSV=[NSMutableString stringWithString:@""];
    for (NSString *roomName in inventoryDictionary) {
        NSString *newRoomName=[roomName stringByReplacingOccurrencesOfString:@"/" withString:@"&"];
        [items_CSV appendFormat:@"%@=",newRoomName];
        [photos_CSV appendFormat:@"%@=",newRoomName];
        [video_CSV appendFormat:@"%@=",newRoomName];
        for (NSDictionary *itemDic in [inventoryDictionary objectForKey:roomName]) {
            NSString *newItemName=[itemDic[@"Name"] stringByReplacingOccurrencesOfString:@"/" withString:@"&"];
            [items_CSV appendFormat:@"%@->%@,",newItemName,itemDic[@"Volume"]];
            
            if ([itemDic[@"Camera"] hasSuffix:@"camera.png"]==YES) {
                [photos_CSV appendFormat:@"%@->EMPTY,",newItemName];
                [video_CSV appendFormat:@"%@->EMPTY,",itemDic[@"Name"]];
            }
            else if(itemDic[@"Video"]==nil){
                [photos_CSV appendFormat:@"%@->%@,",newItemName,[itemDic[@"Camera"] lastPathComponent]];
                [video_CSV appendFormat:@"%@->EMPTY,",newItemName];
            }
            
            else
            {
                [video_CSV appendFormat:@"%@->%@,",newItemName,[itemDic[@"Video"] lastPathComponent]];
                [photos_CSV appendFormat:@"%@->EMPTY,",newItemName];
            }
            
            
        }
        [items_CSV appendString:@";"];
        [photos_CSV appendString:@";"];
        [video_CSV appendString:@";"];
    }
    
}
@end
