//
//  ViewController.m
//  TimeTable
//
//  Created by Vinod Rathod on 19/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "ViewController.h"
#import "SubjectDetails.h"

@interface ViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBar.delegate = self;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    _noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 200, 30)];
    [self.view addSubview:_noResultsLabel];
    _noResultsLabel.text = @"No Results";
    [_noResultsLabel setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSError *error;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        
        NSLog(@"Error in search %@, %@", error, [error userInfo]);
        
    } else {
        
        [self.tableview reloadData];
        [self.searchBar resignFirstResponder];
        
        [_noResultsLabel setHidden:_fetchedResultsController.fetchedObjects.count > 0];
        
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SubjectDetails *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = info.subject;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                 info.teacher, info.venue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - fetchedResultsController

// Change this value to experiment with different predicates
#define SEARCH_TYPE 0


- (NSFetchedResultsController *)fetchedResultsController {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SubjectDetails" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"subject" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSArray *queryArray;
    
    if ([self.searchBar.text rangeOfString:@":"].location != NSNotFound) {
        
        queryArray = [self.searchBar.text componentsSeparatedByString:@":"];
        
    }
    
    NSLog(@"search is %@", self.searchBar.text);
    
    NSPredicate *pred;
    
    switch (SEARCH_TYPE) {
            
        case 0: // name contains, case sensitive
            pred = [NSPredicate predicateWithFormat:@"subject CONTAINS %@", self.searchBar.text];
            break;
            
        case 1: // name contains, case insensitive
            pred = [NSPredicate predicateWithFormat:@"subject CONTAINS[c] %@", self.searchBar.text];
            break;
            
        case 2: // name is exactly the same
            pred = [NSPredicate predicateWithFormat:@"subject == %@", self.searchBar.text];
            break;
            
        case 3: { // name begins with
            pred = [NSPredicate predicateWithFormat:@"subject BEGINSWITH[c] %@", self.searchBar.text];
            break;
        }
            
        case 4: { // name matches with, e.g. .*nk
            pred = [NSPredicate predicateWithFormat:@"subject MATCHES %@", self.searchBar.text];
            break;
        }
            
        case 5: { // zip ends with
            
            pred = [NSPredicate predicateWithFormat: @"venue ENDSWITH %@", self.searchBar.text];
            break;
        }
            
//        case 6: { // date is greater than, e.g 2011-12-14
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *date = [dateFormatter dateFromString:self.searchBar.text];
//            
//            pred = [NSPredicate predicateWithFormat: @"details.closeDate > %@", date];
//            
//            break;
//        }
            
        case 7: { // has at least a tag
            
            pred = [NSPredicate predicateWithFormat: @"days.@count > 0"];
            
            break;
        }
            
            
        case 8: // string contains (case insensitive) X and zip is exactly equal to Y. e.g. bank:ville
            pred = [NSPredicate predicateWithFormat:@"(subject CONTAINS[c] %@) AND (teacher CONTAINS[c] %@)", [queryArray objectAtIndex:0], [queryArray objectAtIndex:1]
                    ];
            break;
            
        case 9: // name contains X and zip is exactly equal to Y, e.g. bank:123
            pred = [NSPredicate predicateWithFormat:@"(subject CONTAINS[c] %@) AND (venue == %i)", [queryArray objectAtIndex:0],
                    [[queryArray objectAtIndex:1] intValue]
                    ];
            break;
            
            
            
        case 10: // name contains X and tag name is exactly equal to Y, e.g. bank:tag1
            pred = [NSPredicate predicateWithFormat:@"(subject CONTAINS[c] %@) AND (days == %i)", [queryArray objectAtIndex:0],
                    [[queryArray objectAtIndex:1] intValue]
                    ];
            break;
            
        case 11: { // has a tag whose name contains
            
            pred = [NSPredicate predicateWithFormat: @"ANY days.time.start contains[c] %@", self.searchBar.text];
            break;
        }
            
        default:
            break;
    }
    
    [fetchRequest setPredicate:pred];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil]; // better to not use cache
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
