//
//  MDDFormulaireViewController.m
//  Multi Devis-Dem
//
//  Created by imobigeeks on 04/02/14.
//  Copyright (c) 2014 imobigeeks. All rights reserved.
//
#define NavigationBarFrame self.navigationController.navigationBar.frame

#import "MDDFormulaireViewController.h"
#import "MDDCustomTabBarController.h"
#import "MDDAddRoomsViewController.h"
#import "CustomNavBar.h"
#import "SQLiteDbController.h"
#import "PathFinder.h"

@interface MDDFormulaireViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
@end

@implementation MDDFormulaireViewController
{
    
    NSString *selectedMoveDate;
    NSArray *fortNightsArray;
    NSArray *monthsArray;
    NSMutableArray *yearsArray;
    NSDictionary *pickerDictionary;
    SQLiteDbController *dbController;
    UIView *activeField;
    NSDateFormatter *formatter;
    CGFloat height;
    CGRect initialPickerFrame;
    NSTimer *progressTimer;
    UIProgressView *appProgressBar;
    UIView *progressView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    NavigationBarFrame=CGRectMake(0,40,NavigationBarFrame.size.width, NavigationBarFrame.size.height);
    //Adding status Bar image
    UIImageView *statusBarImage= [[UIImageView alloc]initWithFrame:CGRectMake(0,-20, NavigationBarFrame.size.width, 20)];
    statusBarImage.image=[UIImage imageNamed:@"status_bar"];
    [self.navigationController.navigationBar addSubview:statusBarImage];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:100.0/255.0 alpha:1]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    initialPickerFrame=_allPickers_view.frame;
    fortNightsArray=[NSArray arrayWithObjects:@"1st quinzaine",@"2nd quinzaine", nil];
    monthsArray=[NSArray arrayWithObjects:@"janvier",@"février",@"mars",@"avril",@"mai",@"juin",@"juillet",@"août",@"septembre",@"octobre",@"novembre",@"décembre",nil];
    int yearCount = 0;
    
    NSDateComponents *yearComponent=[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date] ];
    int presentYear=(int)[yearComponent year];
    yearsArray=[NSMutableArray array];
    while (yearCount<20) {
        
        [yearsArray addObject:[NSString stringWithFormat:@"%i",presentYear+yearCount]];
        yearCount++;
    }
    pickerDictionary=[NSDictionary dictionaryWithObjectsAndKeys:fortNightsArray,[NSNumber numberWithInt:0],monthsArray,[NSNumber numberWithInt:1],yearsArray,[NSNumber numberWithInt:2], nil];
    [self registerForKeyboardNotifications];
    selectedMoveDate=@"";
    dbController =[[SQLiteDbController alloc]init];
    formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"fr_FR"]];
    [formatter setDateStyle:NSDateFormatterLongStyle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetAllFieldsButton:(UIButton *)sender
{
    CGRect viewFrame=self.view.frame;
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view];
    self.view.frame=viewFrame;
}


- (IBAction)copy_address_Switch:(UISwitch *)sender {
    if (sender.isOn) {
        self.start_address_Field.text=self.address_Field.text;
        self.start_Cp_Field.text=self.postalCode_Field.text;
        self.start_city_Field.text=self.city_Field.text;
    }
    else
    {
        self.start_address_Field.text=@"";
        self.start_Cp_Field.text=@"";
        self.start_city_Field.text=@"";
    }
}
- (IBAction)liftSegmentAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        _persons_count_Sg.enabled=NO;
        _persons_count_Sg.selectedSegmentIndex=-1;
    }
    else
    {
        _persons_count_Sg.enabled=YES;
        _persons_count_Sg.selectedSegmentIndex=0;
    }
}

- (IBAction)destinationliftSegmentAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        _destination_persons_Sg.enabled=NO;
        [_destination_persons_Sg setSelectedSegmentIndex:-1];
    }
    else
    {
        _destination_persons_Sg.enabled=YES;
        _destination_persons_Sg.selectedSegmentIndex=0;
    }
    
}
-(IBAction)save_and_continue_Button:(UIButton *)sender
{
    // Checking whether any field is null or not.
    if ([_name_Field.text isEqualToString:@""] || _civilitesSg.selectedSegmentIndex<0 || [_address_Field.text isEqualToString:@""] || [_postalCode_Field.text isEqualToString:@""] || [_city_Field.text isEqualToString:@""] || [_phone_Field.text isEqualToString:@""] || [_email_Field.text isEqualToString:@""] || [_start_address_Field.text isEqualToString:@""] || [_start_city_Field.text isEqualToString:@""] || [_start_Cp_Field.text isEqualToString:@""] || _access_Sg.selectedSegmentIndex<0 || [_floors_Field.text isEqualToString:@""] || _move_furniture_Sg.selectedSegmentIndex<0 || _lift_Sg.selectedSegmentIndex<0 || [_destination_address_Field.text isEqualToString:@""] || [_destination_city_Field.text isEqualToString:@""] || [_destination_cp_Field.text isEqualToString:@""] || [_destination_floor_Field.text isEqualToString:@""] || _destination_furniture_Sg.selectedSegmentIndex<0 || _destination_lift_Sg.selectedSegmentIndex<0|| [_moving_date_Field.text isEqualToString:@""] || _destination_access_Sg.selectedSegmentIndex<0) {
        UIAlertView *mandatoryAlert=[[UIAlertView alloc]initWithTitle:@"Stop" message:@"tous les champs sont obligatoires" delegate:self cancelButtonTitle:@"Bien" otherButtonTitles: nil];
        [mandatoryAlert show];
    }
    else{
        
        progressTimer=[NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(showProgress) userInfo:nil repeats:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 150)];
            progressView.layer.cornerRadius=40.0f;
            progressView.center=self.view.center;
            progressView.backgroundColor=[UIColor purpleColor];
            UILabel *registrationTitle=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 150, 30)];
            registrationTitle.text=@"Enregistrement";
            registrationTitle.textAlignment=NSTextAlignmentCenter;
            registrationTitle.textColor=[UIColor whiteColor];
            appProgressBar=[[UIProgressView alloc]initWithFrame:CGRectMake(45, 98, 150, 2)];
            appProgressBar.progressViewStyle=UIProgressViewStyleDefault;
            appProgressBar.progress=0;
            [progressView addSubview:appProgressBar];
            [progressView addSubview:registrationTitle];
            [self.view addSubview:progressView];
            progressTimer=[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(showProgress) userInfo:nil repeats:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (unsigned long)NULL), ^{
                dbController.customer_name=self.name_Field.text;
                dbController.customer_civility=[self.civilitesSg titleForSegmentAtIndex:self.civilitesSg.selectedSegmentIndex];
                dbController.customer_address=self.address_Field.text;
                dbController.codepostal=self.postalCode_Field.text;
                dbController.customer_city=self.city_Field.text;
                dbController.telephone=self.phone_Field.text;
                dbController.customer_email=self.email_Field.text;
                dbController.loading_access=[self.access_Sg titleForSegmentAtIndex:self.access_Sg.selectedSegmentIndex];
                dbController.loading_address=self.start_address_Field.text;
                dbController.loading_postcode=self.start_Cp_Field.text;
                dbController.loading_city=self.start_city_Field.text;
                dbController.loading_existence_elevator=self.lift_Sg.selectedSegmentIndex;
                dbController.loading_floor=[self.floors_Field.text integerValue];
                if (self.persons_count_Sg.selectedSegmentIndex!=-1)
                    dbController.loading_elevator=self.persons_count_Sg.selectedSegmentIndex+2;
                else
                    dbController.loading_elevator=0;
                
                dbController.loading_standup_needed=self.move_furniture_Sg.selectedSegmentIndex;
                dbController.other_house_access=[self.destination_access_Sg titleForSegmentAtIndex:_destination_access_Sg.selectedSegmentIndex];
                dbController.other_house_address=self.destination_address_Field.text;
                dbController.other_house_city=self.destination_city_Field.text;
                dbController.other_house_postcode=self.destination_cp_Field.text;
                dbController.other_house_existence_elevator=self.destination_lift_Sg.selectedSegmentIndex;
                dbController.other_house_standup_needed=self.destination_furniture_Sg.selectedSegmentIndex;
                dbController.other_house_floor=[self.destination_floor_Field.text integerValue];
                if (self.destination_persons_Sg.selectedSegmentIndex!=-1)
                    dbController.other_house_elevator=self.destination_persons_Sg.selectedSegmentIndex+2;
                else
                    dbController.loading_elevator=0;
                dbController.delivery_comment=self.comment_TextView.text;
                NSDate *oldFormatDate=[formatter dateFromString:self.moving_date_Field.text];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                dbController.moving_date=[formatter stringFromDate:oldFormatDate];
                dbController.customer_create_date=[formatter stringFromDate:[NSDate date]];
                if ([dbController.Cust_Id intValue]==0) {
                    [dbController insertIntoTable];
                    [dbController closeConnection];
                    _customer_Id=dbController.Cust_Id;
                }
                else
                {
                    [dbController updateTableWithRowId:[_customer_Id intValue]];
                    [dbController closeConnection];
                }
            });
            
        });
    }
}
-(void) showProgress
{
    static float progressValue=0.0f;
    if (progressValue<=1.0f) {
        appProgressBar.progress=progressValue;
        progressValue+=0.25f;
    }
    else
    {
        [progressTimer invalidate];
        progressValue=0;
        [progressView removeFromSuperview];
        self.tabBarController.selectedIndex=1;
        self.tabBarController.selectedViewController.tabBarItem.enabled=YES;
        UINavigationController *nextController=(UINavigationController *)self.tabBarController.selectedViewController;
        MDDAddRoomsViewController *nextScreen=(MDDAddRoomsViewController *)[[nextController viewControllers] objectAtIndex:0];
        nextScreen.customer_Id=_customer_Id;
    }
    
    
}
- (IBAction)fait_press_Action:(UIButton *)sender {
    if (!_shifting_date_picker.hidden) {
        [formatter setDateStyle:NSDateFormatterLongStyle];
        NSString *formattedDate=[formatter stringFromDate:_shifting_date_picker.date];
        selectedMoveDate=formattedDate;
        
    }
    else
    {
        NSCalendar *myCalendar=[NSCalendar currentCalendar];
        NSDateComponents *myComponents=[[NSDateComponents alloc]init];
        NSString *fortNight= fortNightsArray[[_fortNight_picker selectedRowInComponent:0]];
        NSString *month=monthsArray[[_fortNight_picker selectedRowInComponent:1]];
        [myComponents setMonth:[_fortNight_picker selectedRowInComponent:1]+1];
        NSString *year=yearsArray[[_fortNight_picker selectedRowInComponent:2]];
        [myComponents setYear:[year integerValue]];
        
        NSRange myRange=[myCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[myCalendar dateFromComponents:myComponents]];
        if ([fortNight hasPrefix:@"1st"]) {
            selectedMoveDate=[NSString stringWithFormat:@"%i %@ %@",myRange.length/2,month,year];
        }
        else
        {
            selectedMoveDate=[NSString stringWithFormat:@"%i %@ %@",myRange.length,month,year];
        }
    }
    
    NSDate *selectedDate=[formatter dateFromString:selectedMoveDate];
    if ([[selectedDate earlierDate:[NSDate date]] isEqualToDate:selectedDate]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"MDD" message:@"Please select appropriate date" delegate:nil cancelButtonTitle:@"Bien" otherButtonTitles: nil];
        [alert show];
    }
    else{
        _moving_date_Field.text=selectedMoveDate;
        [self dismissPickerView];
    }
}
-(void) dismissPickerView
{
    [UIView beginAnimations:@"PickerViewGoingDown" context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    CGRect changedPickerFrame=initialPickerFrame;
    if ([UIScreen mainScreen].bounds.size.height<568) {
        changedPickerFrame.origin=CGPointMake(0, 369);
    }
    else
        changedPickerFrame.origin=CGPointMake(0, 457);
    
    
    
    _scrollView.contentInset=UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets=UIEdgeInsetsZero;
    
    [_allPickers_view setFrame:changedPickerFrame];
    [UIView commitAnimations];
    
}
- (IBAction)choose_date_action:(UISwitch *)sender {
    [UIView beginAnimations:@"Animation1" context:NULL];
    [UIView setAnimationDuration:0.5f];
    CGRect changedPickerFrame=initialPickerFrame;
    if ([UIScreen mainScreen].bounds.size.height<568) {
        changedPickerFrame.origin=CGPointMake(0, 132);
    }
    else
        changedPickerFrame.origin=CGPointMake(0, 220);
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, initialPickerFrame.size.height+100, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= initialPickerFrame.size.height;
    if (!CGRectContainsPoint(aRect, sender.frame.origin) ) {
        
        [_scrollView scrollRectToVisible:sender.frame animated:YES];
    }
    [_allPickers_view setFrame:changedPickerFrame];
    [UIView commitAnimations];
    if (!sender.isOn) {
        
        _fortNight_picker.hidden=NO;
        _shifting_date_picker.hidden=YES;
    }
    else
    {
        _fortNight_picker.hidden=YES;
        _shifting_date_picker.hidden=NO;
    }
    
}
- (IBAction)annuler_Press_Action:(UIButton *)sender {
    
    [self dismissPickerView];
    
    
}
- (IBAction)get_Moving_date:(UIDatePicker *)sender {
    
    
}
#pragma mark - text view delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if (textView.text.length>=255) {
        NSString *newString=[textView.text substringToIndex:254];
        textView.text=newString;
        [textView resignFirstResponder];
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString: @"commentaire"])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }

    activeField=textView;
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIView *doneFrame=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 310, 40)];
    [doneFrame setBackgroundColor:[UIColor grayColor]];
    doneButton.frame=CGRectMake(240, 0,80, 40);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor lightGrayColor]];
    [doneButton addTarget:self action:@selector(donePress:) forControlEvents:UIControlEventTouchUpInside];
    [doneFrame addSubview:doneButton];
    textView.inputAccessoryView=doneFrame;
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField=textView;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text=@"commentaire";
        textView.textColor=[UIColor lightGrayColor];
    }
    activeField=nil;
}

#pragma mark - text field delegate and keyboard management

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField=textField;
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIView *doneFrame=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 310, 40)];
    [doneFrame setBackgroundColor:[UIColor grayColor]];
    doneButton.frame=CGRectMake(240, 0,80, 40);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor lightGrayColor]];
    [doneButton addTarget:self action:@selector(donePress:) forControlEvents:UIControlEventTouchUpInside];
    [doneFrame addSubview:doneButton];
    textField.inputAccessoryView=doneFrame;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_email_Field]) {
        
        NSString *emailid = _email_Field.text;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if([emailTest evaluateWithObject:emailid]==NO)
        {
            UIAlertView *emailAlert=[[UIAlertView alloc]initWithTitle:@"Pas un e-mail-id" message:@"s'il vous plaît entrer une adresse email valide" delegate:nil cancelButtonTitle:@"bien" otherButtonTitles: nil];
            [emailAlert show];
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL resigner=[textField resignFirstResponder];
    
    return resigner;
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // reduce the content offset height.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
-(void) donePress :(UIButton *)sender
{
    [activeField resignFirstResponder];
}
// Called when the UIKeyboardWillHideNotification is sent

#pragma mark - picker view data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[pickerDictionary objectForKey:[NSNumber numberWithInteger:component]] count];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label=(id)view;
    if (label==nil) {
        label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=[pickerDictionary objectForKey:[NSNumber numberWithInteger:component]][row];
    return label;
}
#pragma mark - Action for back bar button
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end









