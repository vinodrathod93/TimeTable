//
//  AttendanceCell.h
//  TimeTable
//
//  Created by Vinod Rathod on 19/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *attendedValue;
@property (weak, nonatomic) IBOutlet UILabel *missedValue;
@end
