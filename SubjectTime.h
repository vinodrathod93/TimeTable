//
//  SubjectTime.h
//  TimeTable
//
//  Created by Vinod Rathod on 22/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days;

@interface SubjectTime : NSManagedObject

@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) Days *day;

@end
