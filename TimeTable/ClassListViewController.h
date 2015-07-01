//
//  ClassListViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 23/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attendance.h"
#import "SubjectDetails.h"
#import "SemLength.h"

@interface ClassListViewController : UITableViewController


@property(nonatomic, strong) Attendance *attendance;
@property(nonatomic, strong) SubjectDetails *subjectDetailsModel;
@property(nonatomic, strong) SemLength *semLength;

@end
