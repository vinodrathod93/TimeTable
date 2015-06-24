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
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation UserDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor gk_cloudsColor];

    
    self.labels = [NSMutableArray array];
    self.data = [NSMutableArray array];
    
    [self.fetchedResultsController performFetch:nil];
    
    
    
    switch (self.index) {
        case 0:
            self.message.text = @"Lectures Attended.";
            [self layoutGraphViewForIndex:self.index];
            break;
            
        case 1:
            self.message.text = @"Lectures Missed.";
            [self layoutGraphViewForIndex:self.index];
            break;
            
        case 2:
            self.message.text = @"Lectures Can be Missed.";
            [self layoutGraphViewForIndex:self.index];
            break;
            
        default:
            break;
    }
    
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
        
        if (index == 0) {
            [self.data addObject:attendance.attended];
        } else if (index == 1) {
            [self.data addObject:attendance.missed];
        } else if (index == 2) {
            [self.data addObject:attendance.canbeMissed];
        }
        
    }
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

@end
