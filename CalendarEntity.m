//
//  CalendarEntity.m
//  
//
//  Created by Vinod Rathod on 06/07/15.
//
//

#import "CalendarEntity.h"


@implementation CalendarEntity

@dynamic subject;
@dynamic startTime;
@dynamic endTime;
@dynamic venue;


-(NSDate *)day {
    return [self.startTime beginningOfDay];
}
@end
