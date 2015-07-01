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
@property (nonatomic, strong) NSMutableArray *percentLabels;
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
    
    [self.fetchedResultsController performFetch:nil];
    
    
    [self.graphView draw];

}


-(void)layoutGraphViewForIndex:(NSUInteger)index {
    for (SubjectDetails *details in self.fetchedResultsController.fetchedObjects) {
        NSLog(@"%@",details.subject);
        Attendance *attendance = details.attendance;
        NSLog(@"Attended %@",attendance.attended);
        
        NSMutableString *shortFormString = [NSMutableString string];
        NSArray *words = [details.subject componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        for (NSString *word in words) {
            if ([word length] > 0) {
                NSString *firstLetter = [word substringWithRange:[word rangeOfComposedCharacterSequenceAtIndex:0]];
                [shortFormString appendString:[firstLetter uppercaseString]];
            }
            
        }
        
        [self.labels addObject:shortFormString];
        
        
        NSNumber *attendedData = [self calculateAttendancePercentWithTotalLectures:attendance.calculatedLectures andAttendance:attendance.attended];
        
        [self.data addObject:attendedData];
        
        NSString *string = [NSString stringWithFormat:@"%@%%",attendedData];
        [self.percentLabels addObject:string];
            
    }
}


-(NSNumber *)calculateAttendancePercentWithTotalLectures:(NSNumber *)totalLectures andAttendance:(NSNumber *)attendance {
    
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

-(NSNumber *) calculateCanBeMissedWithTotalLectures:(NSNumber *)totalLectures withMinAttendance:(NSNumber *)minAttendance {
    int totalValue = totalLectures.intValue;
    int minValue = minAttendance.intValue;
    
    int compulsoryValue = (minValue * totalValue)/100;
    
    int canBeMissedValue = totalValue - compulsoryValue;
    
    NSLog(@"Compulsory value %d and missed %d",compulsoryValue, canBeMissedValue);
    
    return [NSNumber numberWithInt:canBeMissedValue];
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
    
    if (index > [colors count]) {
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

@end
