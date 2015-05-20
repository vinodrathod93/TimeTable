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
#import "SelectedDayTableViewController.h"


@interface NewClassTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *semesterTextField;
@property (weak, nonatomic) IBOutlet UITextField *lecturerTextField;
@property (weak, nonatomic) IBOutlet UITextField *classRoomTextField;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) SubjectDetails *subjectDetails;
@property (strong, nonatomic) Days *days;
@property (nonatomic, strong) NSMutableSet *pickedDays;

@end