//
//  DetailViewModel.h
//  TimeTable
//
//  Created by Vinod Rathod on 12/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubjectDetails.h"


@interface DetailViewModel : NSObject

//@property (nonatomic, readonly) NSString *subjectName;
//@property (nonatomic, readonly) NSString *subjectLecturer;
//@property (nonatomic, readonly) NSString *subjectVenue;
//@property (nonatomic, readonly) NSString *subjectStartTime;
//@property (nonatomic, readonly) NSString *subjectEndTime;

@property (nonatomic, assign) NSInteger numberOfDays;
@property (nonatomic, strong) SubjectDetails *model;

-(NSString *)titleForDayAtIndex:(NSInteger)index;
-(NSString *)subtitleAtIndex:(NSInteger)index;


-(NSString *)titleOfSubject;
-(NSString *)nameOfLecturer;
-(NSString *)nameOfVenue;
-(id)initWithModel:(SubjectDetails *)model;

@end
