//
//  SelectedDayTableViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectDetails.h"
#import "SubjectTime.h"
#import "Days.h"

@interface SelectedDayTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) SubjectTime *time;
@property (nonatomic, assign) BOOL cameForEditing;


-(void)initWithDayTime:(SubjectTime *)time;

@end
