//
//  Days.h
//  
//
//  Created by Vinod Rathod on 24/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubjectDetails, SubjectTime;

@interface Days : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * dayID;
@property (nonatomic, retain) SubjectDetails *detail;
@property (nonatomic, retain) SubjectTime *time;

@end
