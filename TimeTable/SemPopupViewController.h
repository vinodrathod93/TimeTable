//
//  SemPopupViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 26/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMBorderView.h"
#import "SemLength.h"

@interface SemPopupViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet CCMBorderView *startDateView;
@property (weak, nonatomic) IBOutlet CCMBorderView *endDateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
- (IBAction)datePickerPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *semStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *semEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet CCMBorderView *saveView;

@property (nonatomic, strong) SemLength *semLengthModel;

@end
