//
//  YCLJNewUserViewController.m
//  YCLJ
//
//  Created by Adam on 2017/7/26.
//  Copyright © 2017年 YunChuang. All rights reserved.
//

#import "YCLJNewUserViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YCHouseCityChoiceView.h"
#import "YCHouseTypeChoiceView.h"

#define YCLJ_BTN_CITY           @"所在地区 (必填)"
#define YCLJ_BTN_TYPE           @"房屋类型 (必填)"
#define YCLJ_BTN_STYLE          @"房屋属性 (必填)"

@interface YCLJNewUserViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *txtName;
@property (nonatomic, strong) UITextField *txtMobile;
@property (nonatomic, strong) UITextField *txtArea;
@property (nonatomic, strong) UIButton *btnStyle;
@property (nonatomic, strong) UIButton *btnCity;
@property (nonatomic, strong) UIButton *btnType;
@property (nonatomic, strong) UITextField *txtAddress;

@end

@implementation YCLJNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新增业主信息";
    
    [self addRightBtn];
    [self drawElements];
}

- (void)addRightBtn
{
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                   initWithTitle:@"保存"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(doSave:)];
    self.navigationItem.rightBarButtonItem = btnSave;
}

- (void)doSave:(id)sender
{
    DLog(@"name %@", _txtName.text);
    DLog(@"mobile %@", _txtMobile.text);
    DLog(@"city %@", _btnCity.currentTitle);
}

- (void)selectCity {
    
    YCHouseCityChoiceView * view = [[YCHouseCityChoiceView alloc] initWithFrame:self.view.frame];
    view.selectedBlock = ^(NSString * province, NSString * city, NSString * area){
        NSString *strCity = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        [_btnCity setTitle:strCity forState:UIControlStateNormal];
        [_btnCity setTitleColor:HEX_COLOR(@"0x333333") forState:UIControlStateNormal];
    };
    
    [self.view addSubview:view];
}

- (void)selectType {
    
    YCHouseTypeChoiceView * view = [[YCHouseTypeChoiceView alloc] initWithFrame:self.view.frame];
    view.selectedBlock = ^(NSString * type){
        NSString *strType = [NSString stringWithFormat:@"%@", type];
        [_btnType setTitle:strType forState:UIControlStateNormal];
        [_btnType setTitleColor:HEX_COLOR(@"0x333333") forState:UIControlStateNormal];
    };
    
    [self.view addSubview:view];
}

- (void)drawElements
{
    CGRect bgFrame = CGRectMake(0, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT);
    UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    CGFloat offsetY = 30;
    
    // 业主姓名
    CGFloat nameX = 50;
    CGFloat nameY = 70;
    CGFloat nameW = (YC_SCREEN_WIDTH - (nameX * 3))/2;
    CGFloat nameH = 40;
    CGRect nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    if (!_txtName) {
        _txtName = [[UITextField alloc] init];
        _txtName.frame = nameF;
        _txtName.placeholder = @"业主姓名 (必填)";
        [self changeTxtStyle:_txtName];
    }
    
    // 手机号
    CGFloat mobileX = YC_SCREEN_WIDTH/2 + nameX/2;
    CGFloat mobileY = nameY;
    CGRect mobileF = CGRectMake(mobileX, mobileY, nameW, nameH);
    
    if (!_txtMobile) {
        _txtMobile = [[UITextField alloc] init];
        _txtMobile.frame = mobileF;
        _txtMobile.placeholder = @"手机号 (必填)";
        [self changeTxtStyle:_txtMobile];
    }
    
    // 建筑面积
    CGFloat areaX = nameX;
    CGFloat areaY = nameY + nameH + offsetY;
    CGRect areaF = CGRectMake(areaX, areaY, nameW, nameH);
        
    if (!_txtArea) {
        _txtArea = [[UITextField alloc] init];
        _txtArea.frame = areaF;
        _txtArea.placeholder = @"建筑面积 (必填)";
        [self changeTxtStyle:_txtArea];
    }
    
    // 房屋类型
    CGFloat typeX = mobileX;
    CGFloat typeY = nameY + (nameH + offsetY);
    CGRect typeF = CGRectMake(typeX, typeY, nameW, nameH);
    
    if (!_btnType) {
        _btnType = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnType.frame = typeF;
        [_btnType setTitle:YCLJ_BTN_TYPE forState:UIControlStateNormal];
        [_btnType addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
        [self changeBtnStyle:_btnType];
    }
    
    // 所在地区
    CGFloat cityX = nameX;
    CGFloat cityY = nameY + 2 * (nameH + offsetY);
    CGRect cityF = CGRectMake(cityX, cityY, nameW, nameH);
    
    if (!_btnCity) {
        _btnCity = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCity.frame = cityF;
        [_btnCity setTitle:YCLJ_BTN_CITY forState:UIControlStateNormal];
        [_btnCity addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [self changeBtnStyle:_btnCity];
    }

    // 房屋属性
    CGFloat styleX = mobileX;
    CGFloat styleY = nameY + 2 * (nameH + offsetY);
    CGRect styleF = CGRectMake(styleX, styleY, nameW, nameH);
    
    if (!_btnStyle) {
        _btnStyle = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnStyle.frame = styleF;
        [_btnStyle setTitle:YCLJ_BTN_STYLE forState:UIControlStateNormal];
        [_btnStyle addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [self changeBtnStyle:_btnStyle];
    }
    
    // 房屋位置
    CGFloat addressX = nameX;
    CGFloat addressY = nameY + 3 * (nameH + offsetY);
    CGFloat addressW = YC_SCREEN_WIDTH - 2 * nameX;
    CGRect addressF = CGRectMake(addressX, addressY, addressW, nameH);
        
    if (!_txtAddress) {
        _txtAddress = [[UITextField alloc] init];
        _txtAddress.frame = addressF;
        _txtAddress.placeholder = @"房屋位置 (必填)";
        [self changeTxtStyle:_txtAddress];
    }
    
    // 添加元素
    [bgView addSubview:_txtName];
    [bgView addSubview:_txtMobile];
    [bgView addSubview:_txtArea];
    [bgView addSubview:_txtAddress];
    [bgView addSubview:_btnCity];
    [bgView addSubview:_btnType];
    [bgView addSubview:_btnStyle];
    
    [self.view addSubview:bgView];

}

- (void)changeTxtStyle:(UITextField *)textField
{
    CGFloat offsetInX = 10;
    CGFloat textH = 30;
    
    textField.textColor = HEX_COLOR(@"0x333333");
    textField.font = Font(15);
    
    textField.delegate = self;
    textField.layer.cornerRadius = 5.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [HEX_COLOR(@"0xBFBFBF") CGColor];
    textField.layer.borderWidth = 1.0f;
    textField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(offsetInX, 0, offsetInX, textH)];
    textField.leftViewMode  = UITextFieldViewModeAlways;
    
//    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:HEX_COLOR(@"0xBFBFBF"), NSFontAttributeName:FontSystem(15)}];
}

- (void)changeBtnStyle:(UIButton *)btn
{
    CGFloat offsetInX = 10;
    
    btn.titleLabel.font = Font(15);
    [btn setTitleColor:HEX_COLOR(@"0xC8C8C8") forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [HEX_COLOR(@"0xBFBFBF") CGColor];
    btn.layer.borderWidth = 1.0f;
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, offsetInX, 0, 0);
    
    [btn setImage:GetImageByName(@"ycArrow") forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.frame.size.width - 40, 0, 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)checkValue
{
    if (_txtName.text.length == 0 || [_txtName.text isEqualToString:@""]) {
        
        ShowAlertWithOneButton(self, @"提示", @"姓名为空", @"OK");
        return NO;
    }
    
    if (_txtMobile.text.length == 0 || [_txtMobile.text isEqualToString:@""]) {
        
        ShowAlertWithOneButton(self, @"提示", @"手机号为空", @"OK");
        return NO;
    }
    
    if (_txtArea.text.length == 0 || [_txtArea.text isEqualToString:@""]) {
        
        ShowAlertWithOneButton(self, @"提示", @"房屋面积为空", @"OK");
        return NO;
    }
    
    if ([_btnType.currentTitle isEqualToString:YCLJ_BTN_TYPE]) {
        
        ShowAlertWithOneButton(self, @"提示", @"房屋类型为空", @"OK");
        return NO;
    }
    
    if ([_btnStyle.currentTitle isEqualToString:YCLJ_BTN_STYLE]) {
        
        ShowAlertWithOneButton(self, @"提示", @"房屋属性为空", @"OK");
        return NO;
    }
    
    if ([_btnCity.currentTitle isEqualToString:YCLJ_BTN_CITY]) {
        
        ShowAlertWithOneButton(self, @"提示", @"房屋所在地区为空", @"OK");
        return NO;
    }

    if (_txtAddress.text.length == 0 || [_txtAddress.text isEqualToString:@""]) {
        
        ShowAlertWithOneButton(self, @"提示", @"房屋位置为空", @"OK");
        return NO;
    }

    
    return YES;
}

/*
- (void)btnOK:(id)sender {
    
    if ([self checkValue]) {
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        [userDict setObject:_popTxtName.text forKey:@"name"];
        [userDict setObject:_popTxtContact.text forKey:@"mobile"];
        [userDict setObject:_popTxtHouse.text forKey:@"address"];
        [userDict setObject:_popTxtArea.text forKey:@"area"];
        
        UserModel *userModel = [UserModel newWithDict:userDict];
        
        _userId = [HouseFmdbTool insertUserModel:userModel];
        
        [self transHouseData];
        
    } else {
        
        NSLog(@"请输入户型名称");
    }
}
*/

@end
