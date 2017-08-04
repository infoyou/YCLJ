//
//  YCHouseOwnerView.m
//  YCLJSDK
//
//  Created by Adam on 2017/8/2.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCHouseOwnerView.h"
#import "YCOwnerModel.h"

@implementation YCHouseOwnerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *sectionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, CELL_SECTION_H)];
        sectionBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:sectionBgView];
        
        NSInteger fontSize = 15;
        
        // name
        _labName = [[UILabel alloc] init];
        _labName.font = FontBold(fontSize);
        _labName.textColor = HEX_COLOR(@"0x333333");
        [sectionBgView addSubview:_labName];
        
        // mobile img
        _imgMobile = [[UIImageView alloc] init];
        _imgMobile.image = GetImageByName(@"ycMobile");
        [sectionBgView addSubview:_imgMobile];
        
        // mobile label
        _labMobile = [[UILabel alloc] init];
        _labMobile.font = Font(fontSize);
        _labMobile.textColor = HEX_COLOR(@"0x666666");
        [sectionBgView addSubview:_labMobile];
        
        // address
        _imgAddress = [[UIImageView alloc] init];
        _imgAddress.image = GetImageByName(@"ycAddress");
        [sectionBgView addSubview:_imgAddress];
        
        _labAddress = [[UILabel alloc] init];
        _labAddress.font = Font(fontSize);
        _labAddress.textColor = HEX_COLOR(@"0x666666");
        [sectionBgView addSubview:_labAddress];
        
        // area
        _imgArea = [[UIImageView alloc] init];
        _imgArea.image = GetImageByName(@"ycArea");
        [sectionBgView addSubview:_imgArea];
        
        _labArea = [[UILabel alloc] init];
        _labArea.font = Font(fontSize);
        _labArea.textColor = HEX_COLOR(@"0x666666");
        [sectionBgView addSubview:_labArea];
        
        // share
        _imgShare = [[UIImageView alloc] init];
        _imgShare.image = GetImageByName(@"ycShare");
        [sectionBgView addSubview:_imgShare];
        
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShare addTarget:self action:@selector(clickShareOwner) forControlEvents:UIControlEventTouchUpInside];
        [sectionBgView addSubview:_btnShare];
        
        // 发送业主
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.backgroundColor = HEX_COLOR(@"0xDE3031");
        [_btnSend setTitle:@"发送业主" forState:UIControlStateNormal];
        _btnSend.titleLabel.textColor = HEX_COLOR(@"0xffffff");
        _btnSend.titleLabel.font = Font(fontSize + 1);
        [_btnSend addTarget:self action:@selector(clickSendOwner) forControlEvents:UIControlEventTouchUpInside];
        
        _btnSend.layer.masksToBounds = YES;
        _btnSend.layer.cornerRadius = 5.f;
        [sectionBgView addSubview:_btnSend];
        
        // line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_SECTION_H - 0.5, YC_SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = HEX_COLOR(@"0xE8E8E8");
        [sectionBgView addSubview:lineView];
    }
    
    return self;
}

- (void)setUserModel:(YCOwnerModel *)userModel
{

    _userModel = userModel;
    
    NSInteger offsetW = 3;
    CGFloat nameY = 20;

    // name
    _labName.frame = CGRectMake(17, nameY, YC_SCREEN_WIDTH/6, 20);
    _labName.text = userModel.name;
    
    // mobile
    CGFloat mobileX = YC_SCREEN_WIDTH/6;
    _imgMobile.frame = CGRectMake(mobileX - 20 - offsetW, nameY, 20, 20);

    _labMobile.frame = CGRectMake(mobileX, nameY, YC_SCREEN_WIDTH/5, 20);
    _labMobile.text = userModel.mobile;

    // address
    CGFloat addressX = 40;
    CGFloat addressY = 50;
    _imgAddress.frame = CGRectMake(addressX - 20 - offsetW, addressY, 20, 20);
    _labAddress.frame = CGRectMake(addressX, addressY, YC_SCREEN_WIDTH/2-40, 20);
    _labAddress.text = [userModel.address stringByReplacingPercentEscapes];

    // area
    CGFloat areaX = YC_SCREEN_WIDTH/2 + 20;
    _imgArea.frame = CGRectMake(areaX - 20 - offsetW, addressY, 20, 20);

    NSString *strArea = userModel.area;
    if (![userModel.area hasSuffix:@"㎡"])
    {
        strArea = [NSString stringWithFormat:@"面积: %@㎡", userModel.area];
    }
    _labArea.text = strArea;
    CGFloat labAreaW = [ZTCommonUtils calcuViewWidth:_labArea.text font:_labArea.font];
    _labArea.frame = CGRectMake(areaX, addressY, labAreaW, 20);

    // share
    CGFloat shareX = YC_SCREEN_WIDTH - 40;
    CGFloat shareY = 40;
    CGFloat shareW = 20;
    CGFloat shareH = 20;
    _imgShare.frame = CGRectMake(shareX, shareY, shareW, shareH);

    _btnShare.frame = CGRectMake(shareX-10, shareY-10, shareW + 20, shareH + 20);
    
    // 发送业主
    CGFloat sendW = 90;
    CGFloat sendX = YC_SCREEN_WIDTH - sendW - 72;
    CGFloat sendY = 37;
    _btnSend.frame = CGRectMake(sendX, sendY, 90, 28);
}

- (void)clickShareOwner
{
    if ([self.delegate respondsToSelector:@selector(doShareOwner)]) {
        [self.delegate doShareOwner];
    }
}

- (void)clickSendOwner
{
    if ([self.delegate respondsToSelector:@selector(doSendOwner)]) {
        [self.delegate doSendOwner];
    }
}

@end
