//
//  SelectedDayTableViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "SelectedDayTableViewController.h"

#define kStartTimePickerIndex 1
#define kEndTimePickerIndex 3
#define kDatePickerCellHeight 164

@interface SelectedDayTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (assign) BOOL startTimePickerIsShowing;
@property (assign) BOOL endTimePickerIsShowing;


@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;

@property (strong, nonatomic) NSDate *selectedStartTime;
@property (strong, nonatomic) NSDate *selectedEndTime;
@end

@implementation SelectedDayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    if (self.cameForEditing) {
        self.title = @"Edit Time";
    } else {
        self.title = @"Select Time";
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
    
    [self setupTime];
    
    
}

-(void)initWithDayTime:(SubjectTime *)time {
    self.time = time;
}


- (void)setupTime {
    NSLog(@"Setup Time");
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    
    NSDate *defaultDate = [NSDate date];
//    NSLog(@"%@",self.time);
    
    if (self.time.start != nil && self.time.end != nil) {
        self.startTime.text = [self.dateFormatter stringFromDate:self.time.start];
        self.startTimePicker.date = self.time.start;
        
        self.endTime.text = [self.dateFormatter stringFromDate:self.time.end];
        self.endTimePicker.date = self.time.end;
    }
    
    
    self.startTime.textColor = [self.tableView tintColor];
    
    self.endTime.textColor = [self.tableView tintColor];
    self.selectedStartTime = defaultDate;
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"heightForRowAtIndexPath");
    CGFloat height = 60.0f;
    
    if (indexPath.row == kStartTimePickerIndex){
        
        height = self.startTimePickerIsShowing ? kDatePickerCellHeight : 0.0f;
        
    } else if (indexPath.row == kEndTimePickerIndex) {
        height = self.endTimePickerIsShowing ?kDatePickerCellHeight : 0.0f;
    }
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        
        if (self.startTimePickerIsShowing){
            
            [self hideStartTimePicker];
            
        }else {
            
            [self showStartTimePicker];
        }
    } else if (indexPath.row == 2) {
        if (self.endTimePickerIsShowing){
            
            [self hideEndTimePicker];
            
        }else {
            [self hideStartTimePicker];
            [self showEndTimePicker];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Picker Value Changed

- (IBAction)startTimeChanged:(UIDatePicker *)sender {
    self.startTime.text = [self.dateFormatter stringFromDate:sender.date];
    self.selectedStartTime = sender.date;
    
    self.time.start = sender.date;
    
}
- (IBAction)endTimeChanged:(UIDatePicker *)sender {
    self.endTime.text = [self.dateFormatter stringFromDate:sender.date];
    self.selectedEndTime = sender.date;
    
    self.time.end = sender.date;
}


#pragma mark - Show/Hide Start Time

- (void)showStartTimePicker {
    
    self.startTimePickerIsShowing = YES;
    
    self.time.start= self.startTimePicker.date;
    
    self.startTime.text = [self.dateFormatter stringFromDate:self.startTimePicker.date];
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.startTimePicker.datePickerMode = UIDatePickerModeTime;
    self.startTimePicker.hidden = NO;
    self.startTimePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.startTimePicker.alpha = 1.0f;
        
    }];
}

- (void)hideStartTimePicker {
    
    self.startTimePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startTimePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.startTimePicker.hidden = YES;
                     }];
}



#pragma mark - Show/Hide End Time

- (void)showEndTimePicker {
    
    self.endTimePickerIsShowing = YES;
    
    // End time on EndTimePicker starts with the time selected by the user on startTimePicker
    if (!self.cameForEditing) {
        self.endTimePicker.date = self.startTimePicker.date;
    }
    
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.endTimePicker.datePickerMode = UIDatePickerModeTime;
    self.endTimePicker.hidden = NO;
    self.endTimePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.endTimePicker.alpha = 1.0f;
        
    }];
}

- (void)hideEndTimePicker {
    
    self.endTimePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endTimePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.endTimePicker.hidden = YES;
                     }];
}


@end
