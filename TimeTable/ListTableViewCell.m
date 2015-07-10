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
#import "POP.h"

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.imageView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        [self.subjectLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        [self.teacherLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        [self.daysOfClass pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
        
        
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 20.f;
        [self.imageView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        [self.subjectLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        [self.teacherLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        [self.daysOfClass pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}


@end
