//
//  SemPopupViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 26/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "SemPopupViewController.h"
#import "CCMPopupSegue.h"

@interface SemPopupViewController ()

@property (nonatomic, assign) BOOL isStartDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation SemPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *startTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startDateViewPressed:)];
    startTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.startDateView addGestureRecognizer:startTapGestureRecognizer];
    
    UITapGestureRecognizer *endTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endDateViewPressed:)];
    endTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.endDateView addGestureRecognizer:endTapGestureRecognizer];
    
    UITapGestureRecognizer *saveTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveViewPressed:)];
    saveTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.saveView addGestureRecognizer:saveTapGestureRecognizer];
    
    
    _isStartDate = YES;
}


-(void)saveViewPressed:(UITapGestureRecognizer *)recognizer {
    if ([_startDate compare:_endDate] == NSOrderedDescending) {
        NSLog(@"start is latter than end");
    } else if ([_startDate compare:_endDate] == NSOrderedAscending) {
        NSLog(@"start is earlier than end");
    }
    
    if (_startDate && _endDate) {
        
        _saveView.backgroundColor = [UIColor whiteColor];
        
        self.semLengthModel.semStartDate = _startDate;
        self.semLengthModel.semEndDate = _endDate;
        
        NSError *error = nil;
        
        if (![self.semLengthModel.managedObjectContext save:&error]) {
            NSLog(@"Unresolved SemLength error %@, %@", error, [error userInfo]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}


-(void)startDateViewPressed:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Start date %@",recognizer);
    
    [self deselectedView:self.endDateView withFirstLabel:self.endDateLabel andSecondLabel:self.semEndLabel];
    [self selectedView:self.startDateView withFirstLabel:self.startDateLabel andSecondLabel:self.semStartLabel];
    
    _isStartDate = YES;
}


-(void)endDateViewPressed:(UITapGestureRecognizer *)recognizer {
    
    
    [self deselectedView:self.startDateView withFirstLabel:self.startDateLabel andSecondLabel:self.semStartLabel];
    [self selectedView:self.endDateView withFirstLabel:self.endDateLabel andSecondLabel:self.semEndLabel];
    
    self.endDateLabel.text = @"Select Date";
    if ([self.startDateLabel.text isEqualToString:@"Select Date"]) {
        _isStartDate = YES;
    } else
        _isStartDate = NO;
    
}

-(void)selectedView:(UIView *)view withFirstLabel:(UILabel *)firstLabel andSecondLabel:(UILabel *)secondLabel {
    view.backgroundColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    firstLabel.textColor = [UIColor blackColor];
    secondLabel.textColor = [UIColor whiteColor];
}

-(void)deselectedView:(UIView *)view withFirstLabel:(UILabel *)firstLabel andSecondLabel:(UILabel *)secondLabel {
    view.backgroundColor = [UIColor lightGrayColor];
    firstLabel.textColor = [UIColor darkGrayColor];
    secondLabel.textColor = [UIColor darkGrayColor];
}

- (IBAction)datePickerPressed:(UIDatePicker *)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM dd yyyy"];
    if (_isStartDate) {
        _startDate = sender.date;
        self.startDateLabel.text = [dateFormatter stringFromDate:_startDate];
        
        
    } else {
        _endDate = sender.date;
        self.endDateLabel.text = [dateFormatter stringFromDate:_endDate];
        
    }
    
}


@end
