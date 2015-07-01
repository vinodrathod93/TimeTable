//
//  Attendance.h
//  
//
//  Created by Vinod Rathod on 02/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days, SubjectDetails;

@interface Attendance : NSManagedObject

@property (nonatomic, retain) NSNumber * attended;
@property (nonatomic, retain) NSNumber * calculatedLectures;
@property (nonatomic, retain) NSNumber * canbeMissed;
@property (nonatomic, retain) NSNumber * missed;
@property (nonatomic, retain) NSNumber * totalLecture;
@property (nonatomic, retain) NSNumber * minAttendance;
@property (nonatomic, retain) Days *dayInAttendance;
@property (nonatomic, retain) SubjectDetails *subjectAttendance;

@end
