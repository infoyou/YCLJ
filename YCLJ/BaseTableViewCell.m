//
//  BaseTableViewCell.m
//  
//
//  Created by Adam on 15/7/31.
//  Copyright (c) 2015年 fule. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (NSString *)cellID
{
    return @"cellID";
}

+ (id)newTableCell
{

    return nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
