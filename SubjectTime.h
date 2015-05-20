//
//  SubjectTime.h
//  
//
//  Created by Vinod Rathod on 24/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Days;

@interface SubjectTime : NSManagedObject

@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) Days *day;

@end
