//
//  ViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 19/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)closeTapped:(id)sender;

@property (nonatomic, strong) UILabel *noResultsLabel;
@end

