//
//  ListTableViewCell.m
//  TimeTable
//
//  Created by Vinod Rathod on 23/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "ListTableViewCell.h"
#import "Days.h"
#import "SubjectTime.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForEntry:(SubjectDetails *)detail {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    self.subjectLabel.text = detail.subject;
    self.teacherLabel.text = detail.teacher;
    self.classroomLabel.text = detail.venue;
    
    NSArray *array = [detail.days allObjects];
    Days *singleDay = [array objectAtIndex:0];
    self.timing.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:singleDay.time.start],[dateFormatter stringFromDate:singleDay.time.end]];
}

@end
