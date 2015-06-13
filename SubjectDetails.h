//
//  SubjectDetails.h
//  TimeTable
//
//  Created by Vinod Rathod on 13/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days;

@interface SubjectDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * semLength;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSOrderedSet *days;
@end

@interface SubjectDetails (CoreDataGeneratedAccessors)

- (void)insertObject:(Days *)value inDaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDaysAtIndex:(NSUInteger)idx;
- (void)insertDays:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDaysAtIndex:(NSUInteger)idx withObject:(Days *)value;
- (void)replaceDaysAtIndexes:(NSIndexSet *)indexes withDays:(NSArray *)values;
- (void)addDaysObject:(Days *)value;
- (void)removeDaysObject:(Days *)value;
- (void)addDays:(NSOrderedSet *)values;
- (void)removeDays:(NSOrderedSet *)values;
@end
