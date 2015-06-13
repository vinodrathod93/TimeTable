//
//  DetailTableViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailOverviewCell.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

NSString *CellIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%ld",(long)[self.viewModel numberOfDays]);
    
    if (section == 0) {
        return 1;
    } else if (section == 1)
        return [self.viewModel numberOfDays];
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CellIdentifier = @"overviewCell";
        }
    } else if (indexPath.section == 1) {
        CellIdentifier = @"detailCell";
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    if (indexPath.section == 0) {
        [self configureOverviewCell:cell forIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        [self configureCell:cell forIndexPath:indexPath];
    }
    
    
    
    return cell;
}

-(void)configureOverviewCell:(DetailOverviewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.subjectLabel.text = [self.viewModel titleOfSubject];
    cell.lecturerLabel.text = [self.viewModel nameOfLecturer];
    cell.venueLabel.text = [self.viewModel nameOfVenue];
}

-(void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.viewModel titleForDayAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.viewModel subtitleAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 150.0f;
        }
    } else if (indexPath.section == 0)
        return 85.0f;
    
    return 45.0f;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
