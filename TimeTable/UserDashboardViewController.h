//
//  UserDashboardViewController.h
//  
//
//  Created by Vinod Rathod on 23/06/15.
//
//

#import <UIKit/UIKit.h>
#import "GraphKit.h"

@interface UserDashboardViewController : UIViewController<GKBarGraphDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GKBarGraph *graphView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *canBeMissedLabel;

@property (assign, nonatomic)NSInteger index;
@end
