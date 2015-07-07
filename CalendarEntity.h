//
//  CalendarEntity.h
//  
//
//  Created by Vinod Rathod on 06/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CalendarEntity : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * venue;

-(NSDate *)day;
@end
