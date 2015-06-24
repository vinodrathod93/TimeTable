//
//  Days.h
//  TimeTable
//
//  Created by Vinod Rathod on 22/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendance, SubjectDetails, SubjectTime;

@interface Days : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * dayID;
@property (nonatomic, retain) SubjectDetails *detail;
@property (nonatomic, retain) SubjectTime *time;
@property (nonatomic, retain) Attendance *attendanceToDay;

@end
