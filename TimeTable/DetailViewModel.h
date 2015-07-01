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

@property (nonatomic, assign) NSInteger numberOfDays;
@property (nonatomic, strong) SubjectDetails *model;

-(NSString *)titleForDayAtIndex:(NSInteger)index;
-(NSString *)subtitleAtIndex:(NSInteger)index;


-(NSString *)titleOfSubject;
-(NSString *)nameOfLecturer;
-(NSString *)nameOfVenue;
-(NSString *)valueOfMinAttendance;

-(NSString *)missedValueInAttendance;
-(NSString *)attendedValueInAttendance;

-(id)initWithModel:(SubjectDetails *)model;

@end
