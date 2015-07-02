//
//  UserDashboardViewController.m
//  
//
//  Created by Vinod Rathod on 23/06/15.
//
//

#import "UserDashboardViewController.h"
#import "AppDelegate.h"
#import "SubjectDetails.h"
#import "Attendance.h"

@interface UserDashboardViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *limits;
@property (nonatomic, strong) NSMutableArray *percentLabels;

@property (nonatomic, strong) NSMutableArray *subjectLabels;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation UserDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Dashboard";
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Ok"] style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsPage:)];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    self.graphView.dataSource = self;
    
    
    self.labels = [NSMutableArray array];
    self.percentLabels = [NSMutableArray array];
    self.data = [NSMutableArray array];
    self.limits = [NSMutableArray array];
    self.subjectLabels = [NSMutableArray array];
    
    [self.fetchedResultsController performFetch:nil];
    
    [self layoutGraphViewData];
    [self.graphView draw];
    
    [self.subjectLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Value %@ at Index %lu",obj,(unsigned long)idx);
        CGRect rect;
        
        if (idx == 0) {
            rect = CGRectMake(20, 280, 300, 30);
        } else {
            rect.origin.y += 30;
        }
        
        NSString *string = [NSString stringWithFormat:@"You need to attend another %@ lectures",obj];
        
        [self addSubjectLabelWithRect:rect andText:string];
    }];

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(420, 568);
}


-(void)layoutGraphViewData {
    for (SubjectDetails *details in self.fetchedResultsController.fetchedObjects) {
        NSLog(@"%@",details.subject);
        Attendance *attendance = details.attendance;
        NSLog(@"Attended %@",attendance.attended);
        
        // To make a short form of the subject label, this logic is used
        NSMutableString *shortFormString = [NSMutableString string];
        NSArray *words = [details.subject componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (NSString *word in words) {
            if ([word length] > 0) {
                NSString *firstLetter = [word substringWithRange:[word rangeOfComposedCharacterSequenceAtIndex:0]];
                [shortFormString appendString:[firstLetter uppercaseString]];
            }
            
        }
        
        
        [self.labels addObject:shortFormString];
        
        // Attendance data i.e., attended
        NSNumber *attendedData = [self calculateAttendancePercentWithTotalLectures:attendance.calculatedLectures andAttendance:attendance.attended];
        [self.data addObject:attendedData];
        
        
        // Percent Data
        NSString *string = [NSString stringWithFormat:@"%@%%",attendedData];
        [self.percentLabels addObject:string];
        
        
        // Limits i.e., min. attendance
        NSNumber *limit = [self getAllMinLimitWithAttendance:attendance];
        [self.limits addObject:limit];
        
        
        // calculated and adding remaining no. of lectures
        NSNumber *remainingLectures = [self calculateRemainingOfRequiredLectures:attendance.calculatedLectures withMinAttendance:attendance.minAttendance andAttendedValue:attendance.attended];
        [self.subjectLabels addObject:remainingLectures];
    }
}

-(NSNumber *)getAllMinLimitWithAttendance:(Attendance *)attendance {
    return attendance.minAttendance;
}

-(NSNumber *)calculateAttendancePercentWithTotalLectures:(NSNumber *)totalLectures andAttendance:(NSNumber *)attendance
{
    
    int percent;
    int attendedValue = attendance.intValue;
    int totalLectureValue = totalLectures.intValue;
    
    NSLog(@"attended= %d and totalLecture= %d",attendedValue, totalLectureValue);
    
    if (attendedValue == 0 && totalLectureValue == 0) {
        return [NSNumber numberWithInt:0];
    } else {
        percent = (attendedValue * 100) / totalLectureValue;
    }
    
    
    return [NSNumber numberWithInt:percent];
}

-(NSNumber *) calculateRemainingOfRequiredLectures:(NSNumber *)totalLectures withMinAttendance:(NSNumber *)minAttendance andAttendedValue:(NSNumber *)attended
{
    NSLog(@"Total is %@ and minAtt is %@",totalLectures,minAttendance);
    int totalLecturesValue = totalLectures.intValue;
    int minAttendanceValue = minAttendance.intValue;
    
    float compulsoryAttendingValue = ceilf((minAttendanceValue * totalLecturesValue)/100.0f);
    
    int remainingValue = compulsoryAttendingValue - attended.intValue;
    
    NSLog(@"Compulsory value %f and remaining %d",compulsoryAttendingValue, remainingValue);
    
    return [NSNumber numberWithInt:remainingValue];
}


#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    return [self.labels count];
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_amethystColor],
                  [UIColor gk_emerlandColor],
                  [UIColor gk_sunflowerColor],
                  [UIColor gk_asbestosColor]
                  ];
    
    if (index >= [colors count]) {
        index = index - [colors count];
    }
    return [colors objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (self.graphView.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

-(NSString *)percentTitleForBarAtIndex:(NSInteger)index {
    return [self.percentLabels objectAtIndex:index];
}

- (NSNumber *)limitForBarAtIndex:(NSInteger)index {
    return [self.limits objectAtIndex:index];
}

#pragma mark - Fetched Results Controller

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


- (void)donePressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)settingsPage:(id)sender {
    NSLog(@"Settings");
}


-(void)addSubjectLabelWithRect:(CGRect)rect andText:(NSString *)string {
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = string;
    label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    
    [self.scrollView addSubview:label];
}

@end
