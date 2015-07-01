//
//  SemLength.h
//  
//
//  Created by Vinod Rathod on 02/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SemLength : NSManagedObject

@property (nonatomic, retain) NSDate * semEndDate;
@property (nonatomic, retain) NSDate * semStartDate;

@end
