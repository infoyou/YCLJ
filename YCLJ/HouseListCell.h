//
//  HouseListCell.h
//  
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "BaseTableViewCell.h"

@class HouseModel;
@class HouseObject;
@protocol HouseListCellDelegate;

@interface HouseListCell : BaseTableViewCell

@property (nonatomic, strong) HouseObject *houseObject;
@property (nonatomic, weak) id <HouseListCellDelegate> delegate;

+ (NSString *)cellID;

@end

@protocol HouseListCellDelegate <NSObject>

- (void)handleCopy:(HouseModel *)houseModel;
- (void)handleDel:(HouseListCell *)cell houseModel:(HouseModel *)houseModel;

@end
