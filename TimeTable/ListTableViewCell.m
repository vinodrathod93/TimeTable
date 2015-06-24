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
    
    self.subjectLabel.text = detail.subject;
    self.teacherLabel.text = detail.teacher;
    
    
    if (detail.days.count == 0) {
        NSLog(@"Array nil");
    } else if (detail.days.count == 1) {
        self.daysOfClass.text = [NSString stringWithFormat:@"%lu Day",(unsigned long)detail.days.count];
    } else {
        self.daysOfClass.text = [NSString stringWithFormat:@"%lu Days",(unsigned long)detail.days.count];
    }
    
    
//    self.timing.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:singleDay.time.start],[dateFormatter stringFromDate:singleDay.time.end]];
    

    
}

@end
