//
//  DetailTableViewController.h
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewModel.h"

@interface DetailTableViewController : UITableViewController

@property (strong, nonatomic) DetailViewModel *viewModel;

@end
