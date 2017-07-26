//
//  YCLJNewUserViewController.m
//  YCLJ
//
//  Created by Adam on 2017/7/26.
//  Copyright © 2017年 YunChuang. All rights reserved.
//

#import "YCLJNewUserViewController.h"

@interface YCLJNewUserViewController ()

@property (nonatomic, strong) UITextField *txtName;
@property (nonatomic, strong) UITextField *txtMobile;
@property (nonatomic, strong) UITextField *txtArea;
@property (nonatomic, strong) UITextField *txtStyle;
@property (nonatomic, strong) UITextField *txtCity;
@property (nonatomic, strong) UITextField *txtType;
@property (nonatomic, strong) UITextField *txtAddress;

@end

@implementation YCLJNewUserViewController
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新增业主信息";
    [self drawElements];
}

- (void)drawElements
{
    CGRect bgFrame = CGRectMake(0, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT);
    UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    CGFloat offsetY = 30;
    // 业主姓名
    CGFloat nameX = 30;
    CGFloat nameY = 65;
    CGFloat nameW = YC_SCREEN_WIDTH/3;
    CGFloat nameH = 20;
    CGRect nameF = CGRectMake(nameX, nameY, nameW, nameH);
    _txtName = [[UITextField alloc] init];
    _txtName.frame = nameF;
    _txtName.placeholder = @"业主姓名 (必填)";
    
    // 手机号
    CGFloat mobileX = YC_SCREEN_WIDTH/2 + 10;
    CGFloat mobileY = nameY;
    CGRect mobileF = CGRectMake(mobileX, mobileY, nameW, nameH);
    _txtMobile = [[UITextField alloc] init];
    _txtMobile.frame = mobileF;
    _txtMobile.placeholder = @"手机号 (必填)";

    // 建筑面积
    CGFloat areaX = nameX;
    CGFloat areaY = nameY + nameH + offsetY;
    CGRect areaF = CGRectMake(areaX, areaY, nameW, nameH);
    _txtArea = [[UITextField alloc] init];
    _txtArea.frame = areaF;
    _txtArea.placeholder = @"建筑面积 (必填)";
    
    // 所在地区
    CGFloat cityX = nameX;
    CGFloat cityY = nameY + 2 * (nameH + offsetY);
    CGRect cityF = CGRectMake(cityX, cityY, nameW, nameH);
    _txtCity = [[UITextField alloc] init];
    _txtCity.frame = cityF;
    _txtCity.placeholder = @"所在地区 (必填)";
    
    // 房屋位置
    CGFloat addressX = nameX;
    CGFloat addressY = nameY + 3 * (nameH + offsetY);
    CGRect addressF = CGRectMake(addressX, addressY, nameW, nameH);
    _txtAddress = [[UITextField alloc] init];
    _txtAddress.frame = addressF;
    _txtAddress.placeholder = @"房屋位置 (必填)";

    // 添加元素
    [bgView addSubview:_txtName];
    [bgView addSubview:_txtMobile];
    [bgView addSubview:_txtArea];
    [bgView addSubview:_txtCity];
    [bgView addSubview:_txtAddress];
    
    [self.view addSubview:bgView];

}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

    /*
    - (BOOL)checkValue
    {
        if (_popTxtName.text.length == 0 || [_popTxtName.text isEqualToString:@""]) {
            
            ShowAlertWithOneButton(self, @"提示", @"姓名为空", @"OK");
            return NO;
        }
        
        if (_popTxtContact.text.length == 0 || [_popTxtContact.text isEqualToString:@""]) {
            
            ShowAlertWithOneButton(self, @"提示", @"手机号为空", @"OK");
            return NO;
        }
        
        if (_popTxtHouse.text.length == 0 || [_popTxtHouse.text isEqualToString:@""]) {
            
            ShowAlertWithOneButton(self, @"提示", @"小区名称为空", @"OK");
            return NO;
        }
        
        if (_popTxtArea.text.length == 0 || [_popTxtArea.text isEqualToString:@""]) {
            
            ShowAlertWithOneButton(self, @"提示", @"面积为空", @"OK");
            return NO;
        }
        
        return YES;
    }
    
- (IBAction)btnOK:(id)sender {
    
    NSLog(@"name %@, contact %@ style %@", _popTxtName.text, _popTxtContact.text, _popTxtHouse.text);
    
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
    
- (IBAction)btnCancel:(id)sender {
    
    _popView.hidden = YES;
    self.tempHouseID = nil;
}
*/
    
@end
