//
//  HouseListCell.h
//  
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "BaseTableViewCell.h"

#define kCell_Height                   50
#define kUser_Name_Font                Font(14)
#define kUser_Date_Font                Font(13)

@class UserModel;

@interface UserListCell : BaseTableViewCell

@property (nonatomic, strong) UserModel *userModel;

+ (NSString *)cellID;
+ (CGFloat)cellHeight;

@end
