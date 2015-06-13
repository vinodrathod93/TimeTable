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
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"hh:mm a"];
    
    self.subjectLabel.text = detail.subject;
    self.teacherLabel.text = detail.teacher;
    
//    NSArray *array = [detail.days allObjects];
//    NSLog(@"All Days %@",array);
    Days *singleDay;
    
    if (detail.days.count == 0) {
        NSLog(@"Array nil");
    } else {
        NSLog(@"ARRAY IS ---->>>>%@",[detail.days objectAtIndex:0]);
        
//#warning - when the day is nil, this line will throw an error objectAtIndex:0 for nil array.
        singleDay = [detail.days objectAtIndex:0];
    }
    
    
//    self.timing.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:singleDay.time.start],[dateFormatter stringFromDate:singleDay.time.end]];
    

    self.daysOfClass.text = [NSString stringWithFormat:@"%@",singleDay.day];
}

@end
