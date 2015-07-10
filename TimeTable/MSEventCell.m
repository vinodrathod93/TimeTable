//
//  MSEventCell.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSEventCell.h"
#import "CalendarEntity.h"


@interface MSEventCell ()

@property (nonatomic, strong) UIView *borderView;

@end

@implementation MSEventCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.0;
        
        self.borderView = [UIView new];
        [self.contentView addSubview:self.borderView];
        
        self.timble_title = [UILabel new];
        self.timble_title.numberOfLines = 0;
        self.timble_title.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timble_title];
        
        self.timble_location = [UILabel new];
        self.timble_location.numberOfLines = 0;
        self.timble_location.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timble_location];
        
        [self updateColors];
        
        CGFloat borderWidth = 2.0;
        CGFloat contentMargin = 2.0;
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(1.0, (borderWidth + 4.0), 1.0, 4.0);
        
        
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(borderWidth));
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
        }];
        
        [self.timble_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(contentPadding.top);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
        }];
        
        
        [self.timble_location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timble_title.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
            
        }];
        
        
        
         
    }
    return self;
}


#pragma mark - UICollectionViewCell

- (void)setSelected:(BOOL)selected
{
    if (selected && (self.selected != selected)) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.025, 1.025);
            self.layer.shadowOpacity = 0.2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    } else if (selected) {
        self.layer.shadowOpacity = 0.2;
    } else {
        self.layer.shadowOpacity = 0.0;
    }
    [super setSelected:selected]; // Must be here for animation to fire
    [self updateColors];
}

#pragma mark -  CalendarEntityCell


-(void)setTimble_entity:(CalendarEntity *)timble_entity {
    _timble_entity = timble_entity;
    self.timble_title.attributedText = [[NSAttributedString alloc] initWithString:timble_entity.subject attributes:[self titleAttributesHighlighted:self.selected]];
    self.timble_location.attributedText = [[NSAttributedString alloc] initWithString:timble_entity.venue attributes:[self subtitleAttributesHighlighted:self.selected]];
    
    NSLog(@"%@",timble_entity.subject);
}

- (void)updateColors
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected];
    self.borderView.backgroundColor = [self borderColor];
    self.timble_title.textColor = [self textColorHighlighted:self.selected];
    self.timble_location.textColor = [self textColorHighlighted:self.selected];
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor colorWithHexString:@"35b1f1"] : [[UIColor colorWithHexString:@"35b1f1"] colorWithAlphaComponent:0.2];
}

- (UIColor *)textColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}

- (UIColor *)borderColor
{
    return [[self backgroundColorHighlighted:NO] colorWithAlphaComponent:1.0];
}

-(void)updateConstraints {
    
    
    [super updateConstraints];
}

@end
