
#import "YCPopViewExtension.h"

@implementation YCPopViewExtension

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置模板层背景色
        self.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        
        _tipebackView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.frame.size.height - 150)/2, self.frame.size.width - 40, 150)];
        _tipebackView.backgroundColor = [UIColor whiteColor];
        _tipebackView.layer.cornerRadius = 5;
        [self addSubview:_tipebackView];
        
        _tipeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _tipebackView.frame.size.width - 20, _tipebackView.frame.size.height - 20)];
        _tipeLabel.textAlignment = NSTextAlignmentCenter;
        _tipeLabel.numberOfLines = 0;
        [_tipebackView addSubview:_tipeLabel];
        
        _closeImg = [[UIImageView alloc] init];
        _closeImg.image = GetImageByName(@"ycClose");
        [_tipebackView addSubview:_closeImg];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.tag = 3000;
        [_closeBtn addTarget:self action:@selector(btnClickSelector:) forControlEvents:UIControlEventTouchUpInside];
        [_tipebackView addSubview:_closeBtn];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 2000;
        [_cancelBtn setTitle:@"新建业主信息" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX_COLOR(@"0x333333") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = Font(15);
        [_cancelBtn addTarget:self action:@selector(btnClickSelector:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = HEX_COLOR(@"0xffffff");
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.borderWidth = 1.f;
        _cancelBtn.layer.borderColor = HEX_COLOR(@"0x666666").CGColor;
        [_tipebackView addSubview:_cancelBtn];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.tag = 1000;
        [_sureBtn setTitle:@"选择已有业主信息" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX_COLOR(@"0xffffff") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = Font(15);
        [_sureBtn addTarget:self action:@selector(btnClickSelector:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = HEX_COLOR(@"0xDE3031");
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.borderColor = HEX_COLOR(@"0x666666").CGColor;
        [_tipebackView addSubview:_sureBtn];
    }
    
    return self;
}

//设置提示view的宽高
-(void)setbackviewframeWidth:(CGFloat)width Andheight:(CGFloat)height
{
    CGFloat tipeheight = (self.frame.size.height-height)/2;
    CGFloat tipewidth = (self.frame.size.width-width)/2;
    _tipebackView.frame = CGRectMake(tipewidth, tipeheight-30, width, height);
    
    CGFloat closeW = 45;
    _closeBtn.frame = CGRectMake(_tipebackView.frame.size.width - closeW, 0, closeW, closeW);
    _closeImg.backgroundColor = [UIColor redColor];
    _closeImg.frame = CGRectMake(_tipebackView.frame.size.width - 31, 9, 21, 21);
    
    CGFloat btnX = 65;
    CGFloat btnH = 40;
    _cancelBtn.frame = CGRectMake(btnX, 35, _tipebackView.frame.size.width-2*btnX, btnH);
    _sureBtn.frame = CGRectMake(btnX, 90, _tipebackView.frame.size.width-2*btnX, btnH);
}

//设置提示语
-(void)settipeTitleStr:(NSString *)tipeStr fontSize:(CGFloat)fontSize
{
    _tipeLabel.font = Font(fontSize);
    _tipeLabel.text = tipeStr;
}

//按钮方法
-(void)btnClickSelector:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickBtnSelector:)]) {
        [self.delegate clickBtnSelector:btn];
    }
}

@end
