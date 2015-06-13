//
//  DetailViewModel.m
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "DetailViewModel.h"
#import "Days.h"
#import "SubjectTime.h"

@interface DetailViewModel()


@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, strong) NSString *subjectLecturer;
@property (nonatomic, strong) NSString *subjectVenue;
@property (nonatomic, strong) NSString *subjectStartTime;
@property (nonatomic, strong) NSString *subjectEndTime;

//@property (nonatomic, assign) NSInteger numberOfDays;

@end

@implementation DetailViewModel

- (id)initWithModel:(SubjectDetails *)model
{
    self = [super init];
    if (self) {
        
        self.model = model;
        NSLog(@"Model is %@",model);
        self.subjectName = model.subject;
        self.subjectLecturer = model.teacher;
        self.subjectVenue = model.venue;
        self.numberOfDays = model.days.count;
        NSLog(@"Days %lu",(unsigned long)[model.days count]);
        
    }
    return self;
}

// Private Method
-(Days *)dayAtIndex:(NSInteger)index {
    
    return [self.model.days objectAtIndex:index];
}

// Public Methods

-(NSString *)titleForDayAtIndex:(NSInteger)index {
    return [[self dayAtIndex:index] day];
}

-(NSString *)subtitleAtIndex:(NSInteger)index {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    SubjectTime *time = [[self dayAtIndex:index]time];
    
    NSString *formattedTime = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:time.start], [dateFormatter stringFromDate:time.end]];
    
    return formattedTime;
}

-(NSString *)titleOfSubject {
    return [self.model subject];
}

-(NSString *)nameOfLecturer {
    return [self.model teacher];
}
-(NSString *)nameOfVenue {
    return [self.model venue];
}


@end
