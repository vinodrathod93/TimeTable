//
//  NewClassTableViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectDetails.h"
#import "Days.h"
#import "Attendance.h"
#import "SemLength.h"
#import "SelectedDayTableViewController.h"


@interface NewClassTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *minAttendTextField;
@property (weak, nonatomic) IBOutlet UITextField *lecturerTextField;
@property (weak, nonatomic) IBOutlet UITextField *classRoomTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,assign) BOOL loadForEditing;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) SubjectDetails *subjectDetailsModel;
@property (strong, nonatomic) Days *daysModel;
@property (strong, nonatomic) Attendance *attendance;
@property (strong, nonatomic) SemLength *semLength;

@property (nonatomic, strong) NSMutableOrderedSet *pickedDays;

@end
