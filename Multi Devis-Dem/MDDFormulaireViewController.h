//
//  MDDFormulaireViewController.h
//  Multi Devis-Dem
//
//  Created by imobigeeks on 04/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDFormulaireViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) NSNumber *customer_Id;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *civilitesSg;
@property (weak, nonatomic) IBOutlet UITextField *name_Field;
@property (weak, nonatomic) IBOutlet UITextField *address_Field;
@property (weak, nonatomic) IBOutlet UITextField *postalCode_Field;
@property (weak, nonatomic) IBOutlet UITextField *city_Field;
@property (weak, nonatomic) IBOutlet UITextField *phone_Field;
@property (weak, nonatomic) IBOutlet UITextField *email_Field;
- (IBAction)copy_address_Switch:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UITextField *start_address_Field;
@property (weak, nonatomic) IBOutlet UITextField *start_Cp_Field;
@property (weak, nonatomic) IBOutlet UITextField *start_city_Field;
@property (weak, nonatomic) IBOutlet UISegmentedControl *access_Sg;
@property (weak, nonatomic) IBOutlet UITextField *floors_Field;
@property (weak, nonatomic) IBOutlet UISegmentedControl *move_furniture_Sg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lift_Sg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *persons_count_Sg;




@property (weak, nonatomic) IBOutlet UITextField *destination_address_Field;
@property (weak, nonatomic) IBOutlet UITextField *destination_cp_Field;
@property (weak, nonatomic) IBOutlet UITextField *destination_city_Field;
@property (weak, nonatomic) IBOutlet UITextView *comment_TextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *destination_access_Sg;
@property (weak, nonatomic) IBOutlet UITextField *destination_floor_Field;
@property (weak, nonatomic) IBOutlet UISegmentedControl *destination_furniture_Sg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *destination_lift_Sg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *destination_persons_Sg;




@property (weak, nonatomic) IBOutlet UISwitch *has_exact_date_Switch;
@property (weak, nonatomic) IBOutlet UITextField *moving_date_Field;
- (IBAction)resetAllFieldsButton:(UIButton *)sender;
- (IBAction)save_and_continue_Button:(UIButton *)sender;
- (IBAction)choose_date_action:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *shifting_date_picker;
@property (weak, nonatomic) IBOutlet UIPickerView *fortNight_picker;
- (IBAction)get_Moving_date:(UIDatePicker *)sender;

@property (weak, nonatomic) IBOutlet UIView *allPickers_view;
- (IBAction)liftSegmentAction:(UISegmentedControl *)sender;
- (IBAction)destinationliftSegmentAction:(UISegmentedControl *)sender;

@end
