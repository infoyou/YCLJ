//
//  YCHouseObject.m
//  YCLJSDK
//
//  Created by Adam on 17/4/6.
//  Copyright ©YC. All rights reserved.
//

#import "YCHouseObject.h"
#import "ZTCommonUtils.h"

@implementation YCHouseObject

- (void)setHouseModel:(YCHouseModel *)houseModel
{
    
    _houseModel = houseModel;
    
    // 0, upload icon
    CGFloat imgUploadX = 20;
    CGFloat imgUploadY = 10;
    NSInteger imgUploadW = 20;
    NSInteger imgUploadH = 20;
    _imgUploadF = CGRectMake(imgUploadX, imgUploadY + 1, imgUploadW, imgUploadH);

    // 1, title
    CGFloat titleX = 40;
    CGFloat titleY = imgUploadY;
    CGFloat titleW = 48;
    CGFloat titleH = 22;
    _labTitleF = CGRectMake(titleX, titleY, titleW, titleH);

    // 2, date
    CGFloat authorX = 111;
    CGFloat authorY = titleY;
    CGFloat authorW = 177;
    CGFloat authorH = 22;
    _labDateF = CGRectMake(authorX, authorY, authorW, authorH);

    // 3, delete
    CGFloat imgDelX = YC_SCREEN_WIDTH/2;
    CGFloat imgDelY = titleY;
    NSInteger imgDelW = 20;
    NSInteger imgDelH = 20;
    _imgDeleteF = CGRectMake(imgDelX, imgDelY, imgDelW, imgDelH);
    
    _btnDeleteF =  CGRectMake(imgDelX-10, imgDelY-10, imgDelW + 20, imgDelH + 20);
    
    // 4, copy solution
    CGFloat solutionW = [ZTCommonUtils calcuViewWidth:@"生成拆改图" font:kHouse_Copy_Font];
    CGFloat solutionX = YC_SCREEN_WIDTH - solutionW - 20;
    CGFloat solutionY = titleY;
    CGFloat solutionH = 22;
    _labCopySolutionF = CGRectMake(solutionX, solutionY, solutionW, solutionH);
    _btnCopySolutionF = CGRectMake(solutionX - 10, solutionY - 10, solutionW + 20, solutionH + 20);
    
    // 5, split line
    _viSplitLineF = CGRectMake(20, CGRectGetMaxY(_labDateF) + kCell_Offset, YC_SCREEN_WIDTH - 20, 0.5);
    
    _cellHeight = CGRectGetMaxY(_viSplitLineF);
}

@end
