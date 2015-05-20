//
//  SubjectDetails.h
//  TimeTable
//
//  Created by Vinod Rathod on 24/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days;

@interface SubjectDetails : NSManagedObject

@property (nonatomic) int16_t semLength;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSSet *days;
@end

@interface SubjectDetails (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Days *)value;
- (void)removeDaysObject:(Days *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
