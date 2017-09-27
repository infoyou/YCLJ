//
//  YCHouseOwnerView.h
//  YCLJSDK
//
//  Created by Adam on 2017/8/2.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCOwnerModel;

#define CELL_SECTION_H   90.f

@protocol HouseListOwnerViewDelegate <NSObject>

- (void)doShareOwner:(NSString *)workOrderId;
- (void)doSendOwner:(NSString *)mobile;

@end

@interface YCHouseOwnerView : UIView

@property(nonatomic,strong) UIImageView *imgMobile;
@property(nonatomic,strong) UILabel *labMobile;
@property(nonatomic,strong) UILabel *labName;
@property(nonatomic,strong) UILabel *labArea;

@property(nonatomic,strong) UIImageView *imgAddress;
@property(nonatomic,strong) UILabel *labAddress;

@property(nonatomic,strong) UIImageView *imgArea;
@property(nonatomic,strong) UIImageView *imgShare;
@property(nonatomic,strong) UIButton *btnShare;
@property(nonatomic,strong) UIButton *btnSend;

@property(nonatomic,assign) id<HouseListOwnerViewDelegate> delegate;

@property(nonatomic,strong) YCOwnerModel *userModel;

@end

