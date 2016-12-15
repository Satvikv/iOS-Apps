//
//  MDDInventoryViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 14/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import "MDDInventoryViewController.h"
#import "PathFinder.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#define NavigationBarFrame self.navigationController.navigationBar.frame
@interface MDDInventoryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFileManagerDelegate,UIAlertViewDelegate>

@end

@implementation MDDInventoryViewController
{
    NSIndexPath *indexPath_for_camera;
    NSArray *photosCSVArray;
    NSFileManager *imageDirectoryManager;
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
    
    self.inventoryTableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background.png"]];
    self.volumeLabel.text=[NSString stringWithFormat:@"Articles (%i), Volume (%0.2f)m3",_articleCount,_itemVolume];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonAction:)];
    self.navigationItem.leftBarButtonItem =backButton;
    imageDirectoryManager=[NSFileManager defaultManager];
    imageDirectoryManager.delegate=self;
    NSString *cameraImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"camera.png"];
    if(![imageDirectoryManager fileExistsAtPath:cameraImagePath])
    {
        NSData *cameraImageData=UIImagePNGRepresentation([UIImage imageNamed:@"camera.png"]);
        [cameraImageData writeToFile:cameraImagePath atomically:YES];
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Returns the number of sections.
    return [_inventoryDictionary allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[_inventoryDictionary objectForKey:[_inventoryDictionary allKeys][section]] count];
}
-(NSMutableDictionary *)getItemDetailDictionaryInIndexPath:(NSIndexPath *)indexPath
{
    return [[_inventoryDictionary objectForKey:[_inventoryDictionary allKeys][indexPath.section]] objectAtIndex:indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *itemDetails=[self getItemDetailDictionaryInIndexPath:indexPath];
    NSString *titleString=[itemDetails objectForKey:@"Name"];
    NSString *detailsString=[itemDetails objectForKey:@"Volume"];
    cell.textLabel.text=titleString;
    cell.detailTextLabel.text=detailsString;
    dispatch_queue_t myQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, (unsigned long)NULL);
    dispatch_async(myQueue, ^{
        
        UIImage *itemIcon=[UIImage imageNamed:[itemDetails objectForKey:@"Icon"]];
        
        UIImage *cameraImage=[UIImage imageWithContentsOfFile:[itemDetails objectForKey:@"Camera"]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.imageView.image=itemIcon;
            UIButton *cameraButton=(UIButton *)[cell viewWithTag:1];
            [cameraButton setImage:cameraImage forState:UIControlStateNormal];
            
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cameraButton
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:244.0]];
            
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cameraButton
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:30.0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cameraButton
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-6.0]];
            [cell setNeedsLayout];
        });
    });
    
    if (indexPath.row %2==0)
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:203.0/255.0 blue:91.0/255.0 alpha:1];
    else
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:187.0/255.0 alpha:1];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320,tableView.sectionHeaderHeight)];
    [sectionView setBackgroundColor:[UIColor grayColor]];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, sectionView.frame.size.height)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    titleLabel.text=[_inventoryDictionary allKeys][section];
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(300, 5, 15, 15)];
    closeButton.tag=section+100;
    [closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(deleteRoom:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:titleLabel];
    [sectionView addSubview:closeButton];
    return sectionView;
}


#pragma mark - table view delegate
// Override to support conditional editing of the table view.
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"supprimer";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(BOOL)fileManager:(NSFileManager *)fileManager shouldRemoveItemAtPath:(NSString *)path
{
    if ([path isEqualToString:[NSHomeDirectory() stringByAppendingPathComponent:@"camera.png"]]) {
        return NO;
    }
    return YES;
}
-(void) deleteImageFileForItem :(NSMutableDictionary *)itemDictionary
{
    NSString *imagePath=[itemDictionary objectForKey:@"Camera"];
    if (itemDictionary[@"Video"]!=nil) {
        [imageDirectoryManager removeItemAtPath:itemDictionary[@"Video"] error:nil];
    }
    [imageDirectoryManager removeItemAtPath:imagePath error:nil];
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *deletedDic=[self getItemDetailDictionaryInIndexPath:indexPath];
        _itemVolume-=[deletedDic[@"Volume"] floatValue];
        _articleCount--;
        _volumeLabel.text=[NSString stringWithFormat:@"Articles (%i), Volume (%0.2f)m3",_articleCount,_itemVolume];
        [self deleteImageFileForItem:deletedDic];
        [[_inventoryDictionary objectForKey:[_inventoryDictionary allKeys][indexPath.section]] removeObjectAtIndex:indexPath.row];
        if ([[_inventoryDictionary objectForKey:[_inventoryDictionary allKeys][indexPath.section]] count]==0) {
            [_inventoryDictionary removeObjectForKey:[_inventoryDictionary allKeys][indexPath.section]];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [_inventoryTableView reloadData];
        }
        // Delete the row from the data source
        
        else
        {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

-(void) deleteRoom:(UIButton *)sender
{
    NSInteger deletableSection=sender.tag-100;
    NSArray *deletedSectionArray=[_inventoryDictionary objectForKey:[_inventoryDictionary allKeys][deletableSection]];
       for (NSDictionary *itemDic in deletedSectionArray) {
        _itemVolume-=[itemDic[@"Volume"] floatValue];
        _articleCount--;
        [self deleteImageFileForItem:(NSMutableDictionary *)itemDic];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_inventoryDictionary removeObjectForKey:[_inventoryDictionary allKeys][deletableSection]];
        _volumeLabel.text=[NSString stringWithFormat:@"Articles (%i), Volume (%0.2f)m3",_articleCount,_itemVolume];
        [_inventoryTableView deleteSections:[NSIndexSet indexSetWithIndex:deletableSection] withRowAnimation:UITableViewRowAnimationFade];
        [_inventoryTableView reloadData];
    });
}

- (IBAction)cameraAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSSet *touchesSet=[event allTouches];
    UITouch *buttonTouch=[touchesSet anyObject];
    indexPath_for_camera=[_inventoryTableView indexPathForRowAtPoint:[buttonTouch locationInView:_inventoryTableView]];
    UIActionSheet *cameraActionOptions=[[UIActionSheet alloc]initWithTitle:@"Well!" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:@"Prendre une photo / vidéo" otherButtonTitles:@"Choisir parmi les photos/vidéos", nil];
    [cameraActionOptions showFromTabBar:self.tabBarController.tabBar];
    
}
#pragma mark - navigation bar button actions
-(void) backButtonAction : (id)sender
{
    [self.delegate getUpdatedInventory:self :_inventoryDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteAllRoomsAction:(id)sender {
    
    if ([_inventoryDictionary allKeys].count!=0) {
        UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"Etes-vous sûr?" message:@"voulez-vous enlever toute panier?" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Oui", nil];
        [deleteAlert show];
    }
    
}
#pragma mark- alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"]) {
        [_inventoryDictionary removeAllObjects];
        _articleCount=0;_itemVolume=0.0f;
        _volumeLabel.text=[NSString stringWithFormat:@"Articles (%i), Volume (%0.2f)m3",_articleCount,_itemVolume];
        [_inventoryTableView reloadData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (unsigned long)NULL), ^{
            @autoreleasepool {
                BOOL isDir;
                NSString *imagesDirectoryPath=[NSHomeDirectory() stringByAppendingFormat:@"/%i",_customer_id];
                if ([imageDirectoryManager fileExistsAtPath:imagesDirectoryPath isDirectory:&isDir]) {
                    [imageDirectoryManager removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/%i",_customer_id] error:nil];
                }
                
            }
        });
    }
}
#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        
        UIImagePickerController *galleryPicker=[[UIImagePickerController alloc]init];
        galleryPicker.delegate=self;
        galleryPicker.allowsEditing = YES;
        [galleryPicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [galleryPicker setMediaTypes:@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie]];
        if (buttonIndex==actionSheet.destructiveButtonIndex) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [galleryPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:galleryPicker animated:YES completion:nil];
                
            }
            else
            {
                UIAlertView *noCamAlert=[[UIAlertView alloc]initWithTitle:@"désolé!" message:@"Aucun appareil photo de votre iPhone" delegate:self cancelButtonTitle:@"Bien!" otherButtonTitles:nil];
                [noCamAlert show];
            }
            
        }
        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choisir parmi les photos/vidéos"]) {
            [self presentViewController:galleryPicker animated:YES completion:nil];
        }
    }
}
-(void)saveImageToFile :(UIImage *)capturedImage withName:(NSString *)fileName
{
    BOOL isDir;
    NSString *imageFilePath=[NSHomeDirectory() stringByAppendingFormat:@"/%i",_customer_id];
    NSData *imageData=UIImagePNGRepresentation(capturedImage);
    
    [imageDirectoryManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if ([imageDirectoryManager fileExistsAtPath:imageFilePath isDirectory:&isDir]==YES && isDir) {
        [imageData writeToFile:[imageFilePath stringByAppendingFormat:@"/%@",fileName] atomically:YES];
    }
    
}


#pragma mark - image picker controller delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hhmmss"];
    __block UIImage *imageFromGallery;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *mediaType=info[UIImagePickerControllerMediaType];
        if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)==NSOrderedSame) {
            NSMutableDictionary *itemDetails=[self getItemDetailDictionaryInIndexPath:indexPath_for_camera];
            NSURL *videoURL=[NSURL fileURLWithPath:info[UIImagePickerControllerMediaURL]];
            AVURLAsset *urlAsset=[[AVURLAsset alloc]initWithURL:videoURL options:Nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
            CGImageRef thumbnail_Image=[generate copyCGImageAtTime:CMTimeMake(1, 20) actualTime:NULL error:nil];
            NSString *thumbNailName=[NSString stringWithFormat:@"thumb_%@.png",[NSDate date]];
            imageFromGallery=[UIImage imageWithCGImage:thumbnail_Image];
            if (itemDetails[@"Video"]!=nil) {
                [imageDirectoryManager removeItemAtPath:itemDetails[@"Video"] error:nil];
            }
            [imageDirectoryManager removeItemAtPath:itemDetails[@"Camera"] error:nil];
            [self saveImageToFile:imageFromGallery withName:thumbNailName];
            dispatch_queue_t temporaryQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (unsigned long)NULL);
            NSString *videoName=[NSString stringWithFormat:@"video_%@.mov",[formatter stringFromDate:[NSDate date]]];
            NSData *videoData=[NSData dataWithContentsOfURL:videoURL];
            dispatch_async(temporaryQueue, ^{
                
                [imageDirectoryManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/%i",_customer_id] withIntermediateDirectories:YES attributes:nil error:nil];
                [videoData writeToFile:[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",_customer_id,videoName] atomically:YES];
            });
            
            [itemDetails setObject:[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",_customer_id,thumbNailName] forKey:@"Camera"];
            [itemDetails setObject:[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",_customer_id,videoName] forKey:@"Video"];
        }
        else
        {
            NSMutableDictionary *itemDetails=[self getItemDetailDictionaryInIndexPath:indexPath_for_camera];
            // NSString *room_name=[_inventoryDictionary allKeys][indexPath_for_camera.section];
            // room_name=[room_name stringByReplacingOccurrencesOfString:@"/" withString:@"&"];
            // NSString *item_name=[itemDetails objectForKey:@"Name"];
            //item_name=[item_name stringByReplacingOccurrencesOfString:@"/" withString:@"&"];
            NSString *imageName=[NSString stringWithFormat:@"img_%@.png",[formatter stringFromDate:[NSDate date]]];
            imageFromGallery=info[UIImagePickerControllerOriginalImage];
            if (itemDetails[@"Video"]!=nil) {
                [imageDirectoryManager removeItemAtPath:itemDetails[@"Video"] error:nil];
            }
            [imageDirectoryManager removeItemAtPath:itemDetails[@"Camera"] error:nil];
            [self saveImageToFile:imageFromGallery withName:imageName];
            [itemDetails setObject:[NSHomeDirectory() stringByAppendingFormat:@"/%i/%@",_customer_id,imageName] forKey:@"Camera"];
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [_inventoryTableView reloadRowsAtIndexPaths:@[indexPath_for_camera] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    });
}
@end
