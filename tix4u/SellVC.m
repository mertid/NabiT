//
//  SellVC.m
//  tix4u
//
//  Created by Merritt Tidwell on 10/8/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "SellVC.h"
#import "MapVC.h"
#import <Parse/Parse.h>
#import "tix4u-swift.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface SellVC ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate>


@property (strong,nonatomic) NSString * selectedTicket;
@property (strong,nonatomic) NSString * selectedRow;
@property(strong,nonatomic) NSString * selectedEvent;
@property(strong,nonatomic) NSString * selectedSection;


@end

@implementation SellVC {
    
    NSArray * _numberOfTicket;
    NSArray * _row;
    NSArray * _section;
    NSDate *  _eventDate;
    NSMutableArray * _eventNames;
    CLLocationManager * locationManager;
    PFGeoPoint * sellerLocation;
    
    
}






-(void)downloadNearbyEvents {
    
//http://api.eventful.com/json/events/search?app_key=Pdv5pkc3G4tF3TCB&where=32.746682,-117.162741&within=25
    
    //TODO merritt, get sellers real location...
    
    
//     sellerLocation= [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
   
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *sellerLocation2, NSError *error) {
        if (!error) {
            NSLog(@"%@",sellerLocation2);
            
        
        }
    
        
    }];
    
    

    
  //  CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(32.746682, -117.162741);
    
    int withinRadius = 50;
    NSString* eventSearchParams = [NSString stringWithFormat:@"category=music&within=%d&where=%f,%f", withinRadius, sellerLocation.latitude, sellerLocation.longitude];
    
    [EventfulRequest eventfulRequest:@"events/search" parameters:eventSearchParams completion:^(NSArray * events) {
        if (events.count > 0) {
            
            for (int i=0; i<events.count; i++) {
                Event* currentEventInfo = events[i];
                [_eventNames addObject:currentEventInfo.title];
                [self.eventPicker reloadAllComponents];
            }
            
            /*
            sellersInfo = events;
            [salesTableView reloadData];
            [self populatePinsOnMapForEvents];
            */
        } else {
            NSLog(@"No events were found");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self downloadNearbyEvents];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];  //requesting location updates

    
    _eventNames = [@[] mutableCopy];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    
    float btnSize = 40;
    float padding = 10;
    float statusBarHeight = 20;
    
    //next Button
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((w-btnSize)/2.0, h-btnSize-padding, btnSize, btnSize)];
    [nextButton setTitle:@">" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor redColor];
    [nextButton addTarget:self action:@selector(showNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    //cancel Button
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:(CGRectMake(padding, statusBarHeight + padding, btnSize, btnSize))];
    cancelButton.backgroundColor = [UIColor redColor];
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    //Ticket Picker
    self.ticketPicker = [[UIPickerView alloc]initWithFrame:(CGRectMake(120, 55, 50, 50))];
    self.ticketPicker.showsSelectionIndicator = YES;
    _numberOfTicket = @[@"1",@"2",@"3",@"4"];
    self.ticketPicker.delegate = self;
    self.ticketPicker.dataSource = self;
    self.ticketPicker.tag = 0;
    [self.view addSubview:self.ticketPicker];
    
    //Ticket Label
    UILabel * ticketLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 55, 100, 60)];
    ticketLabel.text = @"Tickets";
    ticketLabel.textColor = [UIColor redColor];
    ticketLabel.font = [UIFont fontWithName:@"Helvetica" size:28];
    [self.view addSubview:ticketLabel];
    
    // Section Picker
    self.sectionPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(215, 175, 50, 50)];
    self.sectionPicker.showsSelectionIndicator = YES;
    _section= @[@"500", @"700"];
    self.sectionPicker.delegate = self;
    self.sectionPicker.dataSource = self;
    self.sectionPicker.tag = 1;
    [self.view addSubview:self.sectionPicker];
    
    // Section Label
    UILabel * sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 185, 80, 50)];
    sectionLabel.text = @"Section";
    sectionLabel.textColor = [UIColor redColor];
    [self.view addSubview:sectionLabel];
    
    // Row Picker
    self.rowPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(45, 175, 50, 50)];
    self.rowPicker.showsSelectionIndicator = YES;
    _row= @[@"1", @"3"];
    self.rowPicker.delegate = self;
    self.rowPicker.dataSource = self;
    self.rowPicker.tag = 2;
    [self.view addSubview:self.rowPicker];
    
    //Row Label
    UILabel * rowLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 185, 50, 50)];
    rowLabel.text = @"Row";
    rowLabel.textColor = [UIColor redColor];
    [self.view addSubview:rowLabel];
    
    //Event Picker
    
    self.eventPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(60, 350, 200, 50)];
    self.eventPicker.showsSelectionIndicator = YES;
    self.eventPicker.delegate = self;
    self.eventPicker.dataSource = self;
    self.eventPicker.tag = 3;
    [self.view addSubview:self.eventPicker];
    
    //Event Label
    UILabel * eventLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 310, 200, 50)];
    eventLabel.text = @"Choose Your Event";
    eventLabel.textColor = [UIColor redColor];
    [self.view addSubview:eventLabel];
}

-(void)showTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"other Venue";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    
    [self.view addSubview:textField];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _eventNames.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
            
            return  _numberOfTicket[row];
            break;
            
        case 1:
            
            return _section[row];
            break;
            
        case 2:
            return _row[row];
            break;
            
        case 3:
            
            return _eventNames[row];
            break;
            
        default:
            break;
    }
    
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"%d", (int)pickerView.tag);
    switch (pickerView.tag) {
        case 0:
            
            self.selectedTicket =  _numberOfTicket[row];
            break;
            
        case 1:
            
            self.selectedSection = _section[row];
            break;
            
        case 2:
            self.selectedRow = _row[row];
            break;
            
        case 3:
            
            self.selectedEvent = _eventNames[row];
            NSLog(@"%@", self.selectedEvent);
            
            break;
            
        default:
            break;
    }
    
    if ([self.eventPicker selectedRowInComponent:0] == 3)
    {
        [self showTextField];
    }
}

//-(void)saveToParseSell
//{
//    
//    PFObject * sellerInfo = [PFObject objectWithClassName:@"Ticket"];
//    [sellerInfo setObject: self.selectedTicket forKey:@"NumberOfTicketsSelling"];
//    [sellerInfo setObject: self.selectedEvent forKey:@"Event"];
//    [sellerInfo setObject: self.selectedRow forKey:@"Row"];
//    [sellerInfo setObject: self.selectedSection forKey:@"Section"];
//    // [sellerInfo setObject:_eventDate forKey:@"Date"];
//    NSLog(@"save to parseseller");
//    [sellerInfo setObject: sellerLocation forKey:@"sellerLocation"];
//    [sellerInfo setObject:[PFUser currentUser] forKey:@"SellerID"];
//    
//    [sellerInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Successfully saved tickets!");
//        } else {
//            NSLog(@"Couldn't save sellers tickets!");
//        }
//        
//        if (error != nil) {
//            NSLog(@"An error occurred %@", error.userInfo);
//        }
//    }];
//}

-(void)cancelButtonWasPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showNextPage {
    NSLog(@"self ticker running");
  //  [self saveToParseSell];
    [self performSegueWithIdentifier:@"listedID" sender:self];
}

@end
