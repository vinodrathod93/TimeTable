//
//  DetailTableViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "DetailTableViewController.h"
#import "NewClassTableViewController.h"
#import "DetailOverviewCell.h"
#import "AttendanceCell.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

NSString *CellIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSArray *indexpaths = [self.tableView indexPathsForVisibleRows];
//    if (self.editingDone) {
//        [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    
    self.viewModel.numberOfDays = [self.viewModel.model.days count];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%ld",(long)[self.viewModel numberOfDays]);
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.viewModel numberOfDays];
    } else if (section == 2) {
        return 1;
    }
    
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CellIdentifier = @"overviewCell";
        }
    } else if (indexPath.section == 1) {
        CellIdentifier = @"detailCell";
    } else if (indexPath.section == 2) {
        CellIdentifier = @"attendanceCell";
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    if (indexPath.section == 0) {
        [self configureOverviewCell:cell forIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        [self configureCell:cell forIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        [self configureAttendanceCell:cell forIndexPath:indexPath];
    }
    
    return cell;
}

-(void)configureOverviewCell:(DetailOverviewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.subjectLabel.text = [self.viewModel titleOfSubject];
    cell.lecturerLabel.text = [self.viewModel nameOfLecturer];
    cell.venueLabel.text = [self.viewModel nameOfVenue];
    cell.minAttendanceLabel.text = [self.viewModel valueOfMinAttendance];
}

-(void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.viewModel titleForDayAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.viewModel subtitleAtIndex:indexPath.row];
}

-(void)configureAttendanceCell:(AttendanceCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.attendedValue.text = [self.viewModel attendedValueInAttendance];
    cell.missedValue.text = [self.viewModel missedValueInAttendance];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 206.0f;
        }
    } else if (indexPath.section == 2)
        return 85.0f;
    
    return 45.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Subject Details";
            break;
            
        case 1:
            return @"Days";
            break;
            
        case 2:
            return @"Attendance";
            break;
            
        default:
            break;
    }
    return @"";
}


- (IBAction)editButtonPressed:(id)sender {
    NewClassTableViewController *editClassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newClass"];
    editClassVC.subjectDetailsModel = self.viewModel.model;
    editClassVC.isEditing = YES;
    editClassVC.semLength = self.semLength;
    
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:editClassVC];
    [self presentViewController:navigationViewController animated:YES completion:^{
        self.editingDone = YES;
    }];
}
@end
