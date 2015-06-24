//
//  SelectedDayCell.m
//  TimeTable
//
//  Created by Vinod Rathod on 20/04/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "SelectedDayCell.h"

@implementation SelectedDayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return self;
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // configure up some interesting display properties inside the cell
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 19, 117, 21)];
    _dayLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
    _dayLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 19, 147, 21)];
    _timeLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];

    [self.contentView addSubview:_dayLabel];
    [self.contentView addSubview:_timeLabel];
    
    return self;
}
@end
