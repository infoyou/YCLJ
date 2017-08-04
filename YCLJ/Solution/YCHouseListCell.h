//
//  YCHouseListCell.h
//  
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "ZTBaseTableViewCell.h"

@class YCHouseModel;
@class YCHouseObject;
@protocol HouseListCellDelegate;

@interface YCHouseListCell : ZTBaseTableViewCell

@property (nonatomic, strong) YCHouseObject *houseObject;
@property (nonatomic, weak) id <HouseListCellDelegate> delegate;

+ (NSString *)cellID;

@end

@protocol HouseListCellDelegate <NSObject>

- (void)handleCopy:(YCHouseModel *)houseModel;
- (void)handleDel:(YCHouseListCell *)cell houseModel:(YCHouseModel *)houseModel;

@end
