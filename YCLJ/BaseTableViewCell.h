//
//  BaseTableViewCell.h
//  
//
//  Created by Adam on 15/7/31.
//  Copyright (c) 2015年 fule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface BaseTableViewCell : UITableViewCell

+ (NSString *)cellID;
+ (id)newTableCell;

@end
