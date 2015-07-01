//
//  DetailOverviewCell.h
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOverviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *lecturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minAttendanceLabel;
@end
