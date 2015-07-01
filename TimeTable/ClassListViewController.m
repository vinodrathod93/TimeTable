//
//  ClassListViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 23/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "ClassListViewController.h"
#import "DetailTableViewController.h"
#import "UserDashboardViewController.h"
#import "ListTableViewCell.h"
#import "NewClassTableViewController.h"
#import "MainDashBoardPageController.h"
#import "CCMPopupTransitioning.h"
#import "CCMPopupSegue.h"
#import "SemPopupViewController.h"

#import "AppDelegate.h"

@interface ClassListViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong)NSFetchedResultsController *semFetchedResultsController;


@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (weak) UIViewController *popupController;
@property (nonatomic, strong)NSArray *subjectDetailResults;

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (NSString *family in [UIFont familyNames]) {
//        NSLog(@"   ----%@----",family);
//        
//        for (NSString *font in [UIFont fontNamesForFamilyName:family]) {
//            NSLog(@"        %@",font);
//        }
//    }
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [self.fetchedResultsController performFetch:nil];
    [self.semFetchedResultsController performFetch:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAttending:) name:@"studentAttending" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotAttending:) name:@"studentNotAttending" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleHoliday:) name:@"studentHaveHoliday" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleExtraCurricular:) name:@"studentHaveExtraCurricular" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.semFetchedResultsController performFetch:nil];
    
    if (_semFetchedResultsController.fetchedObjects.count == 0) {
        SemPopupViewController *presentingController = [self.storyboard instantiateViewControllerWithIdentifier:@"popupController"];
        CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
        if (self.view.bounds.size.height < 420) {
            popup.destinationBounds = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.height-20) * .75, [UIScreen mainScreen].bounds.size.height-20);
        } else {
            popup.destinationBounds = CGRectMake(0, 0, 300, 415);
        }
        popup.presentedController = presentingController;
        popup.presentingController = self;
        self.popupController = presentingController;
        
        
        // Saving the entity of semlength in coredata.
        self.semLength = [NSEntityDescription insertNewObjectForEntityForName:@"SemLength" inManagedObjectContext:self.managedObjectContext];
        presentingController.semLengthModel = self.semLength;
        
        [self presentViewController:presentingController animated:YES completion:nil];
    }
    
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.view layoutIfNeeded];
    if (size.height < 420) {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, (size.height-20) * .75, size.height-20);
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:[coordinator transitionDuration] animations:^{
            self.popupController.view.bounds = CGRectMake(0, 0, 300, 400);
            [self.view layoutIfNeeded];
        }];
    }
}


- (IBAction)addClassEntries:(id)sender {
    NewClassTableViewController *newClassVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newClass"];
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:newClassVC];
    
    self.subjectDetailsModel = [NSEntityDescription insertNewObjectForEntityForName:@"SubjectDetails" inManagedObjectContext:self.managedObjectContext];
    newClassVC.subjectDetailsModel = self.subjectDetailsModel;
    newClassVC.semLength = self.semFetchedResultsController.fetchedObjects[0];
    
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"listCells";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SubjectDetails *detail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"Attended ----> %@",detail.attendance.attended);
    
    NSLog(@"subject details ---->>>>>%@", detail.subject);
    [cell configureCellForEntry:detail];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 83.0f;
    }
    
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectDetails *details = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Attendance *attendance = details.attendance;
    [self.managedObjectContext deleteObject:attendance];
    
    for (SubjectTime *time in details.days) {
        [self.managedObjectContext deleteObject:time];
    }
    
    for (Days *day in details.days) {
        [self.managedObjectContext deleteObject:day];
    }
    
    
    
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    for (UILocalNotification *notification in allNotifications) {
        NSDictionary *currentUserInfo = notification.userInfo;
        NSString *uidString = [currentUserInfo objectForKey:@"uid"];
        
        if ([uidString isEqualToString:details.subject]) {
            [[UIApplication sharedApplication]cancelLocalNotification:notification];
        }
    }
    
    [self.managedObjectContext deleteObject:details];
    
    
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - Fetched Results Controller
#pragma mark - 

-(NSFetchedResultsController *)semFetchedResultsController {
    if (_semFetchedResultsController !=nil) {
        return _semFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SemLength" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"semStartDate"
                                        ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _semFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _semFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.semFetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _semFetchedResultsController;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubjectDetails" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"venue"
                                        ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
   
}



-(DetailViewModel *)detailViewAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewModel *viewModel = [[DetailViewModel alloc]initWithModel:[self subjectDetailAtIndexPath:indexPath]];
    
    return viewModel;
}

-(SubjectDetails *)subjectDetailAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", [self.fetchedResultsController objectAtIndexPath:indexPath]);
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        DetailTableViewController *detailVC = segue.destinationViewController;
        detailVC.viewModel = [self detailViewAtIndexPath:indexPath];
        detailVC.semLength = self.semFetchedResultsController.fetchedObjects[0];
    }
    
}
- (IBAction)pressedOnDashboard:(id)sender {
    
    UserDashboardViewController *dashboardVC = [[UserDashboardViewController alloc]initWithNibName:@"UserDashboardViewController" bundle:nil];
    
    
//    MainDashBoardPageController *dashVC = [[MainDashBoardPageController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:dashboardVC];
    [self presentViewController:navVC animated:YES completion:nil];
    
}

#pragma mark - Handle Notification Action

-(void)handleAttending:(NSNotification *)notification {
    
    __block NSUInteger value;
    __block NSError *error = nil;
    
    NSLog(@"fetched Results %@",self.subjectDetailResults);
    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SubjectDetails *details = obj;
        
        NSString *receivedSubject = [notification.userInfo objectForKey:@"uid"];
        
        if ([receivedSubject isEqual:details.subject]) {
            value =  [details.attendance.attended intValue];
            NSLog(@"Value is %lu",(unsigned long)value);
            
            value++;
            
            details.attendance.attended = [NSNumber numberWithInteger:value];
            NSLog(@"Attendance is %@",details.attendance);
            
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Saving changes failed %@",error);
            }
            
        }
    }];
    
    
    

}

-(void)handleNotAttending:(NSNotification *)notification {
    
    NSLog(@"Not Attending");
    
    __block int missedValue;
    __block NSError *error = nil;
    
    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SubjectDetails *details = obj;
        
        NSString *receivedSubject = [notification.userInfo objectForKey:@"uid"];
        
        if ([receivedSubject isEqual:details.subject]) {
            missedValue =  [details.attendance.missed intValue];
            NSLog(@"Value is %lu",(unsigned long)missedValue);
            
            missedValue++;
            
            details.attendance.missed = [NSNumber numberWithInteger:missedValue];
            NSLog(@"Attendance is %@",details.attendance);
            
            if (details.attendance.calculatedLectures.intValue != 0) {
                int calculatedValue = details.attendance.totalLecture.intValue - 1;
                
                details.attendance.calculatedLectures = [NSNumber numberWithInt:calculatedValue];
            }
            
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Saving changes failed %@",error);
            }
            
        }
    }];
    
}

-(void)handleHoliday:(NSNotification *)notification {
    
    NSLog(@"Holiday");
    
    __block int value;
    __block NSError *error = nil;
    
    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SubjectDetails *details = obj;
        
        NSString *receivedSubject = [notification.userInfo objectForKey:@"uid"];
        
        if ([receivedSubject isEqual:details.subject]) {
            value =  [details.attendance.calculatedLectures intValue];
            NSLog(@"Value is %lu",(unsigned long)value);
            
            value--;
            
            details.attendance.calculatedLectures = [NSNumber numberWithInteger:value];
            NSLog(@"Attendance is %@",details.attendance);
            
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Saving changes failed %@",error);
            }
            
        }
    }];
    
    
}

-(void)handleExtraCurricular:(NSNotification *)notification {
    [self handleAttending:notification];
    
}



@end
