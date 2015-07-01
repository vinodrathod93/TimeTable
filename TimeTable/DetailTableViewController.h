//
//  DetailTableViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewModel.h"
#import "SemLength.h"

@interface DetailTableViewController : UITableViewController

@property (strong, nonatomic) DetailViewModel *viewModel;
@property (assign, nonatomic) BOOL editingDone;
@property (strong, nonatomic) SemLength *semLength;

- (IBAction)editButtonPressed:(id)sender;

@end
