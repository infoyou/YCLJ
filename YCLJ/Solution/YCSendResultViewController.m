//
//  YCSendResultViewController.m
//  YCLJSDK
//
//  Created by Adam on 2017/8/14.
//  Copyright © 2017年 Adam. All rights reserved.
//

#import "YCSendResultViewController.h"

@interface YCSendResultViewController ()

@property(nonatomic,strong) UIImageView *imgBarCode;
@property(nonatomic,strong) UILabel *labResult;
@property(nonatomic,strong) UILabel *labNote;

@end

@implementation YCSendResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发送成功";
    
    [self drawUI];
    [self setFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawUI
{
    CGFloat fontSize = 18;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YC_SCREEN_WIDTH, YC_SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    // name
    _labResult = [[UILabel alloc] init];
    _labResult.font = FontBold(fontSize);
    _labResult.textColor = HEX_COLOR(@"0x6495E6");
    _labResult.text = @"测量数据发送成功";
    _labResult.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_labResult];
    
    // mobile label
    _labNote = [[UILabel alloc] init];
    _labNote.font = Font(fontSize-2);
    _labNote.textColor = HEX_COLOR(@"0x999999");
    _labNote.text = @"业主可扫描二维码下载业主端app查看测量数据";
    _labNote.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_labNote];
    
    // barcode img
    _imgBarCode = [[UIImageView alloc] init];
    _imgBarCode.image = GetImageByName(@"ycBarCode");
    [bgView addSubview:_imgBarCode];

}

- (void)setFrame
{
    // result
    _labResult.frame = CGRectMake(0, 80, YC_SCREEN_WIDTH, 25);
    // note label
    _labNote.frame = CGRectMake(0, 120, YC_SCREEN_WIDTH, 25);
    // barcode img
    CGFloat barCodeWH = 128.0;
    CGFloat barCodeX = (YC_SCREEN_WIDTH - barCodeWH)/2;
    _imgBarCode.frame = CGRectMake(barCodeX, 180, barCodeWH, barCodeWH);
    
}

@end
