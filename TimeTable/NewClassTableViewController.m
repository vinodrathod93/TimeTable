//
//  NewClassTableViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "NewClassTableViewController.h"
#import "DetailTableViewController.h"
#import "SelectedDayCell.h"
#import "AppDelegate.h"
#import "SubjectTime.h"

#define DEFAULT_TAG 10
#define DAY_SECTION 2
#define WEEKDAY_VALUE_CORRECTION 2

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
@property (nonatomic, assign) BOOL insertingWhileEdit;

@end

@implementation NewClassTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.datalistArray = [NSMutableArray array];
    
    // All Textfields delegate & keyboard type is set
    self.subjectTextField.delegate = self;
    self.lecturerTextField.delegate = self;
    self.classRoomTextField.delegate = self;
    
    self.weekdays = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    
    self.monButton.tag = DEFAULT_TAG;

    self.pickedDays = [[NSMutableOrderedSet alloc] init];
    
    if (self.isEditing) {
        
        self.title = @"Edit Class";
        self.subjectTextField.text = self.subjectDetailsModel.subject;
        self.lecturerTextField.text = self.subjectDetailsModel.teacher;
        self.classRoomTextField.text = self.subjectDetailsModel.venue;
        
        
        self.loadForEditing = YES;
        
        [self.subjectDetailsModel.days enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Days *editDay = obj;
            int16_t dayNumber = [editDay.dayID intValue];
            
            switch (dayNumber) {
                case 0:
                    [self buttonPressed:self.monButton andTagValue:dayNumber];
                    
                    break;
                    
                case 1:
                    [self buttonPressed:self.tueButton andTagValue:dayNumber];
                    
                    break;
                    
                case 2:
                    [self buttonPressed:self.wedButton andTagValue:dayNumber];
                    
                    break;
                    
                case 3:
                    [self buttonPressed:self.thuButon andTagValue:dayNumber];
                    
                    break;
                    
                case 4:
                    [self buttonPressed:self.friButton andTagValue:dayNumber];
                    
                    break;
                    
                case 5:
                    [self buttonPressed:self.satButton andTagValue:dayNumber];
                    
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        self.loadForEditing = NO;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewwillAppear");
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)addSelectedDayWithDayValue:(NSInteger)value {
    NSLog(@"addSelectedDayWithDayValue");
    
    Days *dayModel = [NSEntityDescription insertNewObjectForEntityForName:@"Days" inManagedObjectContext:self.subjectDetailsModel.managedObjectContext];
    dayModel.day = self.weekdays[value];
    dayModel.dayID = [NSString stringWithFormat:@"%ld",(long)value];
    
//    NSLog(@"%@",self.subjectDetailsModel.days);
    
    NSMutableOrderedSet *pickedDays = [self.subjectDetailsModel.days mutableCopy];
    [pickedDays addObject:dayModel];
    
    self.subjectDetailsModel.days = [pickedDays copy];
    
}

-(void)removeSelectedDayAtIndex:(NSInteger)index {
    NSMutableOrderedSet *pickedDays = [self.subjectDetailsModel.days mutableCopy];
    if (index < pickedDays.count && index >= 0) {
        [pickedDays removeObjectAtIndex:index];
        
        Days *object = [self.subjectDetailsModel.days objectAtIndex:index];
        
        if ([self.subjectDetailsModel.days containsObject:object]) {
            [self.subjectDetailsModel.managedObjectContext deleteObject:object];
        }
        
    
//        NSLog(@"%@",self.subjectDetailsModel.days);
        self.subjectDetailsModel.days = [pickedDays copy];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)buttonPressed:(UIButton *)button andTagValue:(int16_t)tagValue {
    NSNumber *number = [NSNumber numberWithInt:tagValue];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 22.5f;
    button.backgroundColor = [self.tableView tintColor];
    button.tag = tagValue;
    
    if (!self.loadForEditing) {
        [self addSelectedDayWithDayValue:tagValue];
    }
    
    [self.datalistArray addObject:number];
    
    NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:DAY_SECTION];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)buttonUnPressed:(UIButton *)button andTagValue:(int16_t)tagValue {
    NSNumber *number = [NSNumber numberWithInt:tagValue];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = DEFAULT_TAG;
    button.backgroundColor = [UIColor whiteColor];
    
    NSInteger row = [NSNumber numberWithUnsignedLong:[self.datalistArray indexOfObject:number]].integerValue;
    [self.datalistArray removeObject:number];
    
    [self removeSelectedDayAtIndex:row];
    
    NSInteger rowInSection = [self.tableView numberOfRowsInSection:DAY_SECTION];
    
    if (rowInSection > 0) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:DAY_SECTION];
        [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

-(void)scrollTableViewDownToLastCell {
    if (self.datalistArray.count > 0) {
        NSInteger row = self.datalistArray.count-1;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:DAY_SECTION] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)monButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.monButton.tag == TTClassEntryDayMonday) {
        [self buttonUnPressed:self.monButton andTagValue:TTClassEntryDayMonday];
        
    } else {
        [self buttonPressed:self.monButton andTagValue:TTClassEntryDayMonday];
        [self scrollTableViewDownToLastCell];
        
        
    }

}
- (IBAction)tueButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.tueButton.tag == TTClassEntryDayTuesday) {
        [self buttonUnPressed:self.tueButton andTagValue:TTClassEntryDayTuesday];
        
    }
    else {
        [self buttonPressed:self.tueButton andTagValue:TTClassEntryDayTuesday];
        [self scrollTableViewDownToLastCell];
    }

    
}
- (IBAction)wedButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.wedButton.tag == TTClassEntryDayWednesday) {
        [self buttonUnPressed:self.wedButton andTagValue:TTClassEntryDayWednesday];
        
    }
    else {
        [self buttonPressed:self.wedButton andTagValue:TTClassEntryDayWednesday];
        [self scrollTableViewDownToLastCell];
    }

}
- (IBAction)thuButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.thuButon.tag == TTClassEntryDayThursday) {
        [self buttonUnPressed:self.thuButon andTagValue:TTClassEntryDayThursday];
    }
    else {
        [self buttonPressed:self.thuButon andTagValue:TTClassEntryDayThursday];
        [self scrollTableViewDownToLastCell];
    }

}
- (IBAction)friButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.friButton.tag == TTClassEntryDayFriday) {
        [self buttonUnPressed:self.friButton andTagValue:TTClassEntryDayFriday];
        
    }
    else {
        [self buttonPressed:self.friButton andTagValue:TTClassEntryDayFriday];
        [self scrollTableViewDownToLastCell];
    }

}
- (IBAction)satButtonClicked:(id)sender {
    if (self.isEditing) {
        self.insertingWhileEdit = YES;
    }
    
    if (self.satButton.tag == TTClassEntryDaySaturday) {
        [self buttonUnPressed:self.satButton andTagValue:TTClassEntryDaySaturday];
    }
    else {
        [self buttonPressed:self.satButton andTagValue:TTClassEntryDaySaturday];
        [self scrollTableViewDownToLastCell];
    }

}



#pragma mark - Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    if (section == DAY_SECTION) {
        return [self.datalistArray count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"cellForRowAtIndexPath");

    
    if (indexPath.section == DAY_SECTION) {
        // make dynamic row's cell
        static NSString *CellIdentifier = @"selectedCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        
        int day = [(NSNumber *)[self.datalistArray objectAtIndex:indexPath.row] intValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        
        Days *pickeday = [self.subjectDetailsModel.days objectAtIndex:indexPath.row];
        
        // Label of selected time
        
//        NSLog(@"%@",pickeday.time);
        if (pickeday.time == nil) {
            cell.detailTextLabel.text = @"Tap to Select Time";
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        } else {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:pickeday.time.start],[dateFormatter stringFromDate:pickeday.time.end]];
            cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        }
        
        
        // Label of WeekDay
        cell.textLabel.text = [self.weekdays objectAtIndex:day];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        
        return cell;
    }
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    Days *selectedDay = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if (indexPath.section == 1) {
        NSLog(@"Selected cell ");
    }
    if (indexPath.section == DAY_SECTION) {
        
        Days *selectedDay = [self.subjectDetailsModel.days objectAtIndex:indexPath.row];
        
        SubjectTime *time;
        SelectedDayTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectedDayVC"];
        
        
        if (!self.isEditing || self.insertingWhileEdit) {
            time = [NSEntityDescription insertNewObjectForEntityForName:@"SubjectTime" inManagedObjectContext:selectedDay.managedObjectContext];
            selectedDay.time = time;
        } else {
            time = selectedDay.time;
            vc.cameForEditing = YES;
        }
        
//        NSLog(@"%@",time);
        [vc initWithDayTime:time];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%d",(indexPath.section == DAY_SECTION));
    return indexPath.section == DAY_SECTION;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Add Subject Details";
            break;
            
        case 1:
            return @"Select Days of Class";
            break;
            
        case 2:
            return @"Selected Days";
            break;
            
        default:
            break;
    }
    
    return @"";
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
    if (indexPath.section == DAY_SECTION) {
        return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (indexPath.section == DAY_SECTION) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}


- (IBAction)savePressed:(id)sender {

//    if (self.subjectTextField.text == nil) {
//        NSLog(@"Subject Fields remaining");
//    } else {
//        UIAlertView *errorMessage = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have missed something to enter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [errorMessage show];
//    }
    
    self.subjectDetailsModel.subject = [self.subjectTextField.text capitalizedString];
    self.subjectDetailsModel.teacher = [self.lecturerTextField.text capitalizedString];
    self.subjectDetailsModel.venue = [self.classRoomTextField.text capitalizedString];
    
    
    
    if (!self.isEditing) {
        // Attendance
        self.attendance = [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:self.subjectDetailsModel.managedObjectContext];
        
        self.subjectDetailsModel.attendance = self.attendance;
    }
    
    
    
    // Sorted all the selected day according to the weekdays and copied back to the managedObjectContext.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"dayID"
                                        ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSArray *sortedDays = [self.subjectDetailsModel.days sortedArrayUsingDescriptors:sortDescriptors];
    
    self.subjectDetailsModel.days = [[NSOrderedSet orderedSetWithArray:sortedDays] copy];
    
    NSInteger totalLectures = 0;
    
    
    // Enumerate through all the days selected.
    for (Days *selectedDay in sortedDays) {
        
        
        // Schedule notification for each day of the selected time
        [self scheduleNotificationForDay:selectedDay andForSubject:self.subjectDetailsModel];
        
        
        // calculate days from start date to end date selected at the launch of app.
        NSInteger value = [self countDays:(selectedDay.dayID.intValue + WEEKDAY_VALUE_CORRECTION) startDate:self.semLength.semStartDate endDate:self.semLength.semEndDate];
        
        totalLectures = totalLectures + value;
        NSLog(@"%ld",(long)totalLectures);
        
        self.subjectDetailsModel.attendance.dayInAttendance = selectedDay;
    }
    
    
    // assign the total lectures & calculated lecture for further processing - like when lecture missed then total lectures should be managed to get the % of that subject attended, missed.
    NSLog(@"Total %ld",(long)totalLectures);
    self.subjectDetailsModel.attendance.totalLecture = [NSNumber numberWithInteger:totalLectures];
    
    if (![self.subjectDetailsModel.attendance.calculatedLectures isEqualToNumber:self.subjectDetailsModel.attendance.totalLecture]) {
        self.subjectDetailsModel.attendance.calculatedLectures = [NSNumber numberWithInteger:totalLectures];
    }
    
    
    // Assign the minimum attendance to the Attendance managed object.
    if (self.minAttendTextField.text.intValue <= 100) {
        self.subjectDetailsModel.attendance.minAttendance = [NSNumber numberWithInt:self.minAttendTextField.text.intValue];
    } else {
        self.subjectDetailsModel.attendance.minAttendance = @75;
    }
    
    
    // Save all the edit's or new changes
    NSError *error = nil;
    [self.subjectDetailsModel.managedObjectContext save:&error];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelPressed:(id)sender {
    
    if (!self.isEditing) {
        [self.subjectDetailsModel.managedObjectContext deleteObject:self.subjectDetailsModel];
    } else if (self.isEditing) {
        NSLog(@"Cancel Pressed");
        
        if ([self.subjectDetailsModel.managedObjectContext hasChanges]) {
            [self.subjectDetailsModel.managedObjectContext rollback];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// when tableview is scrolled then the keyboard will get dismissed no matter which keyboard.
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[self view]endEditing:YES];
}


-(void)scheduleNotificationForDay:(Days *)day andForSubject:(SubjectDetails *)subjectDetail {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    
    NSString *startTime = [dateFormatter stringFromDate:day.time.start];
    
    NSDate *tenMinEarlierTime = [day.time.start dateByAddingTimeInterval:-60*10];
    

    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:subjectDetail.subject, @"uid", nil];
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [self fixNotificationDate:tenMinEarlierTime ofDay:day];
    localNotification.alertBody = [NSString stringWithFormat:@"You have a %@ lecture in Classroom no. %@ at %@",subjectDetail.subject, subjectDetail.venue, startTime];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitWeekOfYear;
    localNotification.hasAction = YES;
    localNotification.category = @"CATEGORY";
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
}


-(NSDate *)fixNotificationDate:(NSDate *)dateToFix ofDay:(Days *)day {
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:dateToFix];
    
    NSNumber *value = [NSNumber numberWithInt:(day.dayID.intValue + WEEKDAY_VALUE_CORRECTION)];
    
    NSLog(@"week day is %ld",(long)value.integerValue);
    dateComponents.weekday = [value integerValue];
    dateComponents.second = 0;
    
    
    NSDate *fixedDate = [calendar dateFromComponents:dateComponents];
    
    return fixedDate;

}


-(NSInteger)countDays:(int)dayCode startDate:(NSDate *)stDate endDate:(NSDate *)endDate
{
    
    // day code is Sunday = 1 ,Monday = 2,Tuesday = 3,Wednesday = 4,Thursday = 5,Friday = 6,Saturday = 7
    NSLog(@"%d & startdate %@",dayCode,stDate);
    
    NSInteger count = 0;
    
    // Set the incremental interval for each interaction.
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    [oneDay setDay:1];
    
    // Using a Gregorian calendar.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *currentDate = stDate;
    
    // Iterate from fromDate until toDate
    while ([currentDate compare:endDate] == NSOrderedAscending) {
        
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:currentDate];
        
        if (dateComponents.weekday == dayCode) {
            count++;
        }
        
        // "Increment" currentDate by one day.
        currentDate = [calendar dateByAddingComponents:oneDay
                                                toDate:currentDate
                                               options:0];
    }
    NSDateComponents* component = [calendar components:NSCalendarUnitWeekday fromDate:endDate];
    NSInteger weekDay = [component weekday];
    if (weekDay == dayCode) { // Condition if end date contain your day then count should be increase
        count ++ ;
    }
    return count; // Return your day count
}



@end
