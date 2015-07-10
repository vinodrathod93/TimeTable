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
    NSUInteger dateComponents = NSCalendarUnitDay;
    NSInteger previousDay = -1;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:dateComponents fromDate:self.startTime];
    NSInteger day = [components day];
    
    if (day != previousDay) {
        return [self.startTime beginningOfDay];
    }
    
    return [self.startTime beginningOfDay];
}
@end
