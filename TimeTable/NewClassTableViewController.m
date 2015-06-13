//
//  NewClassTableViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "NewClassTableViewController.h"
#import "SelectedDayCell.h"
#import "AppDelegate.h"
#import "SubjectTime.h"

#define DEFAULT_TAG 10

NS_ENUM(int16_t, TTClassEntryDay) {
    TTClassEntryDayMonday = 0,
    TTClassEntryDayTuesday = 1,
    TTClassEntryDayWednesday = 2,
    TTClassEntryDayThursday = 3,
    TTClassEntryDayFriday = 4,
    TTClassEntryDaySaturday = 5
};

@interface NewClassTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thuButon;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic) NSMutableArray *datalistArray;
@property (nonatomic) NSArray *weekdays;

@end

@implementation NewClassTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.datalistArray = [NSMutableArray array];
    
    // All Textfields delegate & keyboard type is set
    self.subjectTextField.delegate = self;
    self.lecturerTextField.delegate = self;
    self.classRoomTextField.delegate = self;
    self.classRoomTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.weekdays = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    
    self.monButton.tag = DEFAULT_TAG;

    self.pickedDays = [[NSMutableOrderedSet alloc] init];
    
    /*
    // Retrieve all tags
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [self addAllDays];
    }
    
    // Each tag attached to the details is included in the array
    NSSet *days = self.subjectDetailsModel.days;
    NSLog(@"%@",days);
    
    for (Days *day in days) {
        
        NSLog(@"ViewDidLoad-Picked days: %@",day.day);
        [self.pickedDays addObject:day];
        
    }
     */
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)addAllDays {
    for (int i=0; i<self.weekdays.count; i++) {
        
        // Entity of the Days
        Days *daysModel = [NSEntityDescription insertNewObjectForEntityForName:@"Days" inManagedObjectContext:self
                     .subjectDetailsModel.managedObjectContext];
        
        daysModel.day = self.weekdays[i];
        daysModel.dayID = [NSString stringWithFormat:@"%d",i];
        
        // Entity of the Time
        SubjectTime *time = [NSEntityDescription insertNewObjectForEntityForName:@"SubjectTime" inManagedObjectContext:self.subjectDetailsModel.managedObjectContext];
//        time.day = self.daysModel;
        daysModel.time = time;
        
        
        NSError *error = nil;
//        if (![self.daysModel.managedObjectContext save:&error]) {
//            NSLog(@"Core data error %@, %@", error, [error userInfo]);
//            abort();
//        }
        
        [self.fetchedResultsController performFetch:&error];
    }
    
}


-(void)addSelectedDayWithDayValue:(NSInteger)value {
    Days *dayModel = [NSEntityDescription insertNewObjectForEntityForName:@"Days" inManagedObjectContext:self.subjectDetailsModel.managedObjectContext];
    dayModel.day = self.weekdays[value];
    dayModel.dayID = [NSString stringWithFormat:@"%ld",(long)value];
    
    NSLog(@"%@",self.subjectDetailsModel.days);
    
    NSMutableOrderedSet *pickedDays = [self.subjectDetailsModel.days mutableCopy];
    [pickedDays addObject:dayModel];
    
    self.subjectDetailsModel.days = [pickedDays copy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"dayID"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [self.subjectDetailsModel.days sortedArrayUsingDescriptors:sortDescriptors];
}

-(void)removeSelectedDayAtIndex:(NSInteger)index {
    NSMutableOrderedSet *pickedDays = [self.subjectDetailsModel.days mutableCopy];
    if (index < pickedDays.count && index >= 0 ) {
        [pickedDays removeObjectAtIndex:index];
        
        self.subjectDetailsModel.days = [pickedDays copy];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



- (IBAction)monButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayMonday];
    
    if (self.monButton.tag == TTClassEntryDayMonday) {
        self.monButton.backgroundColor = [UIColor whiteColor];
        self.monButton.tag = DEFAULT_TAG;
        
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        self.monButton.layer.cornerRadius = 22.5f;
        self.monButton.backgroundColor = [self.tableView tintColor];
        self.monButton.tag = TTClassEntryDayMonday;
        
        
        [self addSelectedDayWithDayValue:TTClassEntryDayMonday];
        
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    /*
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayMonday];
    
    if (self.monButton.tag == TTClassEntryDayMonday) {
        self.monButton.backgroundColor = [UIColor whiteColor];
        self.monButton.tag = DEFAULT_TAG;
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
        if ([self.pickedDays containsObject:day]) {
            [self.pickedDays removeObject:day];
            self.subjectDetailsModel.days = [self.pickedDays copy];
        }
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        

    }
    else {
        self.monButton.layer.cornerRadius = 22.5f;
        self.monButton.backgroundColor = [self.tableView tintColor];
        self.monButton.tag = TTClassEntryDayMonday;
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
        [self.pickedDays addObject:day];
        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSLog(@"Row: %ldClicked-Picked Days %@",(long)row,day.day);
    }
    */
    

}
- (IBAction)tueButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayTuesday];
    
    
    if (self.tueButton.tag == TTClassEntryDayTuesday) {
        self.tueButton.backgroundColor = [UIColor whiteColor];
        self.tueButton.tag = DEFAULT_TAG;
        
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        if ([self.pickedDays containsObject:day]) {
//            [self.pickedDays removeObject:day];
//            self.subjectDetailsModel.days = [self.pickedDays copy];
//        }
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    else {
        self.tueButton.layer.cornerRadius = 22.5f;
        self.tueButton.backgroundColor = [self.tableView tintColor];
        self.tueButton.tag = TTClassEntryDayTuesday;
        
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        [self.pickedDays addObject:day];
//        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        [self addSelectedDayWithDayValue:TTClassEntryDayTuesday];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
//        NSLog(@"Row: %ldClicked-Picked Days %@",(long)row,day.day);
        
    }

    
}
- (IBAction)wedButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayWednesday];
    if (self.wedButton.tag == TTClassEntryDayWednesday) {
        self.wedButton.backgroundColor = [UIColor whiteColor];
        self.wedButton.tag = DEFAULT_TAG;
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        if ([self.pickedDays containsObject:day]) {
//            [self.pickedDays removeObject:day];
//            self.subjectDetailsModel.days = [self.pickedDays copy];
//        }
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    else {
        self.wedButton.layer.cornerRadius = 22.5f;
        self.wedButton.backgroundColor = [self.tableView tintColor];
        self.wedButton.tag = TTClassEntryDayWednesday;
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        
//        [self.pickedDays addObject:day];
//        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        [self addSelectedDayWithDayValue:TTClassEntryDayWednesday];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
//        NSLog(@"Row: %ldClicked-Picked Days %@",(long)row,day.day);
    }

}
- (IBAction)thuButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayThursday];
    if (self.thuButon.tag == TTClassEntryDayThursday) {
        self.thuButon.backgroundColor = [UIColor whiteColor];
        self.thuButon.tag = DEFAULT_TAG;
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        if ([self.pickedDays containsObject:day]) {
//            [self.pickedDays removeObject:day];
//            self.subjectDetailsModel.days = [self.pickedDays copy];
//        }
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    else {
        self.thuButon.layer.cornerRadius = 22.5f;
        self.thuButon.backgroundColor = [self.tableView tintColor];
        self.thuButon.tag = TTClassEntryDayThursday;
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        [self.pickedDays addObject:day];
//        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        [self addSelectedDayWithDayValue:TTClassEntryDayThursday];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }

}
- (IBAction)friButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDayFriday];
    if (self.friButton.tag == TTClassEntryDayFriday) {
        self.friButton.backgroundColor = [UIColor whiteColor];
        self.friButton.tag = DEFAULT_TAG;
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        if ([self.pickedDays containsObject:day]) {
//            [self.pickedDays removeObject:day];
//            self.subjectDetailsModel.days = [self.pickedDays copy];
//        }
        
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    else {
        self.friButton.layer.cornerRadius = 22.5f;
        self.friButton.backgroundColor = [self.tableView tintColor];
        self.friButton.tag = TTClassEntryDayFriday;
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        [self.pickedDays addObject:day];
//        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        [self addSelectedDayWithDayValue:TTClassEntryDayFriday];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }

}
- (IBAction)satButtonClicked:(id)sender {
    NSNumber *number = [NSNumber numberWithInt:TTClassEntryDaySaturday];
    if (self.satButton.tag == TTClassEntryDaySaturday) {
        self.satButton.backgroundColor = [UIColor whiteColor];
        self.satButton.tag = DEFAULT_TAG;
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        [self.datalistArray removeObject:number];
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        if ([self.pickedDays containsObject:day]) {
//            [self.pickedDays removeObject:day];
//            self.subjectDetailsModel.days = [self.pickedDays copy];
//        }
        
        [self removeSelectedDayAtIndex:row];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    else {
        self.satButton.layer.cornerRadius = 22.5f;
        self.satButton.backgroundColor = [self.tableView tintColor];
        self.satButton.tag = TTClassEntryDaySaturday;
        [self.datalistArray addObject:number];
        NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
        
//        Days *day = (Days *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[number intValue] inSection:0]];
//        
//        [self.pickedDays addObject:day];
//        self.subjectDetailsModel.days = [self.pickedDays copy];
        
        [self addSelectedDayWithDayValue:TTClassEntryDaySaturday];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }

}



#pragma mark - Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return [self.datalistArray count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == 2) {
        // make dynamic row's cell
        static NSString *CellIdentifier = @"Dynamic Cell";
        SelectedDayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[SelectedDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
        int day = [(NSNumber *)[self.datalistArray objectAtIndex:indexPath.row] intValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
       // NSArray *pickedArray = [self.subjectDetailsModel.days allObjects];
        
       // NSLog(@"Array is %@",pickedArray);
        //Days *pickeday = [pickedArray objectAtIndex:indexPath.row];
        
        Days *pickeday = [self.subjectDetailsModel.days objectAtIndex:indexPath.row];
        
        // Label of selected time
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:pickeday.time.start],[dateFormatter stringFromDate:pickeday.time.end]];
        
        // Label of WeekDay
        cell.dayLabel.text = [self.weekdays objectAtIndex:day];
        
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    Days *selectedDay = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if (indexPath.section == 1) {
        NSLog(@"Selected cell ");
    }
    if (indexPath.section == 2) {
//        NSArray *array = [self.subjectDetailsModel.days allObjects];
//        Days *selectedDay = [array objectAtIndex:indexPath.row];
        
        Days *selectedDay = [self.subjectDetailsModel.days objectAtIndex:indexPath.row];
        
        SubjectTime *time = [NSEntityDescription insertNewObjectForEntityForName:@"SubjectTime" inManagedObjectContext:selectedDay.managedObjectContext];
        selectedDay.time = time;
        
        
        
        SelectedDayTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectedDayVC"];
        
        
        
        [vc initWithDayTime:time];
//        [vc initWithSelectedDay:selectedDay];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - TableView Delegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int section = indexPath.section;
    
    // if dynamic section make all rows the same height as row 0
    if (indexPath.section == 2) {
        return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (indexPath.section == 2) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

/*
#pragma mark - Result controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Days"
                                   inManagedObjectContext:self.subjectDetailsModel.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"dayID"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:fetchRequest
                                                                                                 managedObjectContext:self.subjectDetailsModel.managedObjectContext
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:@"Root"];
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}
*/

- (IBAction)savePressed:(id)sender {
//    self.subjectDetailsModel = [NSEntityDescription insertNewObjectForEntityForName:@"SubjectDetails" inManagedObjectContext:self.appDelegate.managedObjectContext];

    
    self.subjectDetailsModel.subject = self.subjectTextField.text;
    self.subjectDetailsModel.teacher = self.lecturerTextField.text;
    self.subjectDetailsModel.venue = self.classRoomTextField.text;
    self.subjectDetailsModel.semLength = [NSNumber numberWithInt:[self.semesterTextField.text intValue]];
    
    
//    self.subjectDetailsModel.days = self.pickedDays;
    for (Days *selectedDay in self.subjectDetailsModel.days) {
        [self scheduleNotificationForDay:selectedDay];
    }
    
    
    
    NSError *error = nil;
    [self.subjectDetailsModel.managedObjectContext save:&error];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelPressed:(id)sender {
    [self.subjectDetailsModel.managedObjectContext deleteObject:self.subjectDetailsModel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// when tableview is scrolled then the keyboard will get dismissed no matter which keyboard.
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[self view]endEditing:YES];
}

-(void)scheduleNotificationForDay:(Days *)day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [self fixNotificationDate:day.time.start];
    NSLog(@"Day is %@ & time is %@",day.day,[dateFormatter stringFromDate:day.time.start]);
    localNotification.alertBody = @"Hey!!! You have a lecture to attend";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
}


-(NSDate *)fixNotificationDate:(NSDate *)dateToFix {
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:dateToFix];
    dateComponents.second = 0;
    
    NSDate *fixedDate = [calendar dateFromComponents:dateComponents];
    
    return fixedDate;

}

@end
