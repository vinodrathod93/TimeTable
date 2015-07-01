//
//  Days.h
//  
//
//  Created by Vinod Rathod on 02/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendance, SubjectDetails, SubjectTime;

@interface Days : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * dayID;
@property (nonatomic, retain) Attendance *attendanceToDay;
@property (nonatomic, retain) SubjectDetails *detail;
@property (nonatomic, retain) SubjectTime *time;

@end
