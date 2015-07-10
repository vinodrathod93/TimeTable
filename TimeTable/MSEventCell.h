//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarEntity;

@interface MSEventCell : UICollectionViewCell

@property (nonatomic, weak) CalendarEntity *timble_entity;

@property (nonatomic, strong) UILabel *timble_title;
@property (nonatomic, strong) UILabel *timble_location;

@end
