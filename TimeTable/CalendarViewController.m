//
//  CalendarViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 05/07/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "CalendarViewController.h"
#import "MSCollectionViewCalendarLayout.h"
#import "SubjectDetails.h"
#import "Days.h"
#import "SubjectTime.h"
#import "AppDelegate.h"
#import "CalendarEntity.h"

#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

@interface CalendarViewController ()<MSCollectionViewDelegateCalendarLayout,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;

@property (nonatomic, strong) CalendarEntity *calendarEntity;
@property (nonatomic, strong) NSFetchedResultsController *subjectFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *calendarFetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CalendarViewController

NSString * const EventCellReuseIdentifier = @"EventCellReuseIdentifier";
NSString * const DayColumnHeaderReuseIdentifier = @"DayColumnHeaderReuseIdentifier";
NSString * const TimeRowHeaderReuseIdentifier = @"TimeRowHeaderReuseIdentifier";


- (id)init
{
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.collectionViewCalendarLayout.sectionWidth = self.view.frame.size.width - 2 * 33.0f;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:EventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:DayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:TimeRowHeaderReuseIdentifier];
    
    // Decoration View
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    
    [self.subjectFetchedResultsController performFetch:nil];
    [self deleteAllObjects];
    [self setCalendarEntityForMainView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // On iPhone, adjust width of sections on interface rotation. No necessary in horizontal layout (iPad)
    if (self.collectionViewCalendarLayout.sectionLayoutType == MSSectionLayoutTypeVerticalTile) {
        [self.collectionViewCalendarLayout invalidateLayoutCache];
        // These are the only widths that are defined by default. There are more that factor into the overall width.
        self.collectionViewCalendarLayout.sectionWidth = (CGRectGetWidth(self.collectionView.frame) - self.collectionViewCalendarLayout.timeRowHeaderWidth - self.collectionViewCalendarLayout.contentMargin.right);
        [self.collectionView reloadData];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.collectionViewCalendarLayout invalidateLayoutCache];
//    
//    [self.collectionView reloadData];
//    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
}

-(void)setCalendarEntityForMainView {
    
    NSLog(@"%lu",(unsigned long)self.subjectFetchedResultsController.fetchedObjects.count);
    
   [self.subjectFetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(SubjectDetails *details, NSUInteger idx, BOOL *stop) {
       NSLog(@"%@",details);
       
       [details.days enumerateObjectsUsingBlock:^(Days *day, NSUInteger idx, BOOL *stop) {
           
           SubjectTime *time = day.time;
           
           
           [self saveCalendarEntityWithSubject:details.subject andVenue:details.venue alongWithTime:time];
       }];
   }];
    
}


-(void)saveCalendarEntityWithSubject:(NSString *)subject andVenue:(NSString *)venue alongWithTime:(SubjectTime *)time {
    self.calendarEntity = [NSEntityDescription insertNewObjectForEntityForName:@"CalendarEntity" inManagedObjectContext:self.managedObjectContext];
    self.calendarEntity.subject = subject;
    self.calendarEntity.venue = venue;
    self.calendarEntity.startTime = time.start;
    self.calendarEntity.endTime = time.end;
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


-(void)deleteAllObjects {

    for (NSManagedObject *entity in self.calendarFetchedResultsController.fetchedObjects) {
        NSLog(@"%@",entity);
        [self.managedObjectContext deleteObject:entity];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}
#pragma mark - NSFetchedResultsControllerDelegate

-(NSFetchedResultsController *)calendarFetchedResultsController {
    if (_calendarFetchedResultsController != nil) {
        return _calendarFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CalendarEntity" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"startTime"
                                        ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    _calendarFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"day" cacheName:nil];
    _calendarFetchedResultsController.delegate = self;
    
    
    NSError *error = nil;
    if (![self.calendarFetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _calendarFetchedResultsController;
}

-(NSFetchedResultsController *)subjectFetchedResultsController {
    if (_subjectFetchedResultsController != nil) {
        return _subjectFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubjectDetails" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"Days", nil]];
    [fetchRequest setIncludesSubentities:YES];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"venue"
                                        ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    _subjectFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _subjectFetchedResultsController.delegate = self;
    
     
    NSError *error = nil;
    if (![self.subjectFetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _subjectFetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"%lu",(unsigned long)self.calendarFetchedResultsController.sections.count);
    return self.calendarFetchedResultsController.sections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [(id <NSFetchedResultsSectionInfo>)self.calendarFetchedResultsController.sections[section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EventCellReuseIdentifier forIndexPath:indexPath];
    
    NSLog(@"%@",[self.calendarFetchedResultsController objectAtIndexPath:indexPath]);
    cell.timble_entity = [self.calendarFetchedResultsController objectAtIndexPath:indexPath];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [[day beginningOfDay] isEqualToDate:[currentDay beginningOfDay]];
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}


#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.calendarFetchedResultsController.sections objectAtIndex:section];
    CalendarEntity *event = [sectionInfo.objects firstObject];
    
    NSLog(@"%@",event.day);
    return event.day;
    
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarEntity *event = [self.calendarFetchedResultsController objectAtIndexPath:indexPath];
    return event.startTime;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarEntity *event = [self.calendarFetchedResultsController objectAtIndexPath:indexPath];
    return event.endTime;
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return [NSDate date];
}


@end
