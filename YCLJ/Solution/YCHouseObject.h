//
//  YCHouseObject.h
//  YCLJSDK
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YCHouseModel.h"

#define kCell_Offset                    10
#define kExhibit_Headset_W              13.5
#define kExhibit_Headset_H              12
#define kHouse_Type_Font                Font(14)
#define kHouse_Date_Font                Font(13)
#define kHouse_Copy_Font                Font(14)

/**
 CommentsCellFrame
 */
@class YCHouseObject;

@interface YCHouseObject : NSObject

@property (nonatomic, assign) CGRect imgUploadF;
@property (nonatomic, assign) CGRect labTitleF;
@property (nonatomic, assign) CGRect imgDeleteF;
@property (nonatomic, assign) CGRect btnDeleteF;
@property (nonatomic, assign) CGRect labDateF;
@property (nonatomic, assign) CGRect labCopySolutionF;
@property (nonatomic, assign) CGRect btnCopySolutionF;
@property (nonatomic, assign) CGRect viSplitLineF;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) YCHouseModel *houseModel;


@end
