//
//  Attendance.h
//  TimeTable
//
//  Created by Vinod Rathod on 22/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days, SubjectDetails;

@interface Attendance : NSManagedObject

@property (nonatomic, retain) NSNumber * attended;
@property (nonatomic, retain) NSNumber * canbeMissed;
@property (nonatomic, retain) NSNumber * missed;
@property (nonatomic, retain) NSNumber * totalLecture;
@property (nonatomic, retain) SubjectDetails *subjectAttendance;
@property (nonatomic, retain) Days *dayInAttendance;

@end
